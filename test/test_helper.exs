# Mocks
[
  Mix.Lightnex,
  Mint.HTTP,
  System,
  File
]
|> Enum.each(&Mimic.copy/1)

ExUnit.start()
