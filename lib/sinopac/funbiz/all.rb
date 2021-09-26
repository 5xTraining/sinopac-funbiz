[
  "sinopac/funbiz/version",
  "sinopac/funbiz/hash",
  "sinopac/funbiz/nonce",
  "sinopac/funbiz/sign",
  "sinopac/funbiz/message",
  "sinopac/funbiz/gateway",
  "sinopac/funbiz/order",
].each do |mod|
  begin
    require mod
  rescue LoadError
  end
end
