class RecipesController < ApplicationController

  before_filter(:init)

  def show
    @recipe = Recipe.find(params[:id])
    @category = @recipe.recipe_category
    @title = @base_title + @recipe.recipe_category.name + ' - ' + @recipe.name
  end

  def new
    @category = RecipeCategory.find(params[:recipe_category_id])
    @recipe = @category.recipes.new
    @title = @base_title + 'New Recipe'
  end

  def create
    @category = RecipeCategory.find(params[:recipe_category_id])
    @recipe = @category.recipes.build(params[:recipe])
    if @recipe.save
      redirect_to(recipe_category_recipe_path(@category, @recipe), :flash => { :success => 'Recipe created!' })
    else
      @title = @base_title + 'New Recipe'
      render(:new)
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    @category = @recipe.recipe_category
    @title = @base_title + 'Edit Recipe'
  end

  def update
    @recipe = Recipe.find(params[:id])
    @category = @recipe.recipe_category
    if @recipe.update_attributes(params[:recipe])
      redirect_to([@category, @recipe], :flash => { :success => 'Recipe updated.' })
    else
      @title = @base_title + 'Edit Recipe'
      render(:edit)
    end
  end

  def destroy
    recipe = Recipe.find(params[:id])
    @category = recipe.recipe_category
    recipe.destroy
    redirect_to(@category, :flash => { :success => 'Recipe deleted' })
  end

  private
    def init
      @base_title = 'Recipes - '
    end
end
