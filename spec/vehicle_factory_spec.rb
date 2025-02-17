require 'spec_helper'

RSpec.describe VehicleFactory do
    it 'exists' do
        factory = VehicleFactory.new

        expect(factory).to be_a(VehicleFactory)
    end

    it 'can create vehicles from EV registration data' do
        ev_data = DmvDataService.new.wa_ev_registrations
        factory = VehicleFactory.new

        #Test the factory will create vehicles for each registration and each element will be a Vehicle object
        vehicles = factory.create_vehicles(ev_data)
        expect(vehicles).to all(be_a(Vehicle))

        #Verifying the first vehicles attributes, ensuring correct assignment
        first_vehicle = vehicles.first
        expect(first_vehicle.engine).to eq(:ev) #this should always be ev for this use case
        expect(first_vehicle.make).to eq("NISSAN")
        expect(first_vehicle.model).to eq("Leaf")
        expect(first_vehicle.year).to eq("2016")
        expect(first_vehicle.vin).to eq("1N4B")
    end
end