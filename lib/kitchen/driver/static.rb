require "kitchen"

require_relative "static_version"

module Kitchen
  module Driver
    # Driver for using static/physical hosts with Kitchen.
    # This driver is a newer version of the proxy driver.
    #
    # @author Thomas Heinen <theinen@tecracer.de>
    class Static < Kitchen::Driver::Base
      kitchen_driver_api_version 2

      plugin_version Kitchen::Driver::STATIC_VERSION

      default_config :host, nil

      default_config :queueing, false
      default_config :queueing_timeout, 3600
      default_config :queueing_handlers, []
      default_config :request, {}
      default_config :release, {}

      BANNER_FORMAT = "[kitchen-static] >>> %s <<<".freeze

      def create(state)
        print_version

        state[:hostname] = queueing? ? request(state) : config[:host]

        if queueing?
          info format("[kitchen-static] Received %s for testing", state[:hostname])
          info format(BANNER_FORMAT, queueing_handler.banner) if queueing_handler.banner?
        end
      end

      def destroy(state)
        print_version
        return if state[:hostname].nil?

        release(state) if queueing?
        info format("[kitchen-static] Released %s from testing", state[:hostname]) if queueing?

        state.delete(:hostname)
      end

      private

      def request(state)
        info format("[kitchen-static] Queueing request via %s handler", queueing_type)

        queueing_handler.request(state)
      end

      def release(state)
        info format("[kitchen-static] Queueing release via %s handler", queueing_type)

        queueing_handler.release(state)
      end

      def queueing?
        config[:queueing] === true
      end

      def queueing_handler
        @queueing_handler ||= queueing_registry[queueing_type].new(config)
      end

      def queueing_type
        return unless queueing?

        config.fetch(:type, "script")
      end

      def queueing_registry
        return unless queueing?

        @queueing_registry unless @queueing_registry.nil? || @queueing_registry.empty?
        @queueing_registry = {}

        bundled_handlers = File.join(__dir__, "queueing", "*.rb")
        require_queueing_handlers(bundled_handlers)

        additional_handlers = config[:queueing_handlers]
        additional_handlers.each { |glob| require_queueing_handlers(glob) }

        Queueing::Base.descendants.each do |handler_class|
          type = queueing_type_from_class(handler_class)
          @queueing_registry[type] = handler_class

          debug format("[kitchen-static] Added queueing handler: %s", type)
        end

        @queueing_registry
      end

      def require_queueing_handlers(glob)
        Dir.glob(glob).each { |file| require file }
      end

      def queueing_type_from_class(handler_class)
        handler_class.to_s.split("::").last.downcase
      end

      def print_version
        debug format("Starting kitchen-static %s", Kitchen::Driver::STATIC_VERSION)
      end
    end
  end
end
