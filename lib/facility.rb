require 'date'

class Facility
  attr_reader :name, :address, :phone, :services, :hours, :photo, :registered_vehicles, :collected_fees

  def initialize(name:, address:, phone:, services: [], hours: nil, photo: nil)
    @name = name
    @address = address
    @phone = phone
    @services = services
    @hours = hours
    @photo = photo
    @registered_vehicles = []
    @collected_fees = 0
  end

  def add_service(service) #simple typo error, resolved
    @services << service
  end

  def register_vehicle(vehicle)
    if @services.include?('Vehicle Registration') #checking if service is offered
    else
      return [] #should I change this to nil?
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
      true #explicitly giving a true outcome, I wasn't sure if it would work without it
    else
      false
    end
  end

  def administer_road_test(registrant)
    if @services.include?('Road Test') && registrant.license_data[:written]
      registrant.license_data[:license] = true
      true #explicitly giving a true outcome, I wasn't sure if it would work without it
    else
      false
    end
  end

  def renew_drivers_license(registrant)
    if @services.include?('Renew License') && registrant.license_data[:license]
      registrant.license_data[:renewed] = true
      true #explicitly giving a true outcome, I wasn't sure if it would work without it
    else
      false
    end
  end

  #Method to handle string given from CO data
  #Below will be methods handling data parcing
  # def parse_services(services_string)
  #   return [] if services_string.nil? #Protecting against nil, just return a blank array, like NY.
  #   services_array = services_string.split(/[,;]\s*/) #had to look this up, may be wrong
  #   cleaned_services = []

  #   services_array.each do |service|
  #     cleaned_services << service.strip #remove end spacing
  #   end

  #   cleaned_services
  # end

  # def format_address(info)
  #   if info[:address_li] && info[:address__1] #Colorado dataset
  #     "#{info[:address_li]} #{info[:address__1]} #{info[:city]}, #{info[:state]} #{info[:zip]}"
  #   elsif info[:street_address_line_1] && info[:zip_code] #New York dataset
  #     "#{info[:street_address_line_1]} #{info[:city]}, #{info[:state]} #{info[zip_code]}"
  #   else
  #     "Address not available" #Handling no address situations
  #   end
  # end
  #I tried adding this functionality into the facility class but as I started the NY & CO datasets, I realized this would become very messy.
  #This functionality now resides in the FacilityFactory
end
