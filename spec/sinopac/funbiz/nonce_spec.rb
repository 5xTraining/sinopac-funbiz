RSpec.describe Sinopac::FunBiz::Nonce do
  it "can get Nonce with ShopNo" do
    VCR.use_cassette("nonce") do
      nonce = Sinopac::FunBiz::Nonce.get_nonce(
        shop_no: 'BA0026_001',
        end_point: 'https://sandbox.sinopac.com/QPay.WebAPI/api'
      )

      expect(nonce).not_to be nil
      expect(nonce.length).to be 108
    end
  end
end
