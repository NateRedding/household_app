class CreateIngredientMeasures < ActiveRecord::Migration
  def change
    create_table :ingredient_measures do |t|
      t.integer :recipe_id
      t.string :name
      t.string :unit
      t.float :amount

      t.timestamps
    end
  end
end
