RSpec.describe Sinopac::FunBiz::Gateway do
  it "can get nonce" do
    dummy_shop_no = 'NA0001_001'
    dummy_hashes = {
      a1: "4D9709D699CA40EE",
      a2: "5A4FEF83140C4E9E",
      b1: "BC74301945134CB4",
      b2: "961F67F8FCA44AB9"
    }
    dummy_end_point = 'https://sandbox.sinopac.com/QPay.WebAPI/api'

    gateway = Sinopac::FunBiz::Gateway.new(
      shop_no: dummy_shop_no,
      hashes: dummy_hashes,
      end_point: dummy_end_point
    )

    result = gateway.get_nonce

    expect(result).not_to be nil
    expect(result.length).to be 108
  end

  it "can calculate hash id" do
    dummy_shop_no = 'NA0001_001'
    dummy_hashes = build(:hashes)
    dummy_end_point = 'https://sandbox.sinopac.com/QPay.WebAPI/api'
    dummy_hash_id = '4DA70F5E2D800D50B43ED3B537480C64'

    gateway = Sinopac::FunBiz::Gateway.new(
      shop_no: dummy_shop_no,
      hashes: dummy_hashes,
      end_point: dummy_end_point
    )

    expect(gateway.hash_id).to eq dummy_hash_id
  end

  it "can create a gateway without arguments" do
    gateway = Sinopac::FunBiz::Gateway.new
    expect(gateway.shop_no).to eq ENV['FUNBIZ_SHOP_NO']
  end

  it "can create a gateway with factory" do
    gateway = build(:gateway, :ithome)
    expect(gateway.hash_id).to eq '87282A2FA0E209EBE1B3713AB56A06C2'
  end
end
