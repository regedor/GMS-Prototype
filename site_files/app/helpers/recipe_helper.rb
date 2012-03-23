module RecipeHelper

  # Acceptable types are :sobremesa, :prato_principal, :entrada
  def recipe_for_today(type = :entrada)
    category = type.titleize
    category_id = cache.fetch("recipe-category-for-#{type}") do
      RecipeCategory.find_by_name(category, :select => :id)
    end
    recipe = Recipe.find(:last, 
        :conditions=>["DATE(publication_date) <= ? and recipe_category_id = ?",Date.today, category_id], 
        :include => :image)

    if recipe
      raw(
        content_tag :span, :class => "recipe-title" do
              recipe.name
        end
      )+     
      raw(
        content_tag :span, :class => "recipe-image" do
              image_tag(recipe.image.multi_purpose_image.url(:thumb))
        end
      )
    else
      "Não há #{category} para hoje... :("
    end
  end
end
