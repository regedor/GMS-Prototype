class RecipesController < ApplicationController

  def show
    @recipe = Recipe.find params[:id]
    if params[:vote]
      @recipe.current_vote = params[:vote]
      unless @recipe.save
        flash[:error] = t('flash.recipes_vote_error')
      end
    end
  end

  def index
    @recipes = Recipe.all
  end

end