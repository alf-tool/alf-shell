require 'spec_helper'
module Alf
  module Shell
    describe DocManager, ".call" do

      let(:dm){ @dm ||= DocManager.new }
      let(:cmd){ Alf::Shell::Show }
      subject{
        dm.call(cmd, {})
      }

      describe "on a static file" do
        before{
          def dm.find_file(cmd);
            Path.dir/'static.md'
          end
        }
        it { should eq("Hello\n") }
      end

      describe "on a dynamic file" do
        before{
          def dm.find_file(cmd);
            Path.dir/'dynamic.md'
          end
        }
        it { should eq("show\n") }
      end

      describe "on an example file" do
        before{
          def dm.find_file(cmd);
            Path.dir/'example.md'
          end
        }
        it { should eq((Path.dir/"example_1.txt").read) }
      end

    end
  end
end
