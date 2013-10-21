module Alf
  module Shell
    module Support

      AlfFile = ->(arg){
        path = Path(arg)
        path.file? and path.ext =~ /^\.?alf$/
      }

      def connection
        requester && requester.connection
      end

      def operand(arg)
        case arg
        when AlfFile then operand(Path(arg).read)
        when String  then connection.relvar(arg)
        when Array   then operand(arg.first)
        else
          Algebra::Operand.coerce(arg)
        end
      end

    end # module Support
  end # module Shell
end # module Alf
