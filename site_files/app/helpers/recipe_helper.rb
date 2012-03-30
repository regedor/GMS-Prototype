module RecipeHelper

  # Acceptable types are :sobremesa, :prato_principal, :entrada
  def recipe_of_the_day(type = :entrada)
    category = type.titleize

    # If recipe category is deleted, cache must be deleted as well
    category_id = Rails.cache.fetch("recipe-category-for-#{type}") {
      RecipeCategory.find_by_name(category, :select => :id).id
    }

    recipe = Recipe.find(:last,
      :conditions=>["DATE(publication_date) <= ? and recipe_category_id = ?", Date.today, category_id],
      :include => :image)

    render 'recipes/recipe_of_the_day', :recipe => recipe, :category => RecipeCategory.get_type_id(type)
  end
end
