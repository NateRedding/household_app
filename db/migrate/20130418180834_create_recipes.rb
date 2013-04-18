class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer :recipe_category_id
      t.string :name
      t.text :description
      t.text :directions

      t.timestamps
    end
  end
end
