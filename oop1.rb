# OOP in Ruby
# 1. classes and objects
# 2. classes contain behaviors

class Dog
  def initialize(n)
    @name = n
  end

  def speak
    "#{name} bark!"
  end
end

teddy = Dog.new('teddy')
fido = Dog.new('fido')

teddy.speak
fido.speak