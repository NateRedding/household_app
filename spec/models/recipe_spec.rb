require 'spec_helper'

describe Recipe do

  before(:each) do
    @category = RecipeCategory.create(:name => 'Desserts')
    @attr = { :name => 'Cookies', :directions => 'Mix ingredients, bake and enjoy!' }
  end

  describe "attributes" do
    before(:each) do
      @recipe = @category.recipes.create!(@attr)
    end

    it "should have a name" do
      @recipe.should respond_to(:name)
    end

    it "should have directions" do
      @recipe.should respond_to(:directions)
    end
  end

  describe "validations" do
    it "should require a name" do
      lambda do
        @category.recipes.create!(@attr.merge(:name => ''))
      end.should raise_error(ActiveRecord::RecordInvalid)
    end

    it "should require directions" do
      lambda do
        @category.recipes.create!(@attr.merge(:directions => ''))
      end.should raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "relationships" do
    before(:each) do
      @recipe = @category.recipes.create!(@attr)
    end

    it "should belong to a recipe category" do
      @recipe.should respond_to(:recipe_category)
    end

    it "should have ingredients" do
      @recipe.should respond_to(:ingredient_measures)
    end

  end
end
