class Recipe < ActiveRecord::Base
  
  # ==========================================================================
  # Relationships
  # ==========================================================================

  belongs_to :recipe_dificulty
  belongs_to :recipe_category
  has_one :image, :dependent => :destroy
  has_many :recipes_votes
  has_many :users, :through => :recipes_votes
  accepts_nested_attributes_for :image, :allow_destroy => true


  # ==========================================================================
  # Validations
  # ==========================================================================

  validates_presence_of :name, :image_id, :recipe_category_id, :publication_date, :ingredients, :preparation_description, 
                        :message => I18n::t('flash.cant_be_blank')
  validates_format_of :duration_in_minutes, :with => /^(\d+|curta|média|longa)$/, :message => I18n::t('flash.invalid_format')
  validate :vote_value

  # ==========================================================================
  # Extra definitions
  # ==========================================================================

  before_save do |instance|
    instance.image.destroy   if instance.image_delete == "1"
  end
  attr_writer :image_delete
  attr_accessor :current_vote, :voting
  
  before_save :do_voting_average


  # ==========================================================================
  # Instance Methods
  # ==========================================================================

  def image_delete ; @image_delete ||= "0" ; end  
  
  def has_vote_by(user)
    RecipesVote.first(:conditions => ["user_id = ? and recipe_id = ?",user.id,self.id])
  end
  
  def prepare_for_next_vote(previous_vote = 0)
    self.number_of_votes +=1 if previous_vote == 0
    self.voting_total += self.current_vote.to_i-previous_vote
  end
  
  private
  
  def vote_value
    unless current_vote.to_i.between? 1,5
      errors.add(:current_vote, "current vote is not between accepted range")
    end if current_vote
  end
  
  def do_voting_average
    if current_user && self.voting
      if previous_vote = self.has_vote_by(current_user)
        self.prepare_for_next_vote previous_vote.vote
        self.voting_average = self.voting_total / self.number_of_votes
        previous_vote.update_attributes :vote => self.current_vote
      else
        if self.voting_average
          self.prepare_for_next_vote
          self.voting_total / self.number_of_votes
        else
          self.voting_average = self.current_vote
          self.voting_total = self.current_vote
          self.number_of_votes = 1
        end
        RecipesVote.create :user_id => current_user.id, :recipe_id => self.id, :vote => self.current_vote
      end
    end
  end
  

  # ==========================================================================
  # Class Methods
  # ==========================================================================

  class << self
    
  end
  
end