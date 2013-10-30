module Alf
  module Shell
    class Metadata < Shell::Command(__FILE__, __LINE__)

      options do |opt|

        opt.on_tail('-h', "--help", "Show help") do
          show_help("alf-metadata")
        end

      end

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
        operand(argv.shift)
      end

    end # class Metadata
  end # module Shell
end # module Alf
