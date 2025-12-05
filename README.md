# EasyBroker Coding Challenge (Ruby)

This project implements an object-oriented Ruby client to consume the EasyBroker API (test environment), retrieve all available properties, and print their titles. The code follows best practices based on Clean Code principles and POODR (Practical Object-Oriented Design in Ruby).

## Features

* Clean, modular, object-oriented architecture
* Small classes with single responsibilities
* Dependency injection for improved testability
* Safe, predictable pagination handling
* Executable CLI script
* Unit tests with RSpec (no real network calls)
* Compatible with the EasyBroker test environment

## Project Structure

```
.
├── Gemfile
├── bin
│   └── print_property_titles
├── lib
│   └── easy_broker
│       ├── api_client.rb
│       ├── property_fetcher.rb
│       └── property_title_printer.rb
└── spec
    └── easy_broker
        ├── property_fetcher_spec.rb
        └── property_title_printer_spec.rb
```

## Architecture Overview

### ApiClient

Handles all HTTP communication with the EasyBroker API.
Does not know anything about pagination, output formatting, or business rules.

### PropertyFetcher

Uses the ApiClient to retrieve paginated property data.
Provides an enumerator-like interface through:

```
each_property { |property| ... }
```

Encapsulates:

* Pagination logic
* Iteration through all available pages
* Safe handling of `next_page`

### PropertyTitlePrinter

Receives a PropertyFetcher and prints titles to any IO object (default: STDOUT).
Focused on presentation only.

## Benefits

* Highly decoupled components
* Easy to test and maintain
* No network calls inside tests (uses doubles)
* Straightforward to extend (e.g., filtering, saving to DB, alternate outputs)

## Running the Script

Install dependencies:

```
bundle install
```

Execute:

```
bundle exec ruby bin/print_property_titles
```

Or:

```
./bin/print_property_titles
```

## Environment Variables

The default EasyBroker test API key is used automatically:

```
EASYBROKER_API_KEY="l7u502p8v46ba3ppgvj5y2aad50lb9"
```

To provide a custom one:

```
export EASYBROKER_API_KEY="your_api_key"
```

## SSL Note for macOS

Some macOS environments (rbenv + OpenSSL) may produce SSL verification errors.
For local development only, you may disable verification:

```
export DISABLE_SSL_VERIFY=true
```

SSL verification remains enabled by default for safe environments.

## Running Tests

```
bundle exec rspec
```

Expected output:

```
..

Finished in 0.0X seconds
2 examples, 0 failures
```

## Interview Notes

* Clear separation of responsibilities
* Small, focused classes
* Dependency injection for flexible testing
* Composition over inheritance
* Safe pagination without infinite loops
* Zero network calls in unit tests
* Minimal public interfaces

## Conclusion

This solution fully meets the requirements of the EasyBroker coding challenge:

* Correct API consumption
* Clean and maintainable code
* Unit tests included
* Executable script
* Professional, extensible architecture
