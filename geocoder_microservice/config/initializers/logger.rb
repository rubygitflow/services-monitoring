# frozen_string_literal: true

require_relative '../application'

def stdout?
  ENV['LOG_SERVICE'] == 'stdout'
end

logger_path = case ENV['LOG_SERVICE']
              when 'stdout'
                $stdout
              when nil
                "#{Application.root}/#{Settings.logger.path}"
              else
                "#{Application.root}/#{ENV['LOG_SERVICE']}"
              end

logger = Ougai::Logger.new(
  logger_path,
  level: Settings.logger.level
)

logger.formatter = Ougai::Formatters::Readable.new if stdout? && (Application.environment != :production)

logger.before_log = lambda do |data|
  data[:service] = { name: Settings.app.name }
  data[:request_id] ||= Thread.current[:request_id]
end

Application.logger = logger
