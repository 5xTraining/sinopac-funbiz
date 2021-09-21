RSpec.describe Sinopac::FunBiz::Sign do
  it "can covert order content to query string" do
    result = Sinopac::FunBiz::Sign.to_query(content: dummy_order_content)
    expect(result).to eq dummy_query_string
  end

  it "can calculate signed value" do
    dummy_nonce = "NjM2NjY5MDQ3OTQwMzIuMTphZmJjODBhOTM5NzQ1NjMyNDFhZTczMjVjYzg0Mjg5ZjQxYTk2MWI2ZjNkYTA0NDdmOTRhZjU3ZTIzOWJlNDgz"
    dummy_hash_id = "4DA70F5E2D800D50B43ED3B537480C64"

    result = Sinopac::FunBiz::Sign.sign(
      content: dummy_order_content,
      nonce: dummy_nonce,
      hash_id: dummy_hash_id
    )

    expect(result).to eq dummy_signed_value
  end

  private
  def dummy_order_content
    {
      "ShopNo": "NA0001_001",
      "OrderNo": "201807111119291750",
      "Amount": 50000,
      "CurrencyID": "TWD",
      "PayType": "C",
      "ATMParam": {},
      "CardParam": {
        "AutoBilling": "N",
        "ExpMinutes": 30
      },
      "PrdtName": "信用卡訂單",
      "ReturnURL": "http://10.11.22.113:8803/QPay.ApiClient-Sandbox/Store/Return",
      "BackendURL": "https://sandbox.sinopac.com/funBIZ.ApiClient/AutoPush/PushSuccess"
    }
  end

  def dummy_query_string
    "Amount=50000&BackendURL=https://sandbox.sinopac.com/funBIZ.ApiClient/AutoPush/PushSuccess&CurrencyID=TWD&OrderNo=201807111119291750&PayType=C&PrdtName=信用卡訂單&ReturnURL=http://10.11.22.113:8803/QPay.ApiClient-Sandbox/Store/Return&ShopNo=NA0001_001"
  end

  def dummy_signed_value
    "7788EE61DD450944992641B3B2F8210B81A0AE97908BC19825F2A82C0F72EA43"
  end
end
