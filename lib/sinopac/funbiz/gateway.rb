require 'sinopac/funbiz/all'

module Sinopac::FunBiz
  class Gateway
    attr_reader :shop_no

    def initialize(shop_no: nil, hashes: nil, end_point: nil)
      @shop_no = shop_no || ENV['FUNBIZ_SHOP_NO']
      @hashes = hashes || {
        a1: ENV['FUNBIZ_HASH_A1'],
        a2: ENV['FUNBIZ_HASH_A2'],
        b1: ENV['FUNBIZ_HASH_B1'],
        b2: ENV['FUNBIZ_HASH_B2']
      }
      @end_point = end_point || ENV['FUNBIZ_END_POINT']
    end

    def get_nonce
      Nonce.get_nonce(shop_no: @shop_no, end_point: @end_point)
    end

    def hash_id
      Hash.hash_id(@hashes)
    end
  end
end
