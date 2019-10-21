require_relative 'cookbook'
require_relative 'recipe'
require_relative 'scrape'

class Controller
  def initialize(cookbook)
    @cookbook = cookbook
    @view = View.new
    @scrape = Scrape.new
  end

  def list
    display_list
  end

  def create
    recipe_name = @view.ask_for_name
    recipe_description = @view.ask_for_description
    recipe_prep_time = @view.ask_for_prep_time
    recipe_difficulty = @view.ask_for_difficulty
    recipe = Recipe.new(recipe_name, recipe_description, recipe_prep_time, recipe_difficulty)
    @cookbook.add_recipe(recipe)
  end

  def destroy
    display_list
    index_delete = @view.ask_for_index
    @cookbook.remove_recipe(index_delete)
  end

  def import
    ingredient = @view.ask_for_ingredient
    findings = @scrape.scrape_term(ingredient, 5)
    @view.display_findings(findings)
    recipe = findings[@view.ask_for_index]
    @view.confirm_import(recipe)
    @cookbook.add_recipe(recipe)
  end

  def detailed_view
    display_list
    index_view = @view.ask_for_index
    recipe = @cookbook.ret_recipe(index_view)
    @view.display_item(recipe)
  end

  def mark_read
    display_list
    index_mark = @view.ask_for_index
    recipe = @cookbook.ret_recipe(index_mark)
    recipe.mark_as_done
    @cookbook.save
  end

  private

  def display_list
    recipes = @cookbook.all
    @view.display_list(recipes)
  end
end
