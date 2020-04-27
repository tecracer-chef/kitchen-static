require "mixlib/shellout"

require_relative "base.rb"

module Kitchen::Driver
  class Static
    module Queueing
      class Script < Base
        def setup(_kitchen_options)
          default_request_options({
            match_hostname: "^(.*)$",
            match_banner: nil,
          })

          default_release_options({})
        end

        def handle_request(_state)
          stdout = execute(request_options[:execute])

          matched = stdout.match(request_options[:match_hostname])
          raise format("Could not extract hostname from '%s' with regular expression /%s/", stdout, request_options[:match_hostname]) unless matched

          # Allow additional feedback from command
          @banner = stdout.match(request_options[:match_banner])&.captures&.first if request_options[:match_banner]

          matched.captures.first
        end

        def handle_release(_state)
          execute(release_options[:execute])
        end

        private

        def execute(command)
          raise format("Received empty command") if command.nil? || command.empty?

          cmd = Mixlib::ShellOut.new(command, environment: env_vars, timeout: timeout)
          cmd.run_command

          raise format("Error executing `%s`: %s", command, cmd.stderr) if cmd.status != 0

          cmd.stdout.strip
        end
      end
    end
  end
end
