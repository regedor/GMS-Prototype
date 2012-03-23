module RecipeHelper


  # Acceptable types are :sobremesa, :prato_principal, :entrada
  def recipe_for_today(type = :entrada)
    category = type.titleize
    category_id = Rails.cache.fetch("recipe-category-for-#{type}"){
      RecipeCategory.find_by_name(category, :select => :id).id
    }
    
    p category_id
    recipe = Recipe.find(:last, 
        :conditions=>["DATE(publication_date) <= ? and recipe_category_id = ?",Date.today, category_id], 
        :include => :image)

    if recipe
      render 'recipes/todays_recipe', :recipe => recipe
    else
      "Não há #{category} para hoje... :("
    end
  end
end
