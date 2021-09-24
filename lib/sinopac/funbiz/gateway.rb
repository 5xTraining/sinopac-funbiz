require 'sinopac/funbiz/all'

module Sinopac::FunBiz
  class Gateway
    def initialize(shop_no:, hashes:, end_point:)
      @shop_no = shop_no
      @hashes = hashes
      @end_point = end_point
    end

    def get_nonce
      Nonce.get_nonce(shop_no: @shop_no, end_point: @end_point)
    end

    def hash_id
      Hash.hash_id(@hashes)
    end
  end
end
