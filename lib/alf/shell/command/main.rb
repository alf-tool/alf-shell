module Alf
  module Shell
    class Main < Shell::Delegator()

      class << self

        def relational_operators(sort_by_name = true)
          ops = subcommands.select{|cmd|
             cmd.operator? and cmd.relational? and !cmd.experimental?
          }
          sort_operators(ops, sort_by_name)
        end

        def experimental_operators(sort_by_name = true)
          ops = subcommands.select{|cmd|
            cmd.operator? and cmd.relational? and cmd.experimental?
          }
          sort_operators(ops, sort_by_name)
        end

        def non_relational_operators(sort_by_name = true)
          ops = subcommands.select{|cmd|
            cmd.operator? and !cmd.relational?
          }
          sort_operators(ops, sort_by_name)
        end

        def other_non_relational_commands(sort_by_name = true)
          ops = subcommands.select{|cmd|
            cmd.command?
          }
          sort_operators(ops, sort_by_name)
        end

        private

        def sort_operators(ops, sort_by_name)
          sort_by_name ? ops.sort{|op1,op2|
            op1.command_name.to_s <=> op2.command_name.to_s
          } : ops
        end

      end # class << self

      # The reader to use when stdin is used as operand
      attr_accessor :stdin_operand

      # Creates a command instance
      def initialize
        @config = load_config
      end
      attr_reader :config

      # Install options
      options do |opt|
        @rendering_options = {}

        @execute = false
        opt.on("-e", "--execute", "Execute one line of script (Lispy API)") do
          @execute = true
        end

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

        @input_reader = :rash
        readers = Reader.all.map{|r| r.first}
        opt.on('--input-reader=READER', readers,
               "Specify the kind of reader when reading on $stdin "\
               "(#{readers.join(',')})") do |value|
          @input_reader = value.to_sym
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
          raise Quickl::Help
        end

        opt.on_tail('-v', "--version", "Show version") do
          raise Quickl::Exit, "alf #{Alf::Core::VERSION}"\
                              " (c) 2011-2013, Bernard Lambeau"
        end
      end # Alf's options

      def stdin_operand
        @stdin_operand || Reader.send(@input_reader, $stdin)
      end

      def connection
        @connection ||= config.database.connection(viewpoint: config.viewpoint)
      end

      def execute(argv)
        install_load_path
        install_requires

        # special case where a .alf file is provided
        if argv.empty? or (argv.size == 1 && Path(argv.first).file?)
          argv.unshift("exec")
        end

        # compile the operator, render and returns it
        compile(argv){ super }.tap do |op|
          render(connection.compile(op)) if op && requester
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
        if alfrc_file = Path.pwd.backfind('.alfrc')
          config.alfrc(alfrc_file)
        end
        config
      end

      def compile(argv)
        if @execute
          connection.query(argv.first)
        else
          op = yield
          op = op.bind(connection) if op
          op
        end
      end

      def rendering_options
        options = { float_format: config.float_format }
        if config.pretty? and (hl = highline)
          options[:pretty]  = config.pretty?
          options[:trim_at] = hl.output_cols - 1
        end
        options
      end

      def render(operator, out = $stdout)
        renderer = config.default_renderer.new(operator, rendering_options)
        renderer.execute(out)
      end

      def highline
        require 'highline'
        HighLine.new($stdin, $stdout)
      rescue LoadError => ex
      end

    end # class Main
  end # module Shell
end # module Alf
