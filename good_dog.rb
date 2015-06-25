# good_dog.rb

class GoodDog
#attr_accessor :name, :height, :weight #attr_reader attr_writer
  DOG_YEARS = 7

  attr_accessor :name, :age


  # => class variable # @@number_of_dogs = 0

  def initialize(n, a)
    @name = n
    @age = a * DOG_YEARS
  end

  # def self.total_number_of_dogs
  #   @@number_of_dogs
  # end

  def to_s
    "This dog's name is #{name} and it is #{age} in dog years."
  end
end

sparky = GoodDog.new("Sparky", 4)
puts sparky
p sparky
