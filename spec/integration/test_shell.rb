require 'spec_helper'

def wlang(str, binding)
  str.gsub(/\$\(([\S]+)\)/){ Kernel.eval($1, binding) }
end

def _(path, file)
  File.expand_path("../#{path}", file)
end

describe "Alf's alf command / " do

  Path.dir.glob('**/*.cmd').each do |input|
    cmd = wlang(input.readlines.first, binding)
    specify{ cmd.should =~ /^alf / }
  
    describe "#{input.basename}: #{cmd}" do
      let(:argv)            { Quickl.parse_commandline_args(cmd)[1..-1] }
      let(:stdout)          { input.sub_ext('.stdout') }
      let(:stderr)          { input.sub_ext('.stderr') }
      let(:stdout_expected) { stdout.exists? ? wlang(stdout.read, binding) : "" }
      let(:stderr_expected) { stderr.exists? ? wlang(stderr.read, binding) : "" }

      before{ 
        $oldstdout = $stdout 
        $oldstderr = $stderr
        $stdout = StringIO.new
        $stderr = StringIO.new
      }
      after { 
        $stdout = $oldstdout
        $stderr = $oldstderr
        $oldstdout = nil 
        $oldstderr = nil 
      }
      
      specify{
        begin 
          dir = Path.relative('__database__')
          main = Alf::Shell::Main.new
          main.connection = Alf.connect(dir)
          main.run(argv, __FILE__)
        rescue => ex
          begin
            Alf::Shell::Main.handle_error(ex, main)
          rescue SystemExit
            $stdout << "SystemExit" << "\n"
          end
        end
        $stdout.string.should(eq(stdout_expected))
        $stderr.string.should(eq(stderr_expected))
      }
    end
  end
    
end
