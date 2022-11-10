# frozen_string_literal: true

module RabbitMq
  module_function

  @mutex = Mutex.new

  def connection
    @mutex.synchronize do
      @connection ||= Bunny.new(
        host: Settings.rabbitmq.host,
        username: Settings.rabbitmq.username,
        password: Settings.rabbitmq.password
      ).start
    end
  end

  def channel
    # set up a separate channel with one single connection
    Thread.current[:rabbitmq_channel] ||= connection.create_channel
  end

  def consumer_channel
    # See http://rubybunny.info/articles/concurrency.html#consumer_work_pools
    Thread.current[:rabbitmq_consumer_channel] ||=
      connection.create_channel(
        nil,
        Settings.rabbitmq.consumer_pool
      )
  end
end
