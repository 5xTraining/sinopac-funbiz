module Sinopac::FunBiz
  class OrderResult
    attr_reader :shop_no, :status, :description, :order_params
    attr_reader :transaction_no, :order_no, :amount, :pay_status

    def initialize(result)
      @shop_no = result[:ShopNo]
      @status = result[:Status]
      @description = result[:Description]
      @order_params = result[:OrderList].first

      @transaction_no = order_params[:TSNo]
      @order_no = order_params[:OrderNo]
      case order_params[:PayType]
      when 'A'
        @pay_type = :atm
      when 'C'
        @pay_type = :credit_card
      else
        @pay_type = :unknown
      end
      @amount = order_params[:Amount].to_i / 100
      @pay_status = order_params[:PayStatus]
    end

    def success?
      @status == 'S'
    end
  end
end
