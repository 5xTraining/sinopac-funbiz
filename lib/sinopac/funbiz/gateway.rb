require 'sinopac/funbiz/all'

module Sinopac::FunBiz
  class Gateway
    attr_reader :shop_no

    def initialize(shop_no: nil, hashes: nil, end_point: nil, return_url: nil, backend_url: nil)
      @shop_no = shop_no || ENV['FUNBIZ_SHOP_NO']
      @hashes = hashes || {
        a1: ENV['FUNBIZ_HASH_A1'],
        a2: ENV['FUNBIZ_HASH_A2'],
        b1: ENV['FUNBIZ_HASH_B1'],
        b2: ENV['FUNBIZ_HASH_B2']
      }
      @end_point = end_point || ENV['FUNBIZ_END_POINT']
      @return_url = return_url || ENV['FUNBIZ_RETURN_URL']
      @backend_url = backend_url || ENV['FUNBIZ_BACKEND_URL']
    end

    def get_nonce
      @nonce ||= Nonce.get_nonce(shop_no: @shop_no, end_point: @end_point)
    end

    def hash_id
      Hash.hash_id(@hashes)
    end

    def build_atm_order(order:, currency: 'TWD', **params)
      build_order(order: order, currency: currency, type: :atm, **params)
    end

    def build_creditcard_order(order:, currency: 'TWD', **params)
      build_order(order: order, currency: currency, type: :credit_card, **params)
    end

    def order_create_request_params(order_params:)
      {
        Version: "1.0.0",
        ShopNo: @shop_no,
        APIService: "OrderCreate",
        Sign: sign(content: order_params),
        Nonce: get_nonce,
        Message: encrypt_message(content: order_params)
      }
    end

    private
    def encrypt_message(content:)
      Message.encrypt(
        content: content,
        key: hash_id,
        iv: Message.iv(nonce: get_nonce)
      )
    end

    def sign(content:)
      Sign.sign(
        content: content,
        nonce: get_nonce,
        hash_id: hash_id
      )
    end
    def build_order(order:, type:, currency: 'TWD', **params)
      content = {
        ShopNo: @shop_no,
        OrderNo: order.order_no,
        Amount: order.amount,
        CurrencyID: currency,
        PrdtName: order.product_name,
        Memo: order.memo,
        Param1: order.param1,
        Param2: order.param2,
        Param3: order.param3,
        ReturnURL: @return_url,
        BackendURL: @backend_url
      }

      case type
      when :atm
        expired_after = params[:expired_after] || 10
        content.merge!(
          {
            PayType: 'A',
            ATMParam: {
              ExpireDate: (Date.today + expired_after).strftime('%Y%m%d')
            }
          }
        )

      when :credit_card
        content.merge!(
          {
            PayType: 'C',
            CardParam: {
              AutoBilling: params[:auto_billing] ? 'Y' : 'N',
              ExpBillingDays: params[:auto_billing] ? '' : params[:expired_billing_days] || 10,
              ExpMinutes: params[:expired_minutes] || 10,
              PayTypeSub: 'ONE'
            }
          }
        )
      else
        raise "this payment method is not supported yet!"
      end
    end
  end
end
