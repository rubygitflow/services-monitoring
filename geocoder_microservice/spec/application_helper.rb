# frozen_string_literal: true

require 'spec_helper'

ENV['RACK_ENV'] ||= 'test'

require_relative '../config/environment'

abort('You run tests in production mode. Please don\'t do this!') if Application.environment == :production
