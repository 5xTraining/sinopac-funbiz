FactoryBot.define do
  factory :order, class: Sinopac::FunBiz::Order do
    order_no { "RB#{Date.today.strftime('%Y%m%d')}#{[*'A'..'Z', *0..9].sample(10).join}" }
    amount { 100 }
    product_name { '五百倍券' }

    initialize_with { new(**attributes) }
  end
end
