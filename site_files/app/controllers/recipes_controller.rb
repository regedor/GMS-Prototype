class RecipesController < ApplicationController

  def show
    @recipe = Recipe.find params[:id]
  end

  def index
    @recipes = Recipe.all
  end

end