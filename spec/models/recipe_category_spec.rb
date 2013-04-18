require 'spec_helper'

describe RecipeCategory do

  describe "attributes" do
    it "should have a name" do
      category = RecipeCategory.create!(:name => 'Desserts')
      category.should respond_to(:name)
    end
  end

  describe "validations" do
    it "should require a name" do
      category = RecipeCategory.new(:name => '')
      category.should_not be_valid
    end
  end

  describe "relationships" do
    it "should have recipes" do
      category = RecipeCategory.create!(:name => 'Desserts')
      category.should respond_to(:recipes)
    end
  end
end
