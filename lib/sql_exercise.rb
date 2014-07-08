require "database_connection"

class SqlExercise

  attr_reader :database_connection

  def initialize
    @database_connection = DatabaseConnection.new
  end

  def all_customers
    database_connection.sql("SELECT * FROM customers;")
  end

  def limit_customers(limit)
    database_connection.sql("SELECT * FROM customers LIMIT #{limit};")
  end

  def order_customers(direction)
    database_connection.sql("SELECT * FROM customers ORDER BY name #{direction};")
  end

  def id_and_name_for_customers
    database_connection.sql("SELECT id, name FROM customers;")
  end

  def all_items
    database_connection.sql("SELECT * FROM customers;")
  end

end
