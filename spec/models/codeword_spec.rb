require 'spec_helper'

describe Codeword do

  before { @codeword = Codeword.new }

  subject { @codeword }

  it { should respond_to(:codeword) }

  describe "invalid codeword" do
    describe "too long codeword" do
      before { @codeword.codeword = 'a' * 51 }
      it { should_not be_valid }
    end
  end

  describe "normal string should be valid" do
    before { @codeword.codeword = "someString" }
    it { should be_valid }
  end

end
