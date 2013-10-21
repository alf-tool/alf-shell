module Alf
  module Shell
    # Show metadata for a query
    # 
    # SYNOPSIS
    # 
    #     alf metadata QUERY
    # 
    # DESCRIPTION
    # 
    # This command prints some metadata (e.g. heading, keys, etc.) about the
    # expression passed as first argument.
    #
    class Metadata < Shell::Command(__FILE__, __LINE__)

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
