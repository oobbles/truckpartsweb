require_relative "database_methods.rb"
#require_relative "database_instance_methods.rb"

class ZipCode
  extend DatabaseClassMethods
  #include DatabaseInstanceMethods
  attr_reader :id
  attr_accessor :zip_code
  
  # Initializes a new zipcode object
  #
  # id (optional) - Integer of the zipcode record in zip_codes table
  #
  # zip_code (optional) - Integer of the zip_code in the zip_codes table
  def initialize(id=nil, zipcode=nil)
    @id = id
    @zip_code = zipcode
  end
  
  # Get all zip code records from the ZipCode table
  #
  # Returns an Array of ZipCode Objects
  
  def self.all
    results = CONNECTION.execute('SELECT * FROM zip_codes;')
    results_as_objects = []

    results.each do |result_hash|
      results_as_objects << ZipCode.new(result_hash["id"], result_hash["zip_code"])
    end
    return results_as_objects
  end
  #
  # Find a zip code based on its ID.
  #
  # id - The Integer ID of the zipcode to return.
  #
  #Returns a ZipCode object.
  def self.find(id)
    @id = id

    result = CONNECTION.execute("SELECT * FROM zip_codes WHERE id = #{@id};").first
    temp_zip_code = result["zip_code"]

    ZipCode.new(id, temp_zip_code)
  end
  
  # def self.find_as_object(id)
  #   result = ZipCode.find(id).first
  #   ZipCode.new(result)
  # end
  #
  # Class utility method gets zip code id and if none exists, enters the zip
  # code argument in to the zip code table.
  #
  # zip - The Integer that is used to search for its corresponding id
  #
  # Returns the zip code id number as an Integer
  def self.get_id(zip)
    zip_id = CONNECTION.execute("SELECT id FROM zip_codes WHERE zip_code = #{zip};") 
    if zip_id.count == 0
      add(zip)
    else
      zip_id.first['id'].to_i
    end
  end

  # Utility method to add a zip code, returns an empty Array.
  def self.add(zip_code)
    CONNECTION.execute("INSERT INTO zip_codes (zip_code) VALUES (#{zip_code});")
    return CONNECTION.last_insert_row_id
  end

  # Utility method to change a current zip code to new zip code. Returns an 
  # empty Array.
  def change_name(new_zip_code)
    CONNECTION.execute("UPDATE zip_codes SET zip_code = '#{new_zip_code}' WHERE id = #{@id};")
  end

  # Utility method to delete a current zip code. Does not allow a zipcode to be
  # deleted if its ID is used in the truck_parts table. Returns a Boolean.
  def delete
    zip_codes_in_table = CONNECTION.execute("SELECT COUNT(*) FROM truck_parts WHERE zip_code_id = #{id};")
    if zip_codes_in_table == 0
      CONNECTION.execute("DELETE FROM zip_codes WHERE id = #{@id};")
    else
      false
    end
  end
  
  # Method called on an instance of the ZipCode class, passed 5 digit Integer
  # and returns the corresponding id from the zip_code table
  def get_id(zipcode)
    zipcode = @id
  end

 
  # Method called on an instance of the ZipCode class returns any parts from 
  # the truck_part table associated with the @id as an array.
  def truck_parts
    parts = []
    results = CONNECTION.execute("SELECT part_name FROM truck_parts WHERE zip_code_id = #{@id};")
    results.each do |hash|
      parts << hash["part_name"]
    end
    return parts
  end

end