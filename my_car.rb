module Towable
  def can_tow?(pounds)
    pounds < 2000 ? true : false
  end
end

class Vehicle
  attr_accessor :color
  attr_reader :model, :year
  @@number_of_vehicles = 0

  def initialize(year, model, color)
    @year = year
    @model = model
    @color = color
    @current_speed = 0
    @@number_of_vehicles += 1
  end

  def age
    "Your #{self.model} is #{years_old} years old."
  end

  def self.vehicle_number
    puts @@number_of_vehicles
  end

  def speed_up(number)
    @current_speed += number
  end

  def brake(number)
    @current_speed -= number
  end

  def shut_down
    @current_speed = 0
  end

  def spray_paint(color)
    self.color = color
    puts "Your #{color} paint job looks great!"
  end

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  private

  def years_old
    Time.now.year - self.year
  end
end

class Student
  attr_reader :name

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(person)
    self.grade > person.grade
  end

  protected

  attr_reader :grade
end

class MyCar < Vehicle
  MANUFACTURER = "Honda"
end

class MyTruck < Vehicle
  include Towable

  MANUFACTURER = "Toyota"
end



Vehicle.gas_mileage(13, 351)

car = MyCar.new(2006, "Mazda", "Blue")
puts car.age
puts MyCar.ancestors
puts MyTruck.ancestors
puts Vehicle.ancestors