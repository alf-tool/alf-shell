module Alf
  module Shell
    class Explain < Shell::Command()

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
        operands(argv.shift, 1).last
      end

    end # class Explain
  end # module Shell
end # module Alf
