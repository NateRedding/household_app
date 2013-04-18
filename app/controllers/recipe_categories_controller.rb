class RecipeCategoriesController < ApplicationController

  def index
    @title = 'Recipes - Categories'
    @categories = RecipeCategory.all
  end

  def show
    @category = RecipeCategory.find(params[:id])
    @recipes = @category.recipes.paginate(:page => params[:page])
    @title = 'Recipes - ' + @category.name
  end

  def new
    @category = RecipeCategory.new
    @title = 'Recipes - New Category'
  end

  def create
    @category = RecipeCategory.new(params[:recipe_category])
    if @category.save
      redirect_to(recipe_categories_path, :flash => { :success => 'Category created!' })
    else
      @title = 'Recipes - New Category'
      render(:new)
    end
  end

  #def edit
  #  @title = "Edit user"
  #end

  #def update
  #  if @user.update_attributes(params[:user])
  #    redirect_to(@user, :flash => { :success => "Profile updated." })
  #  else
  #    @title = "Edit user"
  #    render 'edit'
  #  end
  #end

  #def destroy
  #  @user.destroy
  #  redirect_to(users_path, :flash => { :success => "User destroyed" })
  #end
end
