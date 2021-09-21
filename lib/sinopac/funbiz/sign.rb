require "digest"

module Sinopac::FunBiz
  module Sign
    def self.to_query(content:)
      content.sort.map { |k, v|
        unless ([::Hash, ::Array].include?(v.class) || v == '')
          "#{k}=#{v}"
        end
      }.compact.join("&")
    end

    def self.sign(content:, nonce:, hash_id:)
      Digest::SHA256.hexdigest("#{to_query(content: content)}#{nonce}#{hash_id}").upcase
    end
  end
end
