# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Lightnex is an Elixir client for LND (Lightning Network Daemon). It provides a type-safe, well-documented interface for interacting with Lightning Network nodes via gRPC, supporting peer management, channel operations, wallet management, and more.

## Development Commands

### Running Tests

```bash
# Run all tests
mix test

# Run a single test file
mix test test/lightnex_test.exs

# Run a specific test by line number
mix test test/lightnex_test.exs:42

# Run integration tests (requires Docker environment)
mix test test/integration/

# Run with coverage
mix coveralls.html
```

### Code Quality

```bash
# Format code
mix format

# Run linter
mix credo --strict

# Run static analysis
mix dialyzer

# Security audit
mix sobelow --skip --exit Low

# Search documentation across all dependencies
mix usage_rules.search_docs "search term"

# Get docs for specific module/function
mix usage_rules.docs Enum.map

# Full CI checks (format, lint, test, coverage, security, dialyzer)
mix test.ci
```

### Protocol Buffers

```bash
# Fetch and generate protobuf files (both steps)
mix lightnex.protos.setup

# Or run individually:
mix lightnex.protos.fetch         # Download LND proto files
mix lightnex.protos.generate      # Generate Elixir modules

# Generate with documentation
mix lightnex.protos.generate --include-docs

# Clean and regenerate
mix lightnex.protos.generate --clean --verbose
```

### Docker-based Development

```bash
# Start Docker environment (bitcoind + two LND nodes)
make up

# Initialize Bitcoin regtest with spendable coins
make prime

# View logs
make logs

# Stop environment
make down

# Clean volumes and data
make clean
```

## Architecture

### Core Components

**`Lightnex` module (lib/lightnex.ex)**
- Main public API for all LND operations
- Functions return `{:ok, result}` or `{:error, reason}` tuples
- Organized into logical sections: connection management, node info, peers, channels, wallet

**`Lightnex.Conn` struct (lib/lightnex/conn.ex)**
- Connection abstraction holding gRPC channel, macaroon auth, timeout, and node metadata
- Validates connection options using NimbleOptions schema
- Handles macaroon extraction from files (`:file`), hex strings (`:hex`), or binary (`:bin`)
- Provides `grpc_metadata/1` to generate authentication headers for gRPC requests

**Generated Protobuf Modules (lib/lightnex/lnrpc/\*.pb.ex)**
- Auto-generated from LND protobuf definitions
- Namespaced under `Lightnex.LNRPC.*` (e.g., `Lightnex.LNRPC.Lightning`, `Lightnex.LNRPC.WalletUnlocker`)
- Module transformation logic in `Mix.Tasks.Lightnex.Protos.Generate` unifies disparate proto namespaces

### gRPC Communication Pattern

All LND API calls follow this pattern:

1. Build a request struct from the appropriate protobuf module
2. Get gRPC metadata (authentication) via `Conn.grpc_metadata/1`
3. Call the gRPC stub method with `channel`, `request`, and `metadata`
4. Return `{:ok, response}` or `{:error, GRPC.RPCError}`

Example from `Lightnex.get_info/1`:
```elixir
request = %Lightning.GetInfoRequest{}
metadata = Conn.grpc_metadata(conn)
Lightning.Stub.get_info(conn.channel, request, metadata: metadata)
```

### Authentication Flow

- **Macaroon Authentication**: LND uses macaroons for auth (similar to bearer tokens)
- Macaroons can be provided as file paths, hex strings, or binary
- Stored internally as hex in `Conn.macaroon_hex`
- Passed in gRPC metadata header: `%{macaroon: hex_string}`
- For local regtest testing, macaroons may not be required

### Test Helpers

**`Lightnex.LNHelpers` (test/support/ln_helpers.ex)**
- Integration test helpers for Docker-based LND nodes
- `connect_alice/1`, `connect_bob/1` - Connect to test nodes
- `ensure_wallet_ready/3` - Auto-creates/unlocks LND wallets in tests
- Handles LND wallet lifecycle: creation, unlocking, waiting for readiness
- Uses constants for node addresses, TLS certs, and macaroon paths

**Test Environment**
- Uses `Mimic` for mocking gRPC stubs and system calls
- Integration tests require Docker environment with `bitcoind` + two LND nodes (Alice, Bob)
- Run `make up && make prime` to start environment and generate initial blocks

### Module Generation Workflow

When updating to a new LND version:

1. Update `@lnd_version` in `Mix.Tasks.Lightnex.Protos.Fetch`
2. Run `mix lightnex.protos.setup`
3. The fetch task downloads proto files from LND GitHub
4. The generate task:
   - Runs `protoc` to generate Elixir modules
   - Transforms module namespaces to `Lightnex.LNRPC.*` hierarchy
   - Formats the generated code

The namespace transformation mappings are defined in `@lnd_packages` in the generate task.

## Key Implementation Patterns

### Connection Management

- Always validate connections with `get_info/1` unless `:validate` option is `false`
- Store `NodeInfo` in connection struct after validation
- Use `Conn.summary/1` for logging/debugging connection state
- Remember to call `disconnect/1` to close gRPC channels

### Error Handling

- All public functions return `{:ok, result}` or `{:error, reason}`
- gRPC errors are `GRPC.RPCError` structs with `:status` and `:message`
- Some functions handle expected errors gracefully (e.g., `connect_peer/4` treats "already connected" as success)

### Peer and Channel Operations

- Peers must be connected via `connect_peer/4` before opening channels
- `open_channel_sync/4` is synchronous (blocks until funding tx broadcast)
- Channel state queries: `list_channels/2`, `pending_channels/1`, `closed_channels/2`
- Use filter options to reduce response size (e.g., `active_only: true`)

### Testing Approach

- Unit tests mock gRPC stubs with Mimic
- Integration tests use real LND nodes in Docker
- Test fixtures in `test/support/fixtures/lightning_fixtures.ex`
- Integration test setup requires wallet initialization (automated in `LNHelpers`)

## Project Structure

```
lib/lightnex/
  application.ex          # OTP application (empty supervisor)
  conn.ex                 # Connection struct and helpers
  conn/node_info.ex       # Node information struct
  lnrpc/*.pb.ex          # Generated protobuf modules

lib/mix/
  lightnex.ex             # Shared mix utilities
  tasks/*.ex              # Mix tasks for proto generation

test/
  support/                # Test helpers and fixtures
  integration/            # Integration tests requiring Docker
  lightnex_test.exs       # Unit tests
  lightnex/conn_test.exs  # Connection tests
```

## Configuration Notes

- No runtime configuration needed for basic usage
- TLS and macaroon paths are provided per-connection
- Timeout defaults to 30 seconds (configurable via `:timeout` option)
- Test environment uses regtest Bitcoin network with predictable addresses

<!-- usage-rules-start -->
<!-- usage-rules-header -->
# Usage Rules

**IMPORTANT**: Consult these usage rules early and often when working with the packages listed below.
Before attempting to use any of these packages or to discover if you should use them, review their
usage rules to understand the correct patterns, conventions, and best practices.
<!-- usage-rules-header-end -->

<!-- lightnex-start -->
## lightnex usage
_Elixir client for the Lightning Network Daemon (LND)_

## Code Style and Formatting

### Formatting
- Run `mix format` before committing - the project uses strict formatting
- Maximum line length: 100 characters (Credo configured with this limit)
- Use 2 spaces for indentation (standard Elixir)
- Follow formatter config in `.formatter.exs` with `import_deps: [:protobuf, :grpc]`

### Module Organization
- Organize functions by logical sections using comment headers:
  ```elixir
  ## ===========================================================================
  ## Section Name
  ## ===========================================================================
  ```
- Common sections: Connection Management, Node Information, Peer Management, Channel Management, Wallet Management
- Group related functions together with their helper functions

### Naming Conventions
- Module names: PascalCase (e.g., `Lightnex.Conn.NodeInfo`)
- Function names: snake_case with descriptive verbs (e.g., `connect_peer`, `get_info`)
- Private functions: prefix with `defp` and keep near their callers
- Boolean functions: use `?` suffix (e.g., `authenticated?`)
- Constants: `@module_attribute` with SCREAMING_SNAKE_CASE values

## Documentation

### Module Documentation
- Every public module requires `@moduledoc` with comprehensive description
- Include "Features" or "Overview" sections for main modules
- Show "Quick Start" examples for user-facing APIs
- **Exception**: Generated protobuf modules (under `Lightnex.LNRPC.*`) are exempt from moduledoc requirement

### Function Documentation
All public functions require `@doc` with:
- Brief description (1-2 sentences)
- `## Parameters` section if function takes arguments
- `## Options` section for keyword list options (use `NimbleOptions.docs/1` when available)
- `## Examples` section with working code samples using `iex>` format
- Important notes using `> #### Note {: .info}` or `> #### Warning {: .warning}` blocks

### Typespec Requirements
- Every public function requires `@spec` with full type annotations
- Define custom types with `@type` and `@typedoc`
- Use `@enforce_keys` for structs with required fields
- Prefer specific types over `any()` (e.g., `non_neg_integer()` over `integer()`)
- Document struct types with field-by-field `@type` definitions

## Error Handling

### Return Values
- All public functions return tagged tuples: `{:ok, result}` or `{:error, reason}`
- Never raise exceptions in public API functions (except for `!` variants)
- Provide `!` variants (e.g., `new!/2`) only when explicitly needed

### gRPC Error Handling
- Catch `GRPC.RPCError` structs with `:status` and `:message` fields
- Handle expected errors gracefully (e.g., "already connected" → success)
- Include helpful error messages that guide users to solutions
- Use `with` clauses for multi-step operations with error propagation

### Pattern Matching
- Use pattern matching in function heads for validation
- Guard clauses for runtime checks: `when is_binary(pubkey) and is_binary(host)`
- Match on error tuples to provide context-specific handling

## Testing

### Test Structure
- Unit tests: Mock gRPC stubs and system calls with `Mimic`
- Integration tests: Use real Docker-based LND nodes (Alice and Bob)
- Organize tests by module: `test/lightnex_test.exs`, `test/lightnex/conn_test.exs`
- Test helpers in `test/support/` directory

### Mocking
Copy modules for mocking in `test_helper.exs`:
```elixir
[
  Lightnex.LNRPC.Lightning.Stub,
  GRPC.Stub,
  File,
  System
]
|> Enum.each(&Mimic.copy/1)
```
Use `Mimic.expect/4` to set up expectations in tests.

### Integration Tests
- Place in `test/integration/` directory
- Use `Lightnex.LNHelpers` for node connections
- Always call `ensure_wallet_ready/3` before running tests
- Clean up connections with `disconnect/1` in test cleanup

### Test Coverage
- Run `mix coveralls.html` to generate coverage reports
- Use `# coveralls-ignore-start` and `# coveralls-ignore-stop` for unreachable code
- Use `# sobelow_skip ["Category.Check"]` to skip false-positive security warnings
- Aim for high coverage on public API functions

## gRPC Patterns

### Communication Pattern
All LND API calls follow this pattern:

1. Build a request struct from the appropriate protobuf module
2. Get gRPC metadata (authentication) via `Conn.grpc_metadata/1`
3. Call the gRPC stub method with `channel`, `request`, and `metadata`
4. Return `{:ok, response}` or `{:error, GRPC.RPCError}`

Example:
```elixir
request = %Lightning.GetInfoRequest{}
metadata = Conn.grpc_metadata(conn)
Lightning.Stub.get_info(conn.channel, request, metadata: metadata)
```

### Request Construction
- Build protobuf request structs explicitly with all fields
- Use `Keyword.get/3` with sensible defaults for optional parameters
- Extract request building to private `build_*_request/N` functions for complex requests

### Metadata and Authentication
- Always get metadata via `Conn.grpc_metadata/1`
- Pass metadata as keyword option: `metadata: metadata`
- Never hardcode macaroons or credentials

### Stub Calls
- Pattern: `ModuleStub.function_name(channel, request, metadata: metadata)`
- Use full module path: `Lightnex.LNRPC.Lightning.Stub`
- Alias protobuf modules at module level for cleaner code

## Security

### File Operations
- Add `# sobelow_skip ["Traversal.FileModule"]` when reading user-provided file paths
- Validate file paths before operations (though this is a client library)
- Never log or expose macaroon contents in plaintext

### Input Validation
- Validate options with `NimbleOptions.validate!/2` for complex option schemas
- Use pattern matching and guards for parameter validation
- Convert between formats safely: hex ↔ binary with proper error handling

## Option Schemas with NimbleOptions

- Define schemas with `@schema NimbleOptions.new!(schema_list)` as module attributes
- Extract schema keys: `@keys Keyword.keys(@schema.schema)`
- Provide helper functions: `conn_opts/0`, `conn_opts_docs/0`
- Inline frequently used functions: `@compile {:inline, func: arity}`
- Validate early: `NimbleOptions.validate!(opts, @schema)`

## Code Organization

### Public vs Private
- Public API in main `Lightnex` module (`lib/lightnex.ex`)
- Supporting structs and utilities in submodules (`Lightnex.Conn.*`)
- Mix tasks in `lib/mix/tasks/`
- Test support code in `test/support/`
- Keep protobuf modules in `lib/lightnex/lnrpc/` (generated, don't edit manually)

### Dependencies
- Minimize dependencies - only add when necessary
- Core deps: `protobuf`, `grpc`, `nimble_options`, `telemetry`
- Test deps: `mimic`, `excoveralls`, `briefly`
- Dev deps: `credo`, `dialyxir`, `sobelow`, `ex_doc`

## Protobuf Generation

### Never Edit Generated Files
Files in `lib/lightnex/lnrpc/*.pb.ex` are auto-generated from LND protobuf definitions. Never edit these files manually.

### Updating to New LND Version
1. Update `@lnd_version` in `Mix.Tasks.Lightnex.Protos.Fetch`
2. Run `mix lightnex.protos.setup`
3. The fetch task downloads proto files from LND GitHub
4. The generate task runs `protoc`, transforms namespaces, and formats code

The namespace transformation mappings are defined in `@lnd_packages` in the generate task.

## Pre-commit Checklist

Before committing, run:
1. `mix format` - Format all code
2. `mix credo --strict` - Check for style issues
3. `mix test` - Ensure tests pass
4. `mix dialyzer` - Type checking (if adding new functions)

For full validation: `mix test.ci`

## Commit Guidelines

### Commit Messages
- Use imperative mood: "Add feature" not "Added feature"
- Be descriptive about what and why
- Reference issue numbers when applicable

### Pull Requests
- Ensure all CI checks pass
- Add tests for new functionality
- Update documentation for API changes
- Add entries to CHANGELOG.md for user-facing changes

<!-- lightnex-end -->

<!-- usage_rules-start -->
## usage_rules usage
_A dev tool for Elixir projects to gather LLM usage rules from dependencies_

## Using Usage Rules

Many packages have usage rules, which you should *thoroughly* consult before taking any
action. These usage rules contain guidelines and rules *directly from the package authors*.
They are your best source of knowledge for making decisions.

## Modules & functions in the current app and dependencies

When looking for docs for modules & functions that are dependencies of the current project,
or for Elixir itself, use `mix usage_rules.docs`

```
# Search a whole module
mix usage_rules.docs Enum

# Search a specific function
mix usage_rules.docs Enum.zip

# Search a specific function & arity
mix usage_rules.docs Enum.zip/1
```


## Searching Documentation

You should also consult the documentation of any tools you are using, early and often. The best 
way to accomplish this is to use the `usage_rules.search_docs` mix task. Once you have
found what you are looking for, use the links in the search results to get more detail. For example:

```
# Search docs for all packages in the current application, including Elixir
mix usage_rules.search_docs Enum.zip

# Search docs for specific packages
mix usage_rules.search_docs Req.get -p req

# Search docs for multi-word queries
mix usage_rules.search_docs "making requests" -p req

# Search only in titles (useful for finding specific functions/modules)
mix usage_rules.search_docs "Enum.zip" --query-by title
```


<!-- usage_rules-end -->
<!-- usage_rules:elixir-start -->
## usage_rules:elixir usage
# Elixir Core Usage Rules

## Pattern Matching
- Use pattern matching over conditional logic when possible
- Prefer to match on function heads instead of using `if`/`else` or `case` in function bodies
- `%{}` matches ANY map, not just empty maps. Use `map_size(map) == 0` guard to check for truly empty maps

## Error Handling
- Use `{:ok, result}` and `{:error, reason}` tuples for operations that can fail
- Avoid raising exceptions for control flow
- Use `with` for chaining operations that return `{:ok, _}` or `{:error, _}`

## Common Mistakes to Avoid
- Elixir has no `return` statement, nor early returns. The last expression in a block is always returned.
- Don't use `Enum` functions on large collections when `Stream` is more appropriate
- Avoid nested `case` statements - refactor to a single `case`, `with` or separate functions
- Don't use `String.to_atom/1` on user input (memory leak risk)
- Lists and enumerables cannot be indexed with brackets. Use pattern matching or `Enum` functions
- Prefer `Enum` functions like `Enum.reduce` over recursion
- When recursion is necessary, prefer to use pattern matching in function heads for base case detection
- Using the process dictionary is typically a sign of unidiomatic code
- Only use macros if explicitly requested
- There are many useful standard library functions, prefer to use them where possible

## Function Design
- Use guard clauses: `when is_binary(name) and byte_size(name) > 0`
- Prefer multiple function clauses over complex conditional logic
- Name functions descriptively: `calculate_total_price/2` not `calc/2`
- Predicate function names should not start with `is` and should end in a question mark.
- Names like `is_thing` should be reserved for guards

## Data Structures
- Use structs over maps when the shape is known: `defstruct [:name, :age]`
- Prefer keyword lists for options: `[timeout: 5000, retries: 3]`
- Use maps for dynamic key-value data
- Prefer to prepend to lists `[new | list]` not `list ++ [new]`

## Mix Tasks

- Use `mix help` to list available mix tasks
- Use `mix help task_name` to get docs for an individual task
- Read the docs and options fully before using tasks

## Testing
- Run tests in a specific file with `mix test test/my_test.exs` and a specific test with the line number `mix test path/to/test.exs:123`
- Limit the number of failed tests with `mix test --max-failures n`
- Use `@tag` to tag specific tests, and `mix test --only tag` to run only those tests
- Use `assert_raise` for testing expected exceptions: `assert_raise ArgumentError, fn -> invalid_function() end`
- Use `mix help test` to for full documentation on running tests

## Debugging

- Use `dbg/1` to print values while debugging. This will display the formatted value and other relevant information in the console.

<!-- usage_rules:elixir-end -->
<!-- usage_rules:otp-start -->
## usage_rules:otp usage
# OTP Usage Rules

## GenServer Best Practices
- Keep state simple and serializable
- Handle all expected messages explicitly
- Use `handle_continue/2` for post-init work
- Implement proper cleanup in `terminate/2` when necessary

## Process Communication
- Use `GenServer.call/3` for synchronous requests expecting replies
- Use `GenServer.cast/2` for fire-and-forget messages.
- When in doubt, use `call` over `cast`, to ensure back-pressure
- Set appropriate timeouts for `call/3` operations

## Fault Tolerance
- Set up processes such that they can handle crashing and being restarted by supervisors
- Use `:max_restarts` and `:max_seconds` to prevent restart loops

## Task and Async
- Use `Task.Supervisor` for better fault tolerance
- Handle task failures with `Task.yield/2` or `Task.shutdown/2`
- Set appropriate task timeouts
- Use `Task.async_stream/3` for concurrent enumeration with back-pressure

<!-- usage_rules:otp-end -->
<!-- usage-rules-end -->
