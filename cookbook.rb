require 'csv'
require_relative 'recipe'

class Cookbook
  attr_reader :recipes
  def initialize(csv_file_path = nil)
    @csv_file_path = csv_file_path
    @recipes = []
    convert_csv unless csv_file_path.nil?
  end

  def all
    return @recipes
  end

  def add_recipe(recipe)
    @recipes << recipe
    save
  end

  def remove_recipe(recipe_index)
    @recipes.delete_at(recipe_index)
    save
  end

  def ret_recipe(recipe_index)
    @recipes[recipe_index]
  end

  def save
    save_csv unless @csv_file_path.nil?
  end

  private

  def convert_csv
    csv_options = { col_sep: ',', quote_char: '"' }
    CSV.foreach(@csv_file_path, csv_options) do |row|
      new_recipe = Recipe.new(row[0], row[1], row[2], row[3], (row[4] == "true"))
      add_recipe(new_recipe)
    end
  end

  def save_csv
    csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    CSV.open(@csv_file_path, "wb", csv_options) do |csv|
      recipes.each do |recipe|
        csv << [recipe.name.to_s, recipe.description.to_s, recipe.prep_time.to_s, recipe.difficulty.to_s, recipe.status.to_s]
      end
    end
  end
end
