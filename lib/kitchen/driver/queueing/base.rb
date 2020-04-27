module Kitchen::Driver
  class Static
    module Queueing
      class Base
        @options = {}
        @request_options = {}
        @release_options = {}

        @hostname = nil
        @banner = nil

        @env_vars = {}

        attr_reader :options, :request_options, :release_options, :env_vars, :banner

        def initialize(options)
          @options = {
            queueing_timeout: 3600,
          }

          @request_options = {}
          @release_options = {}

          setup(options)

          process_kitchen_options(options)
        end

        def request(state)
          handle_request(state)
        end

        def release(state)
          @env_vars = {
            STATIC_HOSTNAME: state[:hostname],
          }

          handle_release(state)
        end

        def banner?
          ! @banner.nil?
        end

        def self.descendants
          ObjectSpace.each_object(Class).select { |klass| klass < self }
        end

        private

        def setup(_options)
          # Add setup and defaults in specific handler
        end

        def handle_request(_state)
          raise "Implement request handler"
        end

        def handle_release(_state)
          raise "Implement release handler"
        end

        def default_request_options(options = {})
          @request_options.merge!(options)
        end

        def default_release_options(options = {})
          @release_options.merge!(options)
        end

        def process_kitchen_options(kitchen_options)
          @options = kitchen_options

          @request_options.merge!(options[:request])
          @options.delete(:request)

          @release_options.merge!(options[:release])
          @options.delete(:release)
        end

        def timeout
          options[:queueing_timeout]
        end
      end
    end
  end
end
