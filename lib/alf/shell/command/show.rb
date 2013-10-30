module Alf
  module Shell
    class Show < Shell::Command(__FILE__, __LINE__)

      options do |opt|

        opt.on_tail('-h', "--help", "Show help") do
          show_help("alf-show")
        end

      end

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
