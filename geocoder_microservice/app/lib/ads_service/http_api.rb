# frozen_string_literal: true

module AdsService
  module HttpApi
    def update_coordinates(id, coordinates)
      params = {
        id: id,
        coordinates: {
          lat: coordinates[0],
          lon: coordinates[1]
        }
      }

      connection.patch('ads', params)
    end
  end
end
