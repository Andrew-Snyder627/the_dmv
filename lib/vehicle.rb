require 'date'

class Vehicle
  attr_reader :vin,
              :year,
              :make,
              :model,
              :engine
  attr_accessor :registration_date, :plate_type #trying accessor to make these accesible when registering vehicles          

  def initialize(vehicle_details)
    @vin = vehicle_details[:vin]
    @year = vehicle_details[:year]
    @make = vehicle_details[:make]
    @model = vehicle_details[:model]
    @engine = vehicle_details[:engine]
    @registration_date = vehicle_details[:registration_date] || nil #trying to get my vehicle registration working by adding attr_accessor, but I need to keep the funtionality that passed the first test
    @plate_type = nil #nil until registration/assignment
  end

  def antique?
    Date.today.year - @year > 25
  end

  def electric_vehicle?
    @engine == :ev
  end
end
