module Alf
  module Shell
    module Support

      def connection
        requester && requester.connection
      end

      def operands(argv, size = nil)
        operands = [ stdin_operand ] + Array(argv)
        operands = operands[(operands.size - size)..-1] if size
        operands = operands.map{|arg|
          arg = connection.relvar(arg) if arg.is_a?(String)
          Algebra::Operand.coerce(arg)
        }
        operands
      end

      def stdin_operand
        requester.stdin_operand rescue $stdin
      end

    end # module Support
  end # module Shell
end # module Alf
