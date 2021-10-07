module Sinopac::FunBiz
  class Order
    attr_accessor :order_no, :amount, :product_name, :currency
    attr_accessor :memo, :param1, :param2, :param3

    def initialize(order_no:, amount:, product_name:, **params)
      @order_no = order_no
      @amount = amount
      @product_name = product_name
      @currency = params[:currency] || 'TWD'

      @memo = params[:memo] || ''
      @param1 = params[:param1] || ''
      @param2 = params[:param2] || ''
      @param3 = params[:param3] || ''
    end

    def valid?
      @amount > 0 && @order_no != '' && @product_name != ''
    end
  end
end
