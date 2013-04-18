require 'spec_helper'

describe RecipeCategoriesController do
  render_views

  before(:each) do
    @base_title = 'Recipes - '
    @index_title = @base_title + 'Categories'
    @new_title = @base_title + 'New Category'
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
        response.should have_selector('a', :href => recipe_path(recipe), :content => recipe.name)
      end
    end

    it "should have a link to create a new recipe" do
      get(:show, :id => @category)
      response.should have_selector('a', :href => new_recipe_path)
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
        content.should have_selector('input', :type => 'submit', :value => 'Create')
      end
    end
  end

  describe "POST 'create'" do
    describe "success" do
      before(:each) do
        @attr = { name: 'Appetizers' }
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
        @attr = { name: '' }
      end

      it "should render the 'new' page with error messages" do
        post(:create, :recipe_category => @attr)
        response.should render_template(:new)
        response.should have_selector('title', :content => @new_title)
        response.should have_selector('div#error_explanation')
      end

    end
  end
end
