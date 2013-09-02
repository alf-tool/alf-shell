require 'spec_helper'
module Alf
  module Shell
    describe Alfrc, 'alfrc' do

      let(:alfrc){ Alfrc.new{|c| c.load_paths = ["foo"] } }

      context 'with a block' do
        subject{ alfrc.alfrc{|c| @seen = c } }

        it 'should return the instance itself' do
          subject.should be(alfrc)
        end

        it 'should yield the block' do
          subject
          @seen.should be(alfrc)
        end
      end

      context 'with a path' do
        subject{ alfrc.alfrc(path) }

        let(:path){ Path.backfind("spec/fixtures/example.alfrc") }

        it 'should return the instance itself' do
          subject.should be(alfrc)
        end

        it 'should resolve the load paths correctly' do
          subject.load_paths.should eq([ "foo", path.parent/'lib' ])
        end

        it 'should set requires correctly' do
          subject.requires.should eq([ 'alf-sequel' ])
        end
      end

      context 'with a path and a block' do
        subject{ alfrc.alfrc(path){|c| c.requires = ['bar'] } }

        let(:path){ Path.backfind("spec/fixtures/example.alfrc") }

        it 'should return the instance itself' do
          subject.should be(alfrc)
        end

        it 'should resolve the load paths correctly' do
          subject.load_paths.should eq([ "foo", path.parent/'lib' ])
        end

        it 'should yield the block after the path' do
          subject.requires.should eq([ 'bar' ])
        end
      end

    end
  end
end
