# Mocks
[
  Lightnex.LNRPC.Lightning.Stub,
  GRPC.Stub,
  Mix.Lightnex,
  Mint.HTTP,
  System,
  File
]
|> Enum.each(&Mimic.copy/1)

ExUnit.start()
