require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative 'cookbook'    # You need to create this file!
require_relative 'controller'  # You need to create this file!
require 'csv'
require_relative 'recipe'
require_relative 'scrape'

set :bind, '0.0.0.0'

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end
get '/' do
  cookbook = Cookbook.new('recipies.csv')
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :create
end

get '/post' do
  cookbook = Cookbook.new('recipies.csv')
  name = params[:name]
  description = params[:description]
  prep_time = params[:prep_time]
  difficulty = params[:difficulty]
  recipe = Recipe.new(name, description, prep_time, difficulty)
  cookbook.add_recipe(recipe)
  redirect to '/'
end

get '/destroy' do
  cookbook = Cookbook.new('recipies.csv')
  @recipes = cookbook.all
  erb :add_re
end

get '/index_delete' do
  cookbook = Cookbook.new('recipies.csv')
  index_to_delete = params[:index].to_i
  cookbook.remove_recipe(index_to_delete)
  redirect to '/'
end

get '/view' do
  cookbook = Cookbook.new('recipies.csv')
  index_to_view = params[:index].to_i
  @recipe = cookbook.ret_recipe(index_to_view)
  erb :view
end

get '/import_form' do
  erb :import_form
end

FINDINGS = []
get '/import' do
  scrape = Scrape.new
  @findings = scrape.scrape_term(params[:ingredient], 5)
  FINDINGS = @findings
  erb :import
end

get '/save_new' do
  cookbook = Cookbook.new('recipies.csv')
  recipe = FINDINGS[params[:index].to_i]
  cookbook.add_recipe(recipe)
  redirect to '/'
end


get '/mark_read' do
  cookbook = Cookbook.new('recipies.csv')
  @index_to_view = params[:status].to_i
  erb :test
end
















