module Alf
  module Shell
    # Show the logical and physical plans of a query
    # 
    # SYNOPSIS
    # 
    #     alf explain QUERY
    # 
    # DESCRIPTION
    # 
    # This command prints the logical and physical query plans for QUERY to
    # standard output. The logical plan is post-optimizer and allows checking that
    # the latter performs correctly. The physical plan provides information about
    # delegation to underlying database engines, e.g. involved SQL queries.
    #
    class Explain < Shell::Command(__FILE__,__LINE__)

      def run(argv, requester)
        # set requester and parse options
        @requester = requester
        argv = parse_options(argv, :split)

        operand = compile(argv)

        puts "Logical plan:"
        puts
        puts operand.to_ascii_tree.gsub(/^/, "  ")

        puts

        puts "Physical plan:"
        puts
        puts operand.to_cog.to_ascii_tree.gsub(/^/, "  ")
      end

      def compile(argv)
        operand(argv.shift)
      end

    end # class Explain
  end # module Shell
end # module Alf
