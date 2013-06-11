module Alf
  module Shell
    class Exec < Shell::Command()

      def execute(args)
        cmd = if f = args.first
          Path(f).read
        else
          $stdin.read
        end
        database.query(cmd)
      end

    end # class Exec
  end # module Shell
end # module Alf
