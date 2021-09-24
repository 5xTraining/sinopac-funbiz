[
  "sinopac/funbiz/version",
  "sinopac/funbiz/hash",
  "sinopac/funbiz/nonce",
  "sinopac/funbiz/sign",
  "sinopac/funbiz/message",
  "sinopac/funbiz/gateway"
].each do |mod|
  begin
    require mod
  rescue LoadError
  end
end
