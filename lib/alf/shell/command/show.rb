module Alf
  module Shell
    # Evaluates a query and shows the result.
    # 
    # SYNOPSIS
    # 
    #     alf #(command_name) QUERY -- [ORDERING]
    # 
    # DESCRIPTION
    # 
    # Take a query argument and execute it against the current database. Show the
    # result on standard output. When an ordering is specified, tuples are rendered
    # in the order specified.
    #
    class Show < Shell::Command(__FILE__, __LINE__)

      def run(argv, requester)
        # set requester and parse options
        @requester = requester
        argv = parse_options(argv, :split)

        compile(argv)
      end

      def compile(argv)
        operand = operand(argv.shift)
        operand = sort(operand, argv.first) unless argv.empty?
        operand
      end

    private

      def sort(operand, ordering)
        Algebra::Sort.new([operand], Ordering.coerce(ordering))
      end

    end # class Show
  end # module Shell
end # module Alf
