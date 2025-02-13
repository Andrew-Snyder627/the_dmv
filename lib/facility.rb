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
