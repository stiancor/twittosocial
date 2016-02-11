require 'spec_helper'

describe Codeword do

  before { @codeword = Codeword.new }

  subject { @codeword }

  it { is_expected.to respond_to(:codeword) }

  describe "invalid codeword" do
    describe "too long codeword" do
      before { @codeword.codeword = 'a' * 51 }
      it { is_expected.not_to be_valid }
    end
  end

  describe "normal string should be valid" do
    before { @codeword.codeword = "someString" }
    it { is_expected.to be_valid }
  end

end
