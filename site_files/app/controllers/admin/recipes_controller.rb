class Admin::RecipesController < Admin::BaseController
  filter_access_to :all, :require => any_as_privilege

  before_filter :date_localization, :only => [ :create, :update ]

  active_scaffold :recipe do |config|
    config.list.sorting = {:publication_date => :desc}
    Scaffoldapp::active_scaffold config, "admin.recipes",
      :list         => [ :name, :number_of_people, :duration_in_minutes, :publication_date ],
      :show         => [ :name, :image, :number_of_people, :duration_in_minutes, :publication_date ],
      :edit         => [],
      :create       => []
  end

  def new
    @recipe = Recipe.new :preparation_description => render_to_string(:partial => "admin/recipes/recipe_template",:layout => false)
    @image = Image.new
  end

  def create
    image = Image.create params[:recipe][:image_attributes]
    params[:recipe].delete [:image_attributes]
    @recipe = Recipe.new params[:recipe]
    @recipe.image_id = image.id
    if @recipe.save
      flash[:notice] = t("flash.recipe_created", :name => @recipe.name)
      redirect_to admin_recipes_path
    else
      @template.properly_show_errors(@recipe)
      flash.now[:error] = t("flash.recipe_not_created", :name => @recipe.name)
      render :new
    end
  end
  
  def edit
    @recipe = Recipe.find params[:id]
    @image = Image.new unless @recipe.image
  end
  
  def update
    @recipe = Recipe.find params[:id]
    unless @recipe.image
      image = Image.create params[:recipe][:image_attributes]
      params[:recipe].delete [:image_attributes]
      @recipe.image_id = image.id
    end

    if @recipe.update_attributes params[:recipe]
      flash[:notice] = t("flash.recipe_updated", :name => @recipe.name)
      redirect_to admin_recipes_path
    else
      @template.properly_show_errors(@recipe)
      flash.now[:error] = t("flash.recipe_not_updated", :name => @recipe.name)
      render :edit
    end
  end


  private

    def date_localization
      begin
        params[:recipe][:publication_date] = DateTime.strptime(params[:recipe][:publication_date], "%d/%m/%Y")
      rescue ArgumentError
        flash[:error] = t("flash.invalid_date")
        redirect_to :action => params[:action] == 'create' ? 'new' : 'edit'
        return
      end
    end

end
