module Alf
  module Algebra
    class Signature

      # Converts commandline arguments to operator constructor arguments
      def argv2args(argv)
        # First split over --
        argv = Quickl.split_commandline_args(argv)

        # Parse the options and replace argv[0] by remaining arguments
        opts = {}
        argv[0] = option_parser(opts).parse!(argv[0])
        opts = default_options.merge(opts)

        # Operands are argv[0], and can be removed
        oper = argv.shift

        # Coerce each remaining argument according to the signature
        args = []
        with_each_arg(argv) do |name,dom,value|
          invalid_args!(args) if value.nil?
          args << Shell.from_argv(Array(value), dom)
        end

        [oper, args, opts]
      end

      # Returns a shell synopsis for this signature.
      #
      # Example:
      #
      #     Alf::Algebra::Project.signature.to_shell
      #     # => "alf project [--allbut] [OPERAND] -- ATTRIBUTES"
      def to_shell
        oper = operator.nullary? ? "" :
              (operator.unary? ? "[OPERAND]" : "[LEFT] RIGHT")
        opts =   options.map{|opt|   "[#{option_name(opt)}]" }.join(" ")
        args = arguments.map{|arg,_| "#{arg.to_s.upcase}"    }.join(" -- ")
        optargs = "#{opts} #{oper} " + (args.empty? ? "" : "-- #{args}")
        "alf #{operator.rubycase_name} #{optargs.strip}".strip
      end

    end # class Signature
  end # module Algebra
end # module Alf
