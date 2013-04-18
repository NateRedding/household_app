require 'spec_helper'

describe IngredientMeasure do

  before(:each) do
    category = RecipeCategory.create(:name => 'Desserts')
    @recipe = category.recipes.create(:name => 'Cookies', :directions => 'Mix ingredients, bake and enjoy!')
    @attr = { :name => 'flour', :unit => 'cup', :amount => 3 }
  end

  describe "attributes" do
    before(:each) do
      @ingredient = @recipe.ingredient_measures.create!(@attr)
    end

    it "should have a name" do
      @ingredient.should respond_to(:name)
    end

    it "should have an amount" do
      @ingredient.should respond_to(:amount)
    end

    it "should have a unit of measure" do
      @ingredient.should respond_to(:unit)
    end
  end

  describe "validations" do
    it "should require a name" do
      lambda do
        @ingredient = @recipe.ingredient_measures.create!(@attr.merge(:name => ''))
      end.should raise_error(ActiveRecord::RecordInvalid)
    end

    it "should require an amount" do
      lambda do
        @ingredient = @recipe.ingredient_measures.create!(@attr.merge(:amount => ''))
      end.should raise_error(ActiveRecord::RecordInvalid)
    end

    it "should require a unit of measure" do
      lambda do
        @ingredient = @recipe.ingredient_measures.create!(@attr.merge(:unit => ''))
      end.should raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "relationships" do
    it "should belong to a recipe" do
      @ingredient = @recipe.ingredient_measures.create!(@attr)
      @ingredient.should respond_to(:recipe)
    end
  end
end
