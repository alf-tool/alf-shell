module Alf
  module Shell
    class Metadata < Shell::Command()

      def run(argv, requester)
        # set requester and parse options
        @requester = requester
        argv = parse_options(argv, :split)

        operand = compile(argv)
        keys    = operand.keys.to_a.map{|k| k.to_a }
        heading = Relation(operand.heading.to_hash.each_pair.map{|k,v|
          {attribute: k, type: v.to_s}
        })
        puts Relation({heading: heading, keys: keys})
      end

      def compile(argv)
        operands(argv.shift, 1).last
      end

    end # class Metadata
  end # module Shell
end # module Alf
