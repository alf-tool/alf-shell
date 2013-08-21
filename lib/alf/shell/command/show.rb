module Alf
  module Shell
    class Show < Shell::Command()

      def run(argv, requester)
        # set requester and parse options
        @requester = requester
        argv = parse_options(argv, :split)

        compile(argv)
      end

      def compile(argv)
        operand = operands(argv.shift, 1).last
        unless argv.empty?
          operand = Algebra::Sort.new([operand], Shell.from_argv(argv.first, Ordering))
        end
        operand
      end

    end # class Show
  end # module Shell
end # module Alf
