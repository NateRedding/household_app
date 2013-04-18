class RecipeCategory < ActiveRecord::Base
  attr_accessible(:name)

  validates(:name, :presence => true)

  has_many(:recipes, :dependent => :destroy)
end
