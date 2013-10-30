module Alf
  module Shell
    class Help < Shell::Command(__FILE__, __LINE__)

      # Command execution
      def execute(args)
        show_help(args.first.strip)
      end

    end # class Help
  end # module Shell
end # module Alf
