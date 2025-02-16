class Registrant
    attr_reader :name, :age
    attr_accessor :license_data

    def initialize(name, age, permit = false) #defaulting to false for permit
        @name = name
        @age = age
        @permit = permit
        @license_data = {written: false, license: false, renewed: false}
    end

    def permit? #checks if permit is true or false
        @permit
    end

    def earn_permit #reassigning to true once permit is earned
        @permit = true
    end
end