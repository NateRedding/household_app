class RecipeCategoriesController < ApplicationController

  before_filter(:init)

  def index
    @title = @base_title + 'Categories'
    @categories = RecipeCategory.all
  end

  def show
    @category = RecipeCategory.find(params[:id])
    @recipes = @category.recipes.paginate(:page => params[:page])
    @title = @base_title + @category.name
  end

  def new
    @category = RecipeCategory.new
    @title = @base_title + 'New Category'
  end

  def create
    @category = RecipeCategory.new(params[:recipe_category])
    if @category.save
      redirect_to(recipe_categories_path, :flash => { :success => 'Category created!' })
    else
      @title = @base_title + 'New Category'
      render(:new)
    end
  end

  def edit
    @category = RecipeCategory.find(params[:id])
    @title = @base_title + 'Rename Category'
  end

  def update
    @category = RecipeCategory.find(params[:id])
    if @category.update_attributes(params[:recipe_category])
      redirect_to(@category, :flash => { :success => "Category updated." })
    else
      @title = @base_title + 'Rename Category'
      render(:edit)
    end
  end

  def destroy
    category = RecipeCategory.find(params[:id])
    category.destroy
    redirect_to(recipe_categories_path, :flash => { :success => "Category deleted" })
  end

  private
    def init
      @base_title = 'Recipes - '
    end
end
