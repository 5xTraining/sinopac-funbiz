RSpec.describe Sinopac::FunBiz::Hash do
  it "can calculate XOR value of two strings" do
    a1 = "4D9709D699CA40EE"
    a2 = "5A4FEF83140C4E9E"

    result = Sinopac::FunBiz::Hash.string_xor(str1: a1, str2: a2)

    expect(result).to eq "17D8E6558DC60E70"
  end

  it "can calculate hash id with given hashes" do
    a1 = "4D9709D699CA40EE"
    a2 = "5A4FEF83140C4E9E"
    b1 = "BC74301945134CB4"
    b2 = "961F67F8FCA44AB9"

    result = Sinopac::FunBiz::Hash.hash_id(a1: a1, a2: a2, b1: b1, b2: b2)

    expect(result).to eq "17D8E6558DC60E702A6B57E1B9B7060D"
  end
end
