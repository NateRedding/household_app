namespace :db do

  desc 'Fill database with sample data'
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_recipes
  end

  def make_recipes
    appetizers = RecipeCategory.create!(:name => 'Appetizers')
    appetizers.recipes.create(:name => 'Nachos', :description => 'Super Cheesy Nachos', :directions => 'Come on, you know how to make nachos!!')
    appetizers.recipes.create(:name => "Mom's Deviled Eggs", :description => "I don't like them, but you might", :directions => 'Add a little devilishness!')
    entrees = RecipeCategory.create!(:name => 'Entrees')
    entrees.recipes.create(:name => 'Thai Peanut Chicken', :description => 'Yummy in my tummy!', :directions => 'Mix ingredients. Enjoy!')

    category_names = %w(Sides Desserts Snacks Drinks)
    category_names.each do |category_name|
      RecipeCategory.create!(:name => category_name)
    end

  end

end