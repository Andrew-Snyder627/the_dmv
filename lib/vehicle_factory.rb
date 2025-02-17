class VehicleFactory
    def create_vehicles(ev_data)
        vehicles = []
        ev_data.each do |data|
            vehicles << Vehicle.new({
                vin: data[:vin_1_10],
                year: data[:model_year],
                make: data[:make],
                model: data[:model],
                engine: :ev
            })
        end
        vehicles
    end
end