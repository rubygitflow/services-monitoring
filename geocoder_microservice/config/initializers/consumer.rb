# frozen_string_literal: true

channel = RabbitMq.consumer_channel
queue = channel.queue('geocoding', durable: true)

# https://www.rabbitmq.com/tutorials/tutorial-two-ruby.html
queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  Thread.current[:request_id] = properties.headers['request_id']
  payload = JSON(payload)
  coordinates = Geocoder.geocode(payload['city'])

  Application.logger.info(
    'Update city coordinates',
    city: payload['city'],
    coordinates: coordinates
  )

  if coordinates.present?
    client = AdsService::HttpClient.new
    client.update_coordinates(payload['id'], coordinates)
  end

  channel.ack(delivery_info.delivery_tag)
end
