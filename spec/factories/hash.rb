FactoryBot.define do
  factory :hashes, class: Hash do
    a1 { '65960834240E44B7' }
    a2 { '2831076A098E49E7' }
    b1 { 'CB1AFFBF915A492B' }
    b2 { '7F242C0AA612454F' }

    initialize_with { attributes }

    trait :ithome do
      a1 { '86D50DEF3EB7400E' }
      a2 { '01FD27C09E5549E5' }
      b1 { '9E004965F4244953' }
      b2 { '7FB3385F414E4F91' }
    end
  end
end
