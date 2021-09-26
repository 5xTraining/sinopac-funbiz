FactoryBot.define do
  factory :gateway, class: Sinopac::FunBiz::Gateway do
    shop_no { 'NA0001_001' }
    end_point { 'https://sandbox.sinopac.com/QPay.WebAPI/api' }
    hashes

    initialize_with { new(**attributes) }

    trait :ithome do
      shop_no { 'NA0249_001' }
      association :hashes, factory: [:hashes, :ithome]
    end
  end
end
