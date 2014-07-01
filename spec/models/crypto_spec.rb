require 'spec_helper'

class Secure
  include Crypto
end

describe Crypto do
  before do
    @secure = Secure.new
  end

  it "encrypts a given string" do
    expect(@secure.encrypt("nupsi")).to have(3).elements
  end

  it "decrypts a given encrypted string" do
    data = @secure.encrypt("nupsi")
    data << Crypto::TEST_PASSWORD
    expect(@secure.decrypt(*data)).to eql("nupsi")
  end
end
