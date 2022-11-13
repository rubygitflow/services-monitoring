# frozen_string_literal: true

module Metrics
  extend self

  def configure
    registry = Prometheus::Client.registry
    yield registry

    registry.metrics.each do |m|
      define_method(m.name) { m }
    end
    # equal to block
    # metrics = registry.counter(
    #   :geocoding_requests_total,
    #   docstring: 'The total number of geocoding requests',
    #   labels: %i[result]
    # )
    # metrics.increment(labels: { result: 'success' })
    # in config/initializers/prometheus.rb
  end
end
