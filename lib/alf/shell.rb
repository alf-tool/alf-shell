require_relative 'shell/version'
require_relative 'shell/loader'
require_relative 'shell/alfrc'
module Alf
  module Shell

    # This is the default configuration to be forked from
    DEFAULT_CONFIG = Alfrc.new

    # Command factory
    def self.Command(*args)
      Quickl::Command(*args){|builder|
        builder.command_parent = Alf::Shell::Main
        builder.instance_module Shell::Support
        yield(builder) if block_given?
      }
    end

  end # module Shell
end # module Alf
require_relative 'shell/support'
require_relative 'shell/command'
