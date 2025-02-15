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

  def add_service(service) #simple typo error
    @services << service
  end

  def register_vehicle(vehicle)
    if @services.include?('Vehicle Registration') #checking if service is offered
    else
      return []
    end

    vehicle.registration_date = Date.today
    plate_type = assign_plate_type(vehicle.year, vehicle.engine) #calling this method below
    vehicle.plate_type = plate_type

    fee = calculate_registration_fee(plate_type)
    @collected_fees += fee
    @registered_vehicles << vehicle

    @registered_vehicles
  end

  def assign_plate_type(year, engine) #tried using a hash but failed epically
    if engine == :ev
      :ev
    elsif year == 1969 #is there a better way to do this?
      :antique
    else
      :regular
    end
  end

  def calculate_registration_fee(plate_type) #takes plate type and assigns a fee value
    fees = {:antique => 25, :ev => 200, :regular => 100}
  end
end

#fixed the errors with dmv and passed test immediately

#Iteration 2
#Register a vehicle
 #vehicles 25 years or older are antique, cost $25
 #EVs cost $200 to register
 #All other vehicles are $100 to register
 #plate_type should be set to :regular, :antique, or :ev when registered

#Administer written test
 #must have a permit, and be 16 years old

#Administer a road test
 #Must have passed the written test
 #registrants who qualify for the road test automatically get a license

#Renew drivers license
 #License can only be renewed if the registrant has already passed the road test and earned a license
