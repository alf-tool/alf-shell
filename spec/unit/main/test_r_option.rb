require 'spec_helper'
module Alf
  module Shell
    describe Main, "-r" do

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
          cmd.config.requires.should eq(["a_require"])
        end
      end

      context 'when specified multiple times' do
        let(:argv){ ["-ralf-sequel", "-rpry"] }

        it 'should have defaults only' do
          cmd.config.requires.should eq(["a_require", "alf-sequel", "pry"])
        end
      end

    end
  end
end
