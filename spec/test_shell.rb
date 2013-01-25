require 'spec_helper'
module Alf
  describe Shell do

    it "should have a version number" do
      Shell.const_defined?(:VERSION).should be_true
    end

  end
end