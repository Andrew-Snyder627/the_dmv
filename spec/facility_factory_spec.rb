require 'spec_helper'

RSpec.describe FacilityFactory do
    it 'exists' do
        factory = FacilityFactory.new

        expect(factory).to be_a(FacilityFactory)
    end

    it 'can create facilities from CO DMV dataset' do
        colorado_data = DmvDataService.new.co_dmv_office_locations
        factory = FacilityFactory.new

        #I want my factory to create facilities for each location, each should be a Facility object.
        facilities = factory.create_facilities(colorado_data)
        expect(facilities).to all(be_a(Facility))

        #Check data is mapped correctly
        first_facility = facilities.first
        
        expect(first_facility.name).to eq("DMV Tremont Branch")
        expect(first_facility.address).to eq("2855 Tremont Place Suite 118 Denver, CO 80205")
        expect(first_facility.phone).to eq("(720) 865-4600")
        expect(first_facility.services).to include("vehicle titles", "registration", "renewals", "VIN inspections")
        expect(first_facility.photo).to eq("images/Tremont.jpg")
    end

    xit 'can create facilities from NY DMV dataset' do
        new_york_data = DmvDataService.new.ny_dmv_office_locations
        factory = FacilityFactory.new

        facilities = factory.create_facilities(new_york_data)
        expect(facilities).to all(be_a(Facility))

        first_facility = facilities.first

        #add in expects based on dataset
    end

    xit 'can create facilities from MO DMV dataset' do
        missouri_data = DmvDataService.new.mo_dmv_office_locations
        factory = FacilityFactory.new

        facilities = factory.create_facilities(missouri_data)
        expect(facilities).to all(be_a(Facility))

        #add in expects based on dataset
    end
end