# frozen_string_literal: true

class Application
  class << self
    attr_accessor :logger

    def root
      ApplicationLoader.root
    end

    def environment
      ENV.fetch('RACK_ENV')&.to_sym
    end
  end
end
