module Sinopac::FunBiz
  class Result
    attr_reader :order_no, :shop_no, :transaction_no, :amount, :status, :description
    attr_reader :param1, :param2, :param3, :pay_type, :payment_params
    def initialize(result)
      @order_no = result[:OrderNo]
      @shop_no = result[:ShopNo]
      @transaction_no = result[:TSNo]
      @amount = result[:Amount] / 100
      @status = result[:Status]
      @description = result[:Description]
      @param1 = result[:Param1]
      @param2 = result[:Param2]
      @param3 = result[:Param3]

      case result[:PayType]
      when 'A'
        @pay_type = :atm
        @payment_params = result[:ATMParam]
      when 'C'
        @pay_type = :credit_card
        @payment_params = result[:CardParam]
      else
        @pay_type = :unknown
        @payment_params = {}
      end
    end

    def success?
      @status == 'S'
    end

    def payment_url
      case @pay_type
      when :atm
        @payment_params[:WebAtmURL]
      when :credit_card
        @payment_params[:CardPayURL]
      else
        raise 'not supported'
      end
    end

  end
end
