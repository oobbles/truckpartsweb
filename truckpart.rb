class TruckPart
  attr_accessor :id, :part_name, :category_id, :zip_code_id, :quantity, :updated
    
    # Initializes a new truck_part object.
    #
    # id (optional) - Integer of the part_name record in truck_parts table.
    #
    # part_name (optional) - String of the part name.
    #
    # category_id (optional) - Integer representing category name in Category 
    # table.
    # zip_code_id (optional) - Integer representing zip code in Zipcode table.
    #
    # quantity (optional) - Integer of total specific parts in specific 
    # location.
    def initialize(id=nil, part_name=nil, category_id=nil, zip_code_id=nil, quantity=nil)
      @id = id
      @part_name = part_name
      @category_id = category_id
      @zip_code_id = zip_code_id
      @quantity = quantity
      @updated = false
    end

    # Get all part records from the database.
    #
    # Returns an Array containing TruckPart objects.
    def self.all
      results = CONNECTION.execute('SELECT * FROM truck_parts;')
      results_as_objects = []
      
      results.each do |result_hash|
        results_as_objects << TruckPart.new(result_hash["id"], result_hash["part_name"], 
        result_hash["category_id"], result_hash["zip_code_id"], result_hash["quantity"])
      end
      
      return results_as_objects
    end
    
    # Find a truck_part based on its ID.
    #
    # id - The Integer ID of the truck_part to return.
    #
    # Returns a TruckPart object.
    def self.find(id)
      @id = id
    
      result = CONNECTION.execute("SELECT * FROM truck_parts WHERE id = #{@id};").first
      temp_part_name = result["part_name"]
      temp_category_id = result["category_id"]
      temp_zip_code_id = result["zip_code_id"]
      temp_quantity = result["quantity"]
    
      TruckPart.new(id, temp_part_name, temp_category_id, temp_zip_code_id, temp_quantity)
    end
    
    # Method adds a row to the truck_parts database
    #
    # part_name  - The String that is put in the part_name column
    # category - The String that is converted to its coresponding id using
    # Category.get_id(category) Must be New, Used or Reconditioned
    #
    # zip_code - The Integer that is converted to its id via ZipCode.get_id
    #
    # Returns TruckPart object
  	def self.add(part_name, category, zip_code, quantity=1)
      
      temp_truck_part = TruckPart.new(nil, part_name, nil, nil, quantity=1)
      return false if zip_code.to_i == 0
  		zip_id = ZipCode.get_id(zip_code)
      temp_truck_part.zip_code_id = zip_id
      
  		cat_id = Category.get_id(category)
      return false unless cat_id
      temp_truck_part.category_id = cat_id
		  
      sql = "SELECT * FROM truck_parts WHERE part_name = '#{part_name}' AND zip_code_id = #{zip_id} AND category_id = #{cat_id};"
  
  		existing_part = CONNECTION.execute(sql)
  
  		if existing_part.count > 0
        existing_part_hash = existing_part.first
        temp_truck_part.quantity = existing_part_hash["quantity"]
        temp_truck_part.id = existing_part_hash["id"]
        temp_truck_part.increment_quantity(quantity)
        temp_truck_part.save
        temp_truck_part.updated = true
  		else
        sql = "INSERT INTO truck_parts (part_name, category_id, zip_code_id, 
        quantity) VALUES ('#{part_name}', #{cat_id}, #{zip_id}, #{quantity});"
        CONNECTION.execute(sql)
        temp_truck_part.id = CONNECTION.last_insert_row_id
      end	
      return temp_truck_part
  	end
    
    def increment_quantity(quantity_argument)
      @quantity += quantity_argument
    end
    
    # Method deletes row in truck_parts table corresponding to the id of the
    # TruckParts instance it is called on.
    #
    # Returns nil. 
    def delete
        CONNECTION.execute("DELETE FROM truck_parts WHERE id = #{@id};")
    end
 
    def category
      Category.find(@category_id).category
    end
  
    def zip_code
     ZipCode.find(@zip_code_id).zip_code
    end
    
    # Returns an empty Array. 
    def save
      CONNECTION.execute("UPDATE truck_parts SET part_name = '#{@part_name}', 
      category_id = #{@category_id}, zip_code_id = #{@zip_code_id}, quantity = #{@quantity} WHERE id = #{@id};")
    end
  
end