require 'timecop'

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
    dummy_hashes = build(:hashes)
    dummmy_end_point = 'https://sandbox.sinopac.com/QPay.WebAPI/api'
    dummy_hash_id = '4DA70F5E2D800D50B43ED3B537480C64'

    gateway = Sinopac::FunBiz::Gateway.new(
      shop_no: dummy_shop_no,
      hashes: dummy_hashes,
      end_point: dummmy_end_point
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

  it "can build a order params for credit card transaction" do
    order = build(:order, amount: 500, memo: "五百倍券專用")
    gateway = build(:gateway, :ithome)
    order_params = gateway.build_creditcard_order(
      order: order,
      auto_billing: true
    )

    expect(order_params[:PayType]).to eq 'C'
    expect(order_params[:Memo]).to eq '五百倍券專用'
    expect(order_params[:CardParam][:AutoBilling]).to eq 'Y'
  end

  it "can build a order params for atm transaction" do
    today = Time.local(1993, 10, 31, 10, 0, 0)
    Timecop.freeze(today) do
      order = build(:order, amount: 100, param1: "肥肥專用")
      gateway = build(:gateway, :ithome)
      order_params = gateway.build_atm_order(
        order: order,
        expired_after: 10
      )

      expect(order_params[:PayType]).to eq 'A'
      expect(order_params[:Param1]).to eq '肥肥專用'
      expect(order_params[:ATMParam][:ExpireDate]).to eq '19931110'
    end
  end

  it "can generate a request params" do
    gateway = build(:gateway)
    order = build(:order, amount: 1450, param1: "肥肥專用")
    order_params = gateway.build_creditcard_order(
      order: order,
      auto_billing: true
    )

    request_params = gateway.order_create_request_params(order_params: order_params)

    expect(request_params[:APIService]).to eq "OrderCreate"
  end

  it "can receive api response" do
    VCR.use_cassette(:gateway_api) do
      gateway = build(:gateway, :ithome)
      order = build(:order, amount: 1500, param1: "BuiBui 飼料錢")

      result = gateway.pay!(pay_type: :credit_card, order: order)

      expect(result).to be_success
      expect(result.amount).to be 1500
      expect(result.param1).to eq "BuiBui 飼料錢"
      expect(result.payment_url).not_to be_empty
    end
  end

  it "can query pay order" do
    VCR.use_cassette('gateway-query-pay-order') do
      gateway = build(:gateway, :ithome)
      dummy_shop_no = 'NA0249_001'
      dummy_pay_token = '330e76b545f9cf52e0a8c539da4bcf327d78854ca83b54a9a61852ea40fc47bb'

      result = gateway.query_pay_order(shop_no: dummy_shop_no, pay_token: dummy_pay_token)

      expect(result).to be_success
      expect(result.shop_no).to eq dummy_shop_no
      expect(result.order_no).not_to be nil
    end
  end
end
