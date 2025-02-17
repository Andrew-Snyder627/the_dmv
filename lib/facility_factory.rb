class FacilityFactory
    def create_facilities(data)
        facilities = []

        data.each do |facility_data|
            if facility_data.key?(:dmv_office) #Colorado dataset
                facilities << create_co_facility(facility_data)
            elsif facility_data.key?(:office_name) #New York dataset
                facilities << create_ny_facility(facility_data)
            #MO dataset
            elsif facility_data.key?(:name) #Missouri dataset
                facilities << create_mo_facility(facility_data)
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
            phone: data[:phone] || "N/A",
            services: parse_services(data[:services_p]),
            hours: data[:hours] || "No hours available", #CO does not have hours data
            photo: data[:photo] || "No photo available"
        )
    end

    def create_ny_facility(data)
        Facility.new(
            name: data[:office_name],
            address: format_address(data),
            phone: format_phone(data[:public_phone_number]),
            services: [], #NY does not provide services data
            hours: format_hours(data),
            photo: nil
        )
    end

    def create_mo_facility(data)
        Facility.new(
            name: data[:name],
            address: "#{data[:address1]} #{data[:city]}, #{data[:state]} #{data[:zipcode]}", #handling address parsing here
            phone: data[:phone] || "N/A",
            services: [], #Missouri has no service data
            hours: data[:daysopen] || "No hours available", #using the daysopen string here
            photo: nil #no photo data for Missouri
        )
    end

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
        if services_string.nil?
            return []
        else
            services_array = services_string.split(/[,;]\s*/) #had to do some research here, regex seemed the best
            cleaned_services = []

            services_array.each do |service|
                cleaned_services << service.strip
            end

            cleaned_services
        end
    end

    # def parse_services(services_string)
  #   return [] if services_string.nil? #Protecting against nil, just return a blank array, like NY.
  #   services_array = services_string.split(/[,;]\s*/) #had to look this up, may be wrong
  #   cleaned_services = []

  #   services_array.each do |service|
  #     cleaned_services << service.strip #remove end spacing
  #   end

  #   cleaned_services
  # end

    def format_hours(info)
        days = %w[monday tuesday wednesday thursday friday saturday sunday] #shorthand notation for days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
        hours = days.map do |day| #tried using map here, but not super confident, would rather use each but made this work
            if info["#{day}_beginning_hours".to_sym] && info["#{day}_ending_hours".to_sym]
                "#{day.capitalize}: #{info["#{day}_beginning_hours".to_sym]} - #{info["#{day}_ending_hours".to_sym]}"
            end
        end
        hours.compact #removing nil values if any to clean up the string.
    end

    def format_phone(phone_number)
        return "N/A" if phone_number.nil? || phone_number.strip.empty? #added multiple checks to clear an error, turned out to be something else but keeping anyway
        if phone_number.length == 10
            "(#{phone_number[0,3]}) #{phone_number[3,3]}-#{phone_number[6,4]}"
        else
            phone_number
        end
    end
end