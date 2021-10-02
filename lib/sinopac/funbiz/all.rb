[
  "sinopac/funbiz/version",
  "sinopac/funbiz/hash",
  "sinopac/funbiz/nonce",
  "sinopac/funbiz/sign",
  "sinopac/funbiz/message",
  "sinopac/funbiz/gateway",
  "sinopac/funbiz/order",
  "sinopac/funbiz/result",
].each do |mod|
  begin
    require mod
  rescue LoadError
  end
end
