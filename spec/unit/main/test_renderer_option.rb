require 'spec_helper'
module Alf
  module Shell
    describe Main, "--text, --json and the like" do

      before do
        Path.dir.chdir
        subject
      end

      let(:cmd){ Main.new }

      subject{
        cmd.parse_options(argv)
        cmd
      }

      context 'when set to --json' do
        let(:argv){ ["--json"] }

        it 'should set the default renderer' do
          cmd.config.default_renderer.should be(Alf::Renderer::JSON)
        end
      end

    end
  end
end
