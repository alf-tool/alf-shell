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
        sub = (args.size != 1) ? sup : Quickl.sub_command(sup, args.first)
        if sub
          puts sub.documentation
        else
          op_documentation(args.first.strip)
        end
      end

    private

      def op_documentation(name)
        require 'alf-doc'
        require 'alf/doc/to_markdown'
        op = Alf::Doc.query{
          restrict(operators, name: name)
        }.tuple_extract
        puts Alf::Doc::ToMarkdown.new.operator(op).gsub(/^```(try)?\n/, "")
      rescue NoSuchTupleError
        puts "No such operator `#{name}`"
      end

    end # class Help
  end # module Shell
end # module Alf
