class FacilityFactory
    def create_facilities(data)
        facilities = []

        data.each do |facility_data|
            facility = Facility.new(facility_data)

            facilities << facility
        end

        facilities
    end

    #Add in logic to handle data from 
end