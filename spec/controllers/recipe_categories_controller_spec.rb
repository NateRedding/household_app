require 'spec_helper'

describe RecipeCategoriesController do
  render_views

  before(:each) do
    @base_title = 'Recipes - '
    @index_title = @base_title + 'Categories'
    @new_title = @base_title + 'New Category'
    @edit_title = @base_title + 'Rename Category'
  end

  describe "GET 'index'" do
    before(:each) do
      RecipeCategory.create(:name => 'Appetizers')
      RecipeCategory.create(:name => 'Desserts')
    end

    it "should have the right title" do
      get(:index)
      response.should have_selector('title', :content => @index_title)
      response.should be_success
    end

    it "should have a link for all of the recipe categories" do
      get(:index)
      RecipeCategory.all.each do |category|
        response.should have_selector('a', :href => recipe_category_path(category), :content => category.name)
      end
    end

    it "should have a link to create a new category" do
      get(:index)
      response.should have_selector('a', :href => new_recipe_category_path)
    end

    it "should not have a link to delete each of the recipe categories" do
      get(:index)
      RecipeCategory.all.each do |category|
        response.should_not have_selector('a', :href => recipe_category_path(category), :'data-method' => 'delete')
      end
    end

    describe "admin mode" do
      it "should have a link to delete each of the recipe categories" do
        get(:index, :admin => true)
        RecipeCategory.all.each do |category|
          response.should have_selector('a', :href => recipe_category_path(category), :'data-method' => 'delete')
        end
      end
    end
  end

  describe "GET 'show'" do
    before(:each) do
      @category = RecipeCategory.create(:name => 'Appetizers')
      @category.recipes.create(:name => 'Nachos', :description => 'Super Cheesy Nachos', :directions => 'Come on, you know how to make nachos!!')
      @category.recipes.create(:name => "Mom's Deviled Eggs", :description => "I don't like them, but you might", :directions => 'Add a little devilishness!')
    end

    it "should have the right title" do
      get(:show, :id => @category)
      response.should have_selector('title', :content => @base_title + @category.name)
      response.should be_success
    end

    it "should have a link for all of the recipes" do
      get(:show, :id => @category)
      @category.recipes.each do |recipe|
        response.should have_selector('a', :href => recipe_category_recipe_path(@category, recipe), :content => recipe.name)
      end
    end

    it "should have a link to create a new recipe" do
      get(:show, :id => @category)
      response.should have_selector('a', :href => new_recipe_category_recipe_path(@category))
    end

    it "should have a link to rename the category" do
      get(:show, :id => @category)
      response.should have_selector('a', :href => edit_recipe_category_path(@category))
    end

    it "should not have a link to delete the category" do
      get(:show, :id => @category)
      response.should_not have_selector('a', :href => recipe_category_path(@category), :'data-method' => 'delete')
    end

    it "should not have a link to delete each of the recipes" do
      get(:show, :id => @category)
      @category.recipes.each do |recipe|
        response.should_not have_selector('a', :href => recipe_category_recipe_path(@category, recipe), :'data-method' => 'delete')
      end
    end

    describe "admin mode" do
      it "should have a link to delete the category" do
        get(:show, :id => @category, :admin => true)
        response.should have_selector('a', :href => recipe_category_path(@category), :'data-method' => 'delete')
      end

      it "should have a link to delete each of the recipes" do
        get(:show, :id => @category, :admin => true)
        @category.recipes.each do |recipe|
          response.should have_selector('a', :href => recipe_category_recipe_path(@category, recipe), :'data-method' => 'delete')
        end
      end
    end
  end

  describe "GET 'new'" do
    it "should have the right title" do
      get(:new)
      response.should be_success
      response.should have_selector('title', :content => @new_title)
    end

    it "should have a recipe category form" do
      get(:new)
      response.should have_selector('form#new_recipe_category') do |content|
        content.should have_selector('label', :content => 'Name')
        content.should have_selector('input', :name => 'recipe_category[name]')
        content.should have_selector('input', :type => 'submit', :value => 'Save')
      end
    end
  end

  describe "POST 'create'" do
    describe "success" do
      before(:each) do
        @attr = { :name => 'Appetizers' }
      end

      it "should create a new category" do
        lambda do
          post(:create, :recipe_category => @attr)
        end.should change(RecipeCategory, :count).by(1)
      end

      it "should redirect to the 'index' page" do
        post(:create, :recipe_category => @attr)
        flash[:success].should =~ /created/i
        response.should redirect_to(recipe_categories_path)
      end
    end

    describe "failure" do
      before(:each) do
        @attr = { :name => '' }
      end

      it "should render the 'new' page with error messages" do
        post(:create, :recipe_category => @attr)
        response.should render_template(:new)
        response.should have_selector('title', :content => @new_title)
        response.should have_selector('div#error_explanation')
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @category = RecipeCategory.create(:name => 'Appetizers')
    end

    it "should have the right title" do
      get(:edit, :id => @category)
      response.should be_success
      response.should have_selector('title', :content => @edit_title)
    end

    it "should have a recipe category form" do
      get(:edit, :id => @category)
      response.should have_selector("form#edit_recipe_category_#{@category.id}") do |content|
        content.should have_selector('label', :content => 'Name')
        content.should have_selector('input', :name => 'recipe_category[name]')
        content.should have_selector('input', :type => 'submit', :value => 'Save')
      end
    end
  end

  describe "PUT 'update'" do
    before(:each) do
      @category = RecipeCategory.create(:name => 'Appetizers')
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "Starters" }
      end

      it "should save the category" do
        put(:update, :id => @category, :recipe_category => @attr)
        category = assigns(:category)
        @category.reload
        @category.name.should == category.name
      end

      it "should redirect to the show page" do
        put(:update, :id => @category, :recipe_category => @attr)
        flash[:success].should =~ /updated/i
        response.should redirect_to(recipe_category_path(@category))
      end
    end

    describe "failure" do
      before(:each) do
        @attr = { :name => '' }
      end

      it "should render the 'edit' page with error messages" do
        put(:update, :id => @category, :recipe_category => @attr)
        response.should render_template(:edit)
        response.should have_selector('title', :content => @edit_title)
        response.should have_selector('div#error_explanation')
      end
    end
  end

  describe "DELETE 'destroy'" do
    before(:each) do
      @category = RecipeCategory.create(:name => 'Appetizers')
      recipe1 = @category.recipes.create(:name => 'Nachos', :description => 'Super Cheesy Nachos', :directions => 'Come on, you know how to make nachos!!')
      recipe1.ingredient_measures.create(:amount => 1, :unit => 'bag', :name => 'tortilla chips')
      recipe1.ingredient_measures.create(:amount => 3, :unit => 'cups', :name => 'shredded cheese')
      recipe2 = @category.recipes.create(:name => 'Nachos Without Cheese', :description => 'Itty Bitty Nachos Without Cheese', :directions => 'Come on, you know how to make nachos without cheese!!')
      recipe2.ingredient_measures.create(:amount => 1, :unit => 'handful', :name => 'tortilla chips')
    end

    it "should destroy the category" do
      lambda do
        delete(:destroy, :id => @category)
      end.should change(RecipeCategory, :count).by(-1)
    end

    it "should destroy its recipes" do
      lambda do
        delete(:destroy, :id => @category)
      end.should change(Recipe, :count).by(-2)
    end

    it "should destroy the recipes' ingredients" do
      lambda do
        delete(:destroy, :id => @category)
      end.should change(IngredientMeasure, :count).by(-3)
    end

    it "should redirect to the category index" do
      delete(:destroy, :id => @category)
      flash[:success].should =~ /deleted/i
      response.should redirect_to(recipe_categories_path)
    end
  end
end
