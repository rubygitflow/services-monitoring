# frozen_string_literal: true

channel = RabbitMq.consumer_channel
exchange = channel.default_exchange
queue = channel.queue('authentication', durable: true)

# https://www.rabbitmq.com/tutorials/tutorial-two-ruby.html
queue.subscribe(manual_ack: true) do |delivery_info, properties, payload|
  Thread.current[:request_id] = properties.headers['request_id']
  payload = JSON(payload)
  decoded_data = JwtEncoder.decode(payload['token'])
  users = Auth::FetchUserService.call(decoded_data['uuid'])

  AuthMicroservice.logger.info(
    'Request a user ID',
    user: users.user.id.to_s
  )

  if users.present?
    exchange.publish(
      users.user.id.to_s,
      routing_key: properties.reply_to,
      correlation_id: properties.correlation_id
    )
  end

  channel.ack(delivery_info.delivery_tag)
end
