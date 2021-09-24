RSpec.describe Sinopac::FunBiz::Gateway do
  it "can get nonce" do
    dummy_shop_no = 'NA0001_001'
    dummy_hashes = {
      a1: "4D9709D699CA40EE",
      a2: "5A4FEF83140C4E9E",
      b1: "BC74301945134CB4",
      b2: "961F67F8FCA44AB9"
    }
    dummmy_end_point = 'https://sandbox.sinopac.com/QPay.WebAPI/api'

    gateway = Sinopac::FunBiz::Gateway.new(
      shop_no: dummy_shop_no,
      hashes: dummy_hashes,
      end_point: dummmy_end_point
    )

    result = gateway.get_nonce

    expect(result).not_to be nil
    expect(result.length).to be 108
  end

  it "can calculate hash id" do
    dummy_shop_no = 'NA0001_001'
    dummy_hashes = {
      a1: "65960834240E44B7",
      a2: "2831076A098E49E7",
      b1: "CB1AFFBF915A492B",
      b2: "7F242C0AA612454F"
    }
    dummmy_end_point = 'https://sandbox.sinopac.com/QPay.WebAPI/api'
    dummy_hash_id = '4DA70F5E2D800D50B43ED3B537480C64'

    gateway = Sinopac::FunBiz::Gateway.new(
      shop_no: dummy_shop_no,
      hashes: dummy_hashes,
      end_point: dummmy_end_point
    )

    expect(gateway.hash_id).to eq dummy_hash_id
  end
end
