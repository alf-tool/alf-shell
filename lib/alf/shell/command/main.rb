module Alf
  module Shell
    class Main < Quickl::Delegator(__FILE__, __LINE__)
      include Support

      # Creates a command instance
      def initialize(config = load_config)
        @config = config
      end
      attr_reader :config

      # Install options
      options do |opt|
        @rendering_options = {}

        Renderer.each do |name,descr,clazz|
          opt.on("--#{name}", "Render output #{descr}"){
            config.default_renderer = clazz
          }
        end

        opt.on('--examples', "Use the example database for database") do
          config.adapter = Alf.examples_adapter
        end

        opt.on('--db=DB',
               "Set the database to use") do |value|
          config.adapter = value
        end

        readers = Reader.all.map{|r| r.first }
        opt.on('--stdin=READER', readers,
               "Specify the kind of reader when reading on standard input "\
               "(#{readers.join(',')})") do |value|
          config.stdin_reader = value.to_sym
        end

        opt.on("-Idirectory",
               "Specify $LOAD_PATH directory (may be used more than once)") do |val|
          config.load_paths << val
        end

        opt.on('-rlibrary',
               "Require the library, before executing alf") do |val|
          config.requires << val
        end

        opt.on("--ff=FORMAT",
               "Specify the floating point format") do |val|
          config.float_format = val
        end

        opt.on("--[no-]pretty",
               "Enable/disable pretty print best effort") do |val|
          config.pretty = val
        end

        opt.on_tail('-h', "--help", "Show help") do
          show_help("alf")
        end

        opt.on_tail('-v', "--version", "Show version") do
          raise Quickl::Exit, "alf #{Alf::Core::VERSION}"\
                              " (c) 2011-2013, Bernard Lambeau"
        end
      end # Alf's options

      def connection
        @connection ||= config.database.connection(viewpoint: build_viewpoint)
      end

      def execute(argv)
        install_load_path
        install_requires

        # compile the operator, render and returns it
        super.tap do |op|
          render(connection.relvar(op)) if op && requester
        end
      end

    private

      def install_load_path
        config.load_paths.each do |path|
          $: << path
        end
      end

      def install_requires
        config.requires.each do |who|
          require(who)
        end
      end

      def load_config
        config = Alf::Shell::DEFAULT_CONFIG.dup
        if alfrc_file = Path.pwd.backfind('.alfrc') || Path.pwd.backfind('alfrc')
          config.alfrc(alfrc_file)
        end
        config
      end

      def build_viewpoint
        config = self.config
        Module.new{
          include Alf::Viewpoint
          include config.viewpoint
          def stdin
            Algebra::Operand.coerce Reader.send(contextual_params[:reader], $stdin)
          end
        }[reader: config.stdin_reader]
      end

      def rendering_options
        options = { float_format: config.float_format }
        options[:pretty]  = config.pretty?
        options[:trim_at] = trim_at if options[:pretty]
        options
      end

      def render(operator, out = $stdout)
        renderer = config.default_renderer.new(operator, rendering_options)
        renderer.execute(out)
      end

      def trim_at
        return nil unless hl = highline
        return nil unless cols = hl.output_cols
        hl.output_cols - 1
      end

      def highline
        require 'highline'
        HighLine.new($stdin, $stdout)
      rescue LoadError => ex
      end

    end # class Main
  end # module Shell
end # module Alf
