
module ::Cuken
  module Api
    module Chef
      class Knife

        class CliTemplate
          include Mixlib::CLI
        end

        # Ripped from Grit: https://github.com/mojombo/grit

        class CommandTimeout < RuntimeError
          attr_accessor :command
          attr_accessor :bytes_read

          def initialize(command = nil, bytes_read = nil)
            @command = command
            @bytes_read = bytes_read
          end
        end

        # Raised when a command exits with non-zero.
        class CommandFailed < StandardError
          # The full command that failed as a String.
          attr_reader :command

          # The integer exit status.
          attr_reader :exitstatus

          # Everything output on the command's stderr as a String.
          attr_reader :err

          def initialize(command, exitstatus=nil, err='')
            if exitstatus
              @command = command
              @exitstatus = exitstatus
              @err = err
              message = "Command failed [#{exitstatus}]: #{command}"
              message << "\n\n" << err unless err.nil? || err.empty?
              super message
            else
              super command
            end
          end
        end


        def set_cli_options_template(data)
          conf = data[:config_file]||'/etc/chef/knife.rb'
          CliTemplate.option(:config_file, :long => '--config FILE', :default => conf)
          CliTemplate.option(:no_editor, :long => "--no-editor", :boolean => true, :default => true)
          CliTemplate.option(:yes, :long => "--yes", :boolean => true, :default => true)
        end

        def create_client(data)
          set_cli_options_template(data)
          args = ['client', 'create', data[:name], '--file', data[:file], '--no-editor' ]
          args << '--admin' if data[:admin]
          ::Chef::Knife.run(args, CliTemplate.options)
        end

        def show_client(data)
          set_cli_options_template(data)
          args = ['client', 'show', data[:name], '--no-editor' ]
          ::Chef::Knife.run(args, CliTemplate.options)
        end

        def delete_client(data)
          set_cli_options_template(data)
          args = ['client', 'delete', data[:name], '--no-editor', '--yes' ]
          ::Chef::Knife.run(args, CliTemplate.options)
        end

      end # class knife

    end # module Chef
  end # module Api
end # module Cuken

