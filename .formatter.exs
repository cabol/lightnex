locals_without_parens = [
  # Lightnex.TestUtils
  assert_eventually: 0,
  assert_eventually: 1,
  assert_eventually: 2,
  assert_eventually: 3,
  wait_until: 0,
  wait_until: 1,
  wait_until: 2,
  wait_until: 3
]

[
  import_deps: [:protobuf, :grpc],
  inputs: ["{mix,.formatter,.credo}.exs", "{config,lib,test}/**/*.{ex,exs}"],
  line_length: 100,
  locals_without_parens: locals_without_parens,
  export: [locals_without_parens: locals_without_parens]
]
