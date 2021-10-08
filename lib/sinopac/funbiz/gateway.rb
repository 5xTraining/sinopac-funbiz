require 'sinopac/funbiz/all'
require 'net/http'
require 'uri'
require 'json'

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

    def build_atm_order(order:, **options)
      build_order(order: order, type: :atm, **options)
    end

    def build_creditcard_order(order:, **options)
      build_order(order: order, type: :credit_card, **options)
    end

    def order_create_request_params(order_params:)
      build_request_params(order_params: order_params, service_type: 'OrderCreate')
    end

    def order_pay_query_request_params(data:)
      build_request_params(order_params: data, service_type: 'OrderPayQuery')
    end

    def pay!(pay_type:, order:, **options)
      order_params = case pay_type
      when :credit_card
        build_creditcard_order(order: order, **options)
      when :atm
        build_atm_order(order: order, **options)
      else
        raise "payment method is not supported yet!"
      end

      request_params = order_create_request_params(order_params: order_params)

      url = URI("#{@end_point}/Order")
      header = { "Content-Type" => "application/json" }
      resp = Net::HTTP.post(url, request_params.to_json, header)
      result = decrypt_message(content: JSON.parse(resp.body))

      Result.new(result)
    end

    def query_pay_order(shop_no: nil, pay_token:)
      data = {
        ShopNo: shop_no || @shop_no,
        PayToken: pay_token
      }

      request_params = order_pay_query_request_params(data: data)

      url = URI("#{@end_point}/Order")
      header = { "Content-Type" => "application/json" }
      resp = Net::HTTP.post(url, request_params.to_json, header)
      result = decrypt_message(content: JSON.parse(resp.body))

      TransactionResult.new(result)
    end

    private
    def encrypt_message(content:)
      Message.encrypt(
        content: content,
        key: hash_id,
        iv: Message.iv(nonce: get_nonce)
      )
    end

    def decrypt_message(content:)
      message = content["Message"]
      nonce = content["Nonce"]

      Message.decrypt(
        content: message,
        key: hash_id,
        iv: Message.iv(nonce: nonce)
      )
    end

    def sign(content:)
      Sign.sign(
        content: content,
        nonce: get_nonce,
        hash_id: hash_id
      )
    end

    def build_order(order:, type:, **params)
      content = {
        ShopNo: @shop_no,
        OrderNo: order.order_no,
        Amount: order.amount * 100,
        CurrencyID: params[:currency] || 'TWD',
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
              ExpBillingDays: params[:auto_billing] ? '' : params[:expired_billing_days] || 7,
              ExpMinutes: params[:expired_minutes] || 10,
              PayTypeSub: 'ONE'
            }
          }
        )
      else
        raise "this payment method is not supported yet!"
      end
    end

    def build_request_params(order_params:, service_type:)
      {
        Version: "1.0.0",
        ShopNo: @shop_no,
        APIService: service_type,
        Sign: sign(content: order_params),
        Nonce: get_nonce,
        Message: encrypt_message(content: order_params)
      }
    end
  end
end
