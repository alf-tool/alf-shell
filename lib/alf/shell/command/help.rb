module Alf
  module Shell
    # 
    # Shows help about a specific command or relational operator
    # 
    # SYNOPSIS
    # 
    #     alf help ARG
    # 
    # DESCRIPTION
    # 
    # Take the name of a command or of a relational operators and show its
    # documentation.
    # 
    class Help < Shell::Command(__FILE__, __LINE__)
      
      # Let NoSuchCommandError be passed to higher stage
      no_react_to Quickl::NoSuchCommand
      
      # Command execution
      def execute(args)
        sup = Quickl.super_command(self)
        sub = (args.size != 1) ? sup : Quickl.sub_command!(sup, args.first)
        doc = sub.documentation
        puts doc
      end
      
    end # class Help
  end # module Shell
end # module Alf
