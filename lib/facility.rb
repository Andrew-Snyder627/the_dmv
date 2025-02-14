class Facility
  attr_reader :name, :address, :phone, :services

  def initialize(info) #since the input is a hash, I need to expect a hash. This is now expecting an info hash with name, address, phone
    @name = info[:name]
    @address = info[:address]
    @phone = info[:phone]
    @services = []
  end

  # def initialize(name:, address:, phone:) #failed attempt
  #   @name = name
  #   @address = address
  #   @phone = phone
  #   @services = []
  # end

  def add_service(service) #simple typo error
    @services << service
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
 