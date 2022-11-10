# frozen_string_literal: true

require_relative '../application'

def stdout?
  ENV['LOG_SERVICE'] == 'stdout'
end

logger_path = case ENV['LOG_SERVICE']
              when 'stdout'
                $stdout
              when nil
                "#{AuthMicroservice.root}/#{Settings.logger.path}"
              else
                "#{AuthMicroservice.root}/#{ENV['LOG_SERVICE']}"
              end

AuthMicroservice.configure do |app|
  logger = Ougai::Logger.new(
    logger_path,
    level: Settings.logger.level
  )

  logger.formatter = Ougai::Formatters::Readable.new if stdout? && (AuthMicroservice.environment != :production)

  logger.before_log = lambda do |data|
    data[:service] = { name: Settings.app.name }
    data[:request_id] ||= Thread.current[:request_id]
  end

  app.logger = logger
end

Sequel::Model.db.loggers.push(AuthMicroservice.logger)
