require 'gdata'
require 'uri'
require 'rails'

module C2dm # :nodoc:

  class C2dmRailtie < Rails::Railtie
    initializer "load c2dm config" do
      if defined?(Rails)
        rails_env = Rails.env
        rails_root = Rails.root
      else
        rails_env = 'development'
        rails_root = File.join(FileUtils.pwd, 'rails_root')
      end

      begin
        APP_CONFIG = YAML.load_file("#{rails_root}/config/c2dm.yml")[rails_env]
      rescue => ex
        raise ex
      end

      begin
        ::C2dm::API_URL = URI.parse('https://android.apis.google.com/c2dm/send') unless defined?(::C2dm::API_URL)
        ::C2dm::USERNAME = APP_CONFIG['username'] unless defined?(::C2dm::USERNAME)
        ::C2dm::PASSWORD = APP_CONFIG['password'] unless defined?(::C2dm::PASSWORD)
        ::C2dm::APP_NAME = APP_CONFIG['app_name'] unless defined?(::C2dm::APP_NAME)
      rescue => ex
        raise C2dm::Errors.ConfigFileMissingAttributes.new(ex.message)
      end
    end
  end

  module Errors # :nodoc:

    # The payload of the message is too big, the limit is currently 1024
    # bytes. Reduce the size of the message.
    class MessageTooBig < StandardError

      def initialize(message) # :nodoc:
        super("The maximum size allowed for a notification payload is 1024 bytes: '#{message}'")
      end

    end

    # Too many messages sent by the sender. Retry after a while.
    class QuotaExceeded < StandardError

      def initialize(message) # :nodoc:
        super("Too many messages sent by the sender: '#{message}'")
      end

    end

    # Too many messages sent by the sender to a specific device. Retry after a
    # while.
    class DeviceQuotaExceeded < StandardError

      def initialize(message) # :nodoc:
        super("Too many messages sent by the sender to a specific device: '#{message}'")
      end

    end

    # Missing or bad registration_id. Sender should stop sending messages to
    # this device.
    class InvalidRegistration < StandardError

      def initialize(message) # :nodoc:
        super("Missing or bad registration_id: '#{message}'")
      end

    end

    # The registration_id is no longer valid, for example user has uninstalled
    # the application or turned off notifications. Sender should stop sending
    # messages to this device.
    class NotRegistered < StandardError

      def initialize(message) # :nodoc:
        super("The registration_id is no longer valid: '#{message}'")
      end

    end

    # Collapse key is required. Include collapse key in the request.
    class MissingCollapseKey < StandardError

      def initialize(message) # :nodoc:
        super("Collapse key is required: '#{message}'")
      end

    end

    # ClientLogin AUTH_TOKEN is invalid. Check the config
    class InvalidAuthToken < StandardError

      def initialize(message)
        super("Invalid auth token: '#{message}'")
      end

    end

    class ConfigFileNotFound < StandardError

      def initialize(message)
        super("The config file c2dm.yml not found from config/ directory or contains errors: '#{message}'")
      end

    end

    class ConfigFileMissingAttributes < StandardError

      def initialize(message)
        super("Config file doesn't contain username, password or app_name: '#{message}'")
      end

    end

    class ServiceUnavailable < StandardError

      def initialize(message)
        super("Service is currently unavailable. Try again later: '#{message}'")
      end

    end
  end # Errors

end # APN

Dir.glob(File.join(File.dirname(__FILE__), 'app', 'models', 'c2dm', '*.rb')).sort.each do |f|
  require f
end

%w{ models controllers helpers }.each do |dir|
  path = File.join(File.dirname(__FILE__), 'app', dir)
  $LOAD_PATH << path
  # puts "Adding #{path}"
  ActiveSupport::Dependencies.autoload_paths << path
  ActiveSupport::Dependencies.autoload_once_paths.delete(path)
end
