require 'spec_helper'

RSpec.describe Facility do
  before(:each) do
    @facility_1 = Facility.new({name: 'DMV Tremont Branch', address: '2855 Tremont Place Suite 118 Denver CO 80205', phone: '(720) 865-4600'})
    @facility_2 = Facility.new({name: 'DMV Northeast Branch', address: '4685 Peoria Street Suite 101 Denver CO 80239', phone: '(720) 865-4600'})

    @cruz = Vehicle.new({vin: '123456789abcdefgh', year: 2012, make: 'Chevrolet', model: 'Cruz', engine: :ice} )
    @bolt = Vehicle.new({vin: '987654321abcdefgh', year: 2019, make: 'Chevrolet', model: 'Bolt', engine: :ev} )
    @camaro = Vehicle.new({vin: '1a2b3c4d5e6f', year: 1969, make: 'Chevrolet', model: 'Camaro', engine: :ice} )

    @registrant_1 = Registrant.new('Bruce', 18, true)
    @registrant_2 = Registrant.new('Penny', 16)
    @registrant_3 = Registrant.new('Tucker', 15)

  end
  describe '#initialize' do
    it 'can initialize' do
      expect(@facility_1).to be_an_instance_of(Facility)
      expect(@facility_1.name).to eq('DMV Tremont Branch')
      expect(@facility_1.address).to eq('2855 Tremont Place Suite 118 Denver CO 80205')
      expect(@facility_1.phone).to eq('(720) 865-4600')
      expect(@facility_1.services).to eq([])
    end
  end

  describe '#add service' do
    it 'can add available services' do
      expect(@facility_1.services).to eq([])
      @facility_1.add_service('New Drivers License')
      @facility_1.add_service('Renew Drivers License')
      @facility_1.add_service('Vehicle Registration')
      expect(@facility_1.services).to eq(['New Drivers License', 'Renew Drivers License', 'Vehicle Registration'])
    end
  end 
  describe 'Vehicle Registration' do
    it 'starts with no registered vehicles' do
      @facility_1.add_service('Vehicle Registration')

      expect(@cruz.registration_date).to be_nil
      expect(@facility_1.registered_vehicles).to eq([])
      expect(@facility_1.collected_fees).to eq(0)
    end

    it 'does not register vehicles if the service is not available' do
      @facility_2.register_vehicle(@bolt)

      expect(@facility_2.registered_vehicles).to eq([])
      expect(@facility_2.collected_fees).to eq(0)
    end

    it 'can register vehicles and collect fees' do
      @facility_1.add_service('Vehicle Registration')
      #Checking cruz registration
      expect(@facility_1.register_vehicle(@cruz)).to eq([@cruz])
      expect(@cruz.registration_date).to be_a(Date)
      expect(@cruz.plate_type).to eq(:regular)
      expect(@facility_1.collected_fees).to eq(100)
      #Checking camero registration
      expect(@facility_1.register_vehicle(@camaro)).to eq([@cruz, @camaro])
      expect(@camaro.registration_date).to be_a(Date)
      expect(@camaro.plate_type).to eq(:antique)
      expect(@facility_1.collected_fees).to eq(125) #25 for antique, total collected fees should be 125 at this point
      #Checking bolt registration
      expect(@facility_1.register_vehicle(@bolt)).to eq([@cruz, @camaro, @bolt])
      expect(@bolt.registration_date).to be_a(Date)
      expect(@bolt.plate_type).to eq(:ev)
      expect(@facility_1.collected_fees).to eq(325) #325 total collected fees for this facility
    end
  end

  describe 'administers tests correctly' do
    it 'does not administer written test if service is not offered' do
      
      expect(@facility_1.administer_written_test(@registrant_1)).to be false
    end

    it 'can administer written tests correctly' do
      @facility_1.add_service('Written Test')

      expect(@facility_1.administer_written_test(@registrant_1)).to be true
      expect(@registrant_1.license_data[:written]).to be true

      expect(@facility_1.administer_written_test(@registrant_2)).to be false
      @registrant_2.earn_permit
      expect(@facility_1.administer_written_test(@registrant_2)).to be true
    end

    it 'can administer road tests correctly' do
      @facility_1.add_service('Written Test')
      @facility_1.add_service('Road Test')

      expect(@facility_1.administer_road_test(@registrant_1)).to be false

      @facility_1.administer_written_test(@registrant_1)
      
      expect(@facility_1.administer_road_test(@registrant_1)).to be true
      expect(@registrant_1.license_data[:license]).to be true
    end

    it 'can renew drivers licenses correctly' do
      @facility_1.add_service('Written Test')
      @facility_1.add_service('Road Test')
      @facility_1.add_service('Renew License')

      @facility_1.administer_written_test(@registrant_1)
      @facility_1.administer_road_test(@registrant_1)

      expect(@facility_1.renew_drivers_license(@registrant_1)).to be true
      expect(@registrant_1.license_data[:renewed]).to be true
    end
  end
end
