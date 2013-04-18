class IngredientMeasure < ActiveRecord::Base
  attr_accessible(:amount, :name, :unit)

  validates(:name, :presence => true)
  validates(:amount, :presence => true)
  validates(:unit, :presence => true)

  belongs_to(:recipe)
end
