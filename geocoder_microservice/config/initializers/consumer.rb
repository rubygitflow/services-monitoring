# frozen_string_literal: true

require 'benchmark'

channel = RabbitMq.consumer_channel
queue = channel.queue('geocoding', durable: true)

# https://www.rabbitmq.com/tutorials/tutorial-two-ruby.html
queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  Thread.current[:request_id] = properties.headers['request_id']
  Metrics.request_duration_seconds.observe(Benchmark.realtime do
    payload = JSON(payload)
    coordinates = Geocoder.geocode(payload['city'])

    Application.logger.info(
      'Update city coordinates',
      city: payload['city'],
      coordinates: coordinates
    )

    if coordinates.present?
      Metrics.geocoding_requests_total.increment(labels: {result: 'success'})
      client = AdsService::HttpClient.new
      client.update_coordinates(payload['id'], coordinates)
    else
      Metrics.geocoding_requests_total.increment(labels: {result: 'failure'})
    end
  end, labels: { action: 'geocoding' })

  channel.ack(delivery_info.delivery_tag)
end
