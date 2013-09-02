require 'spec_helper'
module Alf
  module Shell
    describe Main, "-I" do

      before do
        Path.dir.chdir
        subject
      end

      let(:cmd){ Main.new }

      subject{
        cmd.parse_options(argv)
        cmd
      }

      context 'when no explicitly set' do
        let(:argv){ [] }

        it 'should have defaults only' do
          cmd.config.load_paths.should eq(["a_load_path"])
        end
      end

      context 'when specified multiple times' do
        let(:argv){ ["-Ilib", "-Ispec"] }

        it 'should have defaults only' do
          cmd.config.load_paths.should eq(["a_load_path", "lib", "spec"])
        end
      end

    end
  end
end
