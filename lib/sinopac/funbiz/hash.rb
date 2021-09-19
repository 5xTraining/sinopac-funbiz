module Sinopac::FunBiz
  module Hash
    def self.string_xor(str1:, str2:)
      str1.chars.zip(str2.chars).map { |x, y|
        (x.to_i(16) ^ y.to_i(16)).to_s(16).upcase
      }.join
    end

    def self.hash_id(a1:, a2:, b1:, b2:)
      a1a2 = string_xor(str1: a1, str2: a2)
      b1b2 = string_xor(str1: b1, str2: b2)

      "#{a1a2}#{b1b2}"
    end
  end
end
