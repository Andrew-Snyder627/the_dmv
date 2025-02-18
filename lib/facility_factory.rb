class FacilityFactory
    def create_facilities(data)
        facilities = []

        data.each do |facility_data|
            if facility_data[:dmv_office] #Colorado dataset
                facilities << create_co_facility(facility_data)
            elsif facility_data[:office_name] #New York dataset
                facilities << create_ny_facility(facility_data)
            #MO dataset
            else
                puts "Unknown data format"
            end
        end

        facilities
    end

    def create_co_facility(data)
        Facility.new(
            name: data[:dmv_office],
            address: format_address(data),
            phone: format_phone(data[:phone]) || "N/A",
            services: parse_services(data[;services_p]),
            hours: data[:hours] || "No hours available", #CO does not have hours data
            photo: data[:photo] || "No photo available"
        )
    end

    def create_ny_facility(data)
        Facility.new(
            name: data[:office_name],
            address: format_address(data),
            phone: format_phone(data[:public_phone_number]),
            services: [] #NY does not provide services data
            hours: format_hours(data)
        )
    end

    #MO facility block

    def format_address(info)
        if info[:address_li] && info[:address__1] #Colorado dataset
            "#{info[:address_li]} #{info[:address__1]} #{info[:city]}, #{info[:state]} #{info[:zip]}"
        elsif info[:street_address_line_1] && info[:zip_code] #New York dataset
            "#{info[:street_address_line_1]} #{info[:city]}, #{info[:state]} #{info[:zip_code]}"
        else
            "Address not available"
        end
    end

    def parse_services(services_string)


end