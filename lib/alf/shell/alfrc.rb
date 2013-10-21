module Alf
  module Shell
    class Alfrc < Support::Config

      # Path to be put in $LOAD_PATH before executing alf
      option :load_paths, Array, []

      # Libraries to require before executing alf
      option :requires, Array, []

      # Default renderer to use for outputting relations
      option :default_renderer, Class, ->{ $stdout.tty? ? Renderer::Text : Renderer::Rash }

      # Default reader name to use for reading on stdin
      option :stdin_reader, Symbol, :rash

      # Float format to use
      option :float_format, String, "%.3f"

      # Pretty print in console mode?
      option :pretty, Boolean, ->{ $stdout.tty? }

      # The adapter to use by default
      option :adapter, Object, ->{ Path.pwd } 

      # The database to use by default
      option :database, Database, ->{ Database.new(adapter) }

      # The viewpoint to use by default
      option :viewpoint, Module, ->{ Viewpoint::NATIVE }

      # If `path` is provided, evaluates the content of the file on this
      # instance. Also, if a block is passed, yields it with self. Return
      # self in any case.
      def alfrc(path = nil)
        ::Kernel.eval(Path(path).read, binding, path.to_s) if path
        yield(self) if block_given?
        self
      end

    end # class Alfrc
  end # module Shell
end # module Alf
