
class Category
  attr_reader :id
  attr_accessor :category
  
  # Initializes a new category object
  #
  # id (optional) - Integer of the category record in categories table
  def initialize(id=nil, category=nil)
    @id = id
    @category = category
  end

  # Get all category records from the category table
  #
  # Returns an Array of Category Objects
  def self.all
    results = CONNECTION.execute('SELECT * FROM categories;')
    results_as_objects = []
    
    results.each do |result_hash|
      results_as_objects << Category.new(result_hash["id"], result_hash["category"])
    end
    return results_as_objects
  end
  
  
  # Find a category based on its ID.
  #
  # id - The Integer ID of the category to return.
  #
  # Returns a Category object.
  def self.find(id)
    @id = id
    
    result = CONNECTION.execute("SELECT * FROM categories WHERE id = #{@id};").first
    temp_category = result["category"]
    
    Category.new(id, temp_category)
  end

  # Utility method gets category id and if none exists, returns false 
  #
  # category - The String that is used to search for its corresponding id
  #
  # Returns the category id number as an Integer
  def self.get_id(category)
    cat_id = CONNECTION.execute("SELECT id FROM categories WHERE category = '#{category}'") 
    if cat_id.count == 0
      return false
    else
      return cat_id.first['id'].to_i
    end 
  end


  # Utility methods to add, update and delete.  Note the delete prevents
  # erasing a record if its id is being used in the truck_parts table.
  def self.add(category)
    CONNECTION.execute("INSERT INTO categories (category) VALUES ('#{category}';")
  end

  def change_name(new_category)
    CONNECTION.execute("UPDATE categories SET name = '#{new_category}' WHERE id = #{@id};")
  end

  def delete
    category = CONNECTION.execute("SELECT COUNT(*) FROM truck_parts WHERE category_id = #{id};")
    if category == 0
      CONNECTION.execute("DELETE FROM categories WHERE id = #{@id};")
    else
      false
    end
  end


  # Method called on an instance of the Category class returns any parts from 
  # the truck_part table associated with the @id as an array.
  def truck_parts
    parts = []
    results = CONNECTION.execute("SELECT part_name FROM truck_parts WHERE category_id = #{@id};")
    results.each do |hash|
      parts << hash["part_name"]
    end
    return parts
  end

end