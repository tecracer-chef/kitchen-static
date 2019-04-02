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

      required_config :host

      def create(state)
        state[:hostname] = config[:host]
      end

      def destroy(state)
        return if state[:hostname].nil?
        state.delete(:hostname)
      end
    end
  end
end
