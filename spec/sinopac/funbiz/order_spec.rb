RSpec.describe Sinopac::FunBiz::Order do
  it "can create a valid order" do
    order = Sinopac::FunBiz::Order.new(
      order_no: 'A123232321312',
      amount: 100,
      product_name: '測試看看',
      param1: '123'
    )

    # expect(order.valid?).to be true
    expect(order).to be_valid
    expect(order.currency).to eq 'TWD'
    expect(order.param1).to eq '123'
  end

  it "can create an order with factory" do
    order = build(:order)
    expect(order).to be_valid
  end

  it "would not be valid if no product name" do
    order = build(:order, product_name: '')
    expect(order).not_to be_valid
  end
end
