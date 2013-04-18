class Recipe < ActiveRecord::Base
  attr_accessible(:description, :directions, :name)

  validates(:name, :presence => true)
  validates(:directions, :presence => true)
  validates(:recipe_category_id, :presence => true)

  belongs_to(:recipe_category)
  has_many(:ingredient_measures, :dependent => :destroy)
  accepts_nested_attributes_for(:ingredient_measures)
end
