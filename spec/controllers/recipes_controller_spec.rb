require 'spec_helper'

describe RecipesController do
  render_views

  before(:each) do
    @base_title = 'Recipes - '
    @new_title = @base_title + 'New Recipe'
    @edit_title = @base_title + 'Edit Recipe'
    @category = RecipeCategory.create(:name => 'Appetizers')
  end

  describe "GET 'show'" do
    before(:each) do
      @recipe = @category.recipes.create(:name => 'Nachos', :description => 'Super Cheesy Nachos', :directions => 'Come on, you know how to make nachos!!')
      @recipe.ingredient_measures.create(:amount => 1, :unit => 'bag', :name => 'tortilla chips')
      @recipe.ingredient_measures.create(:amount => 3, :unit => 'cups', :name => 'shredded cheese')
    end

    it "should have the right title" do
      get(:show, :id => @recipe, :recipe_category_id => @category)
      response.should have_selector('title', :content => @base_title + @category.name + ' - ' + @recipe.name)
      response.should be_success
    end

    it "should show all of the ingredients" do
      get(:show, :id => @recipe, :recipe_category_id => @category)
      @recipe.ingredient_measures.each do |ingredient|
        response.should have_selector('li', :content => ingredient.name)
      end
    end

    it "should have a link to edit the recipe" do
      get(:show, :id => @recipe, :recipe_category_id => @category)
      response.should have_selector('a', :href => edit_recipe_category_recipe_path(@category, @recipe))
    end

    it "should not have a link to delete the recipe" do
      get(:show, :id => @recipe, :recipe_category_id => @category)
      response.should_not have_selector('a', :href => recipe_category_recipe_path(@category, @recipe), :'data-method' => 'delete')
    end

    describe "admin mode" do
      it "should have a link to delete the recipe" do
        get(:show, :id => @recipe, :recipe_category_id => @category, :admin => true)
        response.should have_selector('a', :href => recipe_category_recipe_path(@category, @recipe), :'data-method' => 'delete')
      end
    end
  end

  describe "GET 'new'" do
    it "should have the right title" do
      get(:new, :recipe_category_id => @category)
      response.should be_success
      response.should have_selector('title', :content => @new_title)
    end

    it "should have a recipe form" do
      get(:new, :recipe_category_id => @category)
      response.should have_selector('form#new_recipe') do |content|
        content.should have_selector('label', :content => 'Name')
        content.should have_selector('input', :name => 'recipe[name]')
        content.should have_selector('label', :content => 'Description')
        content.should have_selector('textarea', :name => 'recipe[description]')
        content.should have_selector('label', :content => 'Directions')
        content.should have_selector('textarea', :name => 'recipe[directions]')
        content.should have_selector('input', :type => 'submit', :value => 'Save')
      end
    end
  end

  describe "POST 'create'" do
    describe "success" do
      before(:each) do
        @attr = { :name => 'Cake', :description => 'A luscious chocolate indulgence!', :directions => 'Mix and bake.' }
      end

      it "should create a new recipe" do
        lambda do
          post(:create, :recipe_category_id => @category.id, :recipe => @attr)
        end.should change(Recipe, :count).by(1)
      end

      it "should redirect to the 'show' page" do
        post(:create, :recipe_category_id => @category.id, :recipe => @attr)
        flash[:success].should =~ /created/i
        recipe = @category.recipes.first
        response.should redirect_to(recipe_category_recipe_path(@category, recipe))
      end
    end

    describe "failure" do
      before(:each) do
        @attr = { :name => '', :description => '', :directions => '' }
      end

      it "should render the 'new' page with error messages" do
        post(:create, :recipe_category_id => @category.id, :recipe => @attr)
        response.should render_template(:new)
        response.should have_selector('title', :content => @new_title)
        response.should have_selector('div#error_explanation')
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @recipe = @category.recipes.create(:name => 'Nachos', :description => 'Super Cheesy Nachos', :directions => 'Come on, you know how to make nachos!!')
      @recipe.ingredient_measures.create(:amount => 1, :unit => 'bag', :name => 'tortilla chips')
      @recipe.ingredient_measures.create(:amount => 3, :unit => 'cups', :name => 'shredded cheese')
    end

    it "should have the right title" do
      get(:edit, :id => @recipe, :recipe_category_id => @category)
      response.should be_success
      response.should have_selector('title', :content => @edit_title)
    end

    it "should have a recipe form" do
      get(:edit, :id => @recipe, :recipe_category_id => @category)
      response.should have_selector("form#edit_recipe_#{@recipe.id}") do |content|
        content.should have_selector('label', :content => 'Name')
        content.should have_selector('input', :name => 'recipe[name]')
        content.should have_selector('label', :content => 'Description')
        content.should have_selector('textarea', :name => 'recipe[description]')
        content.should have_selector('label', :content => 'Directions')
        content.should have_selector('textarea', :name => 'recipe[directions]')
        content.should have_selector('input', :type => 'submit', :value => 'Save')
      end
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @recipe = @category.recipes.create(:name => 'Nachos', :description => 'Super Cheesy Nachos', :directions => 'Come on, you know how to make nachos!!')
      @recipe.ingredient_measures.create(:amount => 1, :unit => 'bag', :name => 'tortilla chips')
      @recipe.ingredient_measures.create(:amount => 3, :unit => 'cups', :name => 'shredded cheese')
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "Super Fun Nachos", :description => 'The best nachos you have ever tasted!', :directions => 'I think you can figure it out...' }
      end

      it "should save the recipe" do
        put(:update, :id => @recipe, :recipe_category_id => @category, :recipe => @attr)
        recipe = assigns(:recipe)
        @recipe.reload
        @recipe.name.should == recipe.name
        @recipe.description.should == recipe.description
        @recipe.directions.should == recipe.directions
      end

      it "should redirect to the show page" do
        put(:update, :id => @recipe, :recipe_category_id => @category, :recipe => @attr)
        flash[:success].should =~ /updated/i
        response.should redirect_to(recipe_category_recipe_path(@category, @recipe))
      end
    end

    describe "failure" do
      before(:each) do
        @attr = { :name => '', :description => '', :directions => '' }
      end

      it "should render the 'edit' page with error messages" do
        put(:update, :id => @recipe, :recipe_category_id => @category, :recipe => @attr)
        response.should render_template(:edit)
        response.should have_selector('title', :content => @edit_title)
        response.should have_selector('div#error_explanation')
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @recipe = @category.recipes.create(:name => 'Nachos', :description => 'Super Cheesy Nachos', :directions => 'Come on, you know how to make nachos!!')
      @recipe.ingredient_measures.create(:amount => 1, :unit => 'bag', :name => 'tortilla chips')
      @recipe.ingredient_measures.create(:amount => 3, :unit => 'cups', :name => 'shredded cheese')
    end

    it "should destroy the recipe" do
      lambda do
        delete(:destroy, :id => @recipe, :recipe_category_id => @category)
      end.should change(Recipe, :count).by(-1)
    end

    it "should destroy the recipe ingredients" do
      lambda do
        delete(:destroy, :id => @recipe, :recipe_category_id => @category)
      end.should change(IngredientMeasure, :count).by(-2)
    end

    it "should redirect to the category 'show' page" do
      delete(:destroy, :id => @recipe, :recipe_category_id => @category)
      flash[:success].should =~ /deleted/i
      response.should redirect_to(recipe_category_path(@category))
    end
  end
end
