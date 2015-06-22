require "pry"
require "sinatra"
require "sinatra/reloader"
require "sqlite3"
require 'active_support/all'

 # Load/create our database for this program.
 CONNECTION = SQLite3::Database.new("heavytruckparts.db")
 

# Make the tables.
CONNECTION.execute("CREATE TABLE IF NOT EXISTS categories (id INTEGER PRIMARY KEY, category TEXT);")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS zip_codes (id INTEGER PRIMARY KEY, zip_code INTEGER);")
CONNECTION.execute("CREATE TABLE IF NOT EXISTS truck_parts (id INTEGER PRIMARY KEY, part_name TEXT, category_id INTEGER, zip_code_id INTEGER, quantity, INTEGER);")


 
 # Get results as an Array of Hashes.
 CONNECTION.results_as_hash = true


 # ---------------------------------------------------------------------

require_relative "truckpart.rb"
require_relative "category.rb"
require_relative "zipcode.rb"

get "/home" do
  erb :"homepage"
end

get "/list_parts" do
  erb :"list_parts"
end

get "/add_parts" do
  erb :"add_parts"
end

get "/parts_added" do
  
  if TruckPart.add(params)
    erb :"parts_added"  
  else
    "There was an error adding your part."
  end
  
end

get "/search_parts_category" do
  erb :"search_category_parts"
end

get "/search_parts_choice/:number" do
  erb :"list_chosen_parts"
end

get "/search_parts_zip_code" do
 erb :"search_zip_parts"
end
 
 get "/search_zip_parts_choice/:zip" do
   erb :"list_chosen_zip_parts"
end



