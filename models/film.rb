require_relative('../db/sql_runner')
require_relative('./ticket.rb')

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save
    sql = "INSERT INTO films
    (title, price) VALUES ($1, $2)
    RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values).first
    @id = film["id"].to_i
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE * FROM films where id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end

  def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id WHERE film_id = $1"
    values = [@id]
    customer_data = SqlRunner.run(sql, values)
    return Customer.map_items(customer_data)
  end

  def self.all
    sql = "SELECT * FROM films"
    film_data = SqlRunner.run(sql)
    return Film.map_items(film_data)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM films
    WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    film = self.new(result.first)
    return film
  end

  # def tickets()
  #   sql = "SELECT * FROM tickets where film_id = $1"
  #   values = [@id]
  #   ticket_data = SqlRunner.run(sql, values)
  #   return ticket_data.map{|ticket| Ticket.new(ticket)}
  # end

  # def self.all()
  #   sql = "SELECT * FROM films"
  #   film_data = SqlRunner.run(sql)
  #   return Film.map_items(film_data)
  # end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def self.map_items(data)
    result = data.map{|film| Film.new(film)}
    return result
  end


end
