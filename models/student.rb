require_relative('../db/sql_runner')
require('pry')



class Student

  attr_reader :id
  attr_accessor :first_name, :last_name, :age, :house_id

  def initialize(options)
    @id = options["id"].to_i if options["id"]
    @first_name = options['first_name']
    @last_name = options['last_name']
    @age = options['age'].to_i
    @house_id = options['house_id'].to_i
  end

  def pretty_name
    return "#{@first_name} #{@last_name}"
  end

#: 07/02/2019, 09:48:24 instead of a sql statement for the house function, we can simply call the house method House.find(@house_id)
  def house()
    sql = "SELECT h.* FROM houses h
      INNER JOIN students s
        ON s.house_id = h.id
      WHERE s.id = $1"
    values = [@id]
    house = SqlRunner.run(sql, values)
    return house.first()

  end

  def save()
    sql = "INSERT INTO students
    (
      first_name,
      last_name,
      age,
      house_id
    )
    VALUES
    (
      $1, $2, $3, $4
    )
    RETURNING id"
    values = [@first_name, @last_name, @age, @house_id]
    student = SqlRunner.run(sql, values)
    @id = student.first()['id'].to_i
  end

  def self.all()
    sql = "SELECT * FROM students"
    students = SqlRunner.run( sql )
    result = students.map { |student| Student.new( student) }
    return result
  end

  def self.find( id )
    sql = "SELECT * FROM students WHERE id = $1"
    values = [id]
    student = SqlRunner.run( sql, values )
    result = Student.new( student.first )
    return result
  end

  def self.delete_all()
   sql = "DELETE FROM students"
   SqlRunner.run(sql)
 end




end
