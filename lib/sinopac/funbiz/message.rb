require 'digest'
require 'openssl'
require 'json'

module Sinopac::FunBiz
  module Message
    def self.iv(nonce:)
      Digest::SHA256.hexdigest(nonce).upcase[-16..]
    end

    def self.encrypt(content:, key:, iv:)
      cipher = OpenSSL::Cipher.new('AES-256-CBC')
      cipher.encrypt
      cipher.key = key
      cipher.iv = iv

      encrypted_message = cipher.update(content.to_json) + cipher.final
      encrypted_message.unpack('H*').first.upcase
    end
  end
end
