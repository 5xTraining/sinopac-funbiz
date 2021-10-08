module Sinopac::FunBiz
  class TransactionResult
    attr_reader :shop_no, :pay_token, :status, :description, :transaction_params
    attr_reader :transaction_no, :order_no, :amount, :param1, :param2, :param3

    def initialize(result)
      @shop_no = result[:ShopNo]
      @pay_token = result[:PayToken]
      @status = result[:Status]
      @description = result[:Description]
      @transaction_params = result[:TSResultContent]
      @transaction_no = transaction_params[:TSNo]
      @order_no = transaction_params[:OrderNo]
      case transaction_params[:PayType]
      when 'A'
        @pay_type = :atm
      when 'C'
        @pay_type = :credit_card
      else
        @pay_type = :unknown
      end
      @amount = transaction_params[:Amount].to_i / 100
      @param1 = transaction_params[:Param1]
      @param2 = transaction_params[:Param2]
      @param3 = transaction_params[:Param3]
    end

    def success?
      @status == 'S'
    end
  end
end
