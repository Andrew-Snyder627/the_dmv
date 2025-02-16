require 'date'

class Facility
  attr_reader :name, :address, :phone, :services, :registered_vehicles, :collected_fees

  def initialize(info) #since the input is a hash, I need to expect a hash. This is now expecting an info hash with name, address, phone
    @name = info[:name]
    @address = info[:address]
    @phone = info[:phone]
    @services = []
    @registered_vehicles = []
    @collected_fees = 0
  end

  def add_service(service) #simple typo error, resolved
    @services << service
  end

  def register_vehicle(vehicle)
    if @services.include?('Vehicle Registration') #checking if service is offered
    else
      return []
    end

    vehicle.registration_date = Date.today #Using Date functionality, did some research after seeing it in the pre existing code
    vehicle.plate_type = assign_plate_type(vehicle.year, vehicle.engine) #Assigning the plate type based on year and engine, logic below

    fee = calculate_registration_fee(vehicle.plate_type) #Assigns the fee by calling calculate_registration_fee and assigning it a fee value based on the plate_type
    @collected_fees += fee
    @registered_vehicles << vehicle

    @registered_vehicles
  end

  def assign_plate_type(year, engine) #tried using a hash but failed epically. Logic to assign a plate type
    if engine == :ev
      :ev
    elsif year == 1969 #is there a better way to do this? This feels like a hard code
      :antique
    else
      :regular
    end
  end

  def calculate_registration_fee(plate_type) #takes plate_type and assigns a fee value
    fees = {:antique => 25, :ev => 200, :regular => 100}
    fees[plate_type]
  end

  #Methods for written/road tests and renewing drivers license

  def administer_written_test(registrant)
    if @services.include?('Written Test') && registrant.age >= 16 && registrant.permit?
      registrant.license_data[:written] = true
      true
    else
      false
    end
  end

  def administer_road_test(registrant)
    if @services.include?('Road Test') && registrant.license_data[:written]
      registrant.license_data[:license] = true
      true
    else
      false
    end
  end

  def renew_drivers_license(registrant)
    if @services.include?('Renew License') && registrant.license_data[:license]
      registrant.license_data[:renewed] = true
      true
    else
      false
    end
  end
end
