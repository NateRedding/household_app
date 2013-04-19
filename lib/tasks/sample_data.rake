namespace :db do

  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_recipes
  end

  def make_recipes
    appetizers = RecipeCategory.create!(:name => 'Appetizers')
    nachos = appetizers.recipes.create(:name => 'Nachos', :description => 'Super Cheesy Nachos', :directions => 'Come on, you know how to make nachos!!')
    nachos.ingredient_measures.create(:amount => 1, :unit => 'bag', :name => 'tortilla chips')
    nachos.ingredient_measures.create(:amount => 3, :unit => 'cups', :name => 'shredded cheese')
    eggs = appetizers.recipes.create(:name => "Mom's Deviled Eggs", :description => "I don't like them, but you might", :directions => 'Add a little devilishness!')
    eggs.ingredient_measures.create(:amount => 1, :unit => 'dozen', :name => 'large eggs')
    eggs.ingredient_measures.create(:amount => 1, :unit => 'pinch', :name => 'paprika')
    entrees = RecipeCategory.create!(:name => 'Entrees')
    chicken = entrees.recipes.create(:name => 'Thai Peanut Chicken', :description => 'Yummy in my tummy!', :directions => 'Mix ingredients. Enjoy!')
    chicken.ingredient_measures.create(:amount => 2, :unit => 'whole', :name => 'boneless skinless chicken breasts')
    chicken.ingredient_measures.create(:amount => 1, :unit => 'jar', :name => 'peanut butter')
    chicken.ingredient_measures.create(:amount => 3, :unit => 'units', :name => 'Thai')

    category_names = %w(Sides Desserts Snacks Drinks)
    category_names.each do |category_name|
      RecipeCategory.create!(:name => category_name)
    end

  end

end