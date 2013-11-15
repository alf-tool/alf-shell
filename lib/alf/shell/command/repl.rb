module Alf
  module Shell
    class Repl < Shell::Command(__FILE__, __LINE__)

      options do |opt|

        opt.on_tail('-h', "--help", "Show help") do
          show_help("alf-repl")
        end

      end

      def run(argv, requester)
        require 'alf-repl'
        Alf::Repl.database = requester.config.database
        Alf::Repl.launch
        Kernel.exit
      end

    end # class Repl
  end # module Shell
end # module Alf
