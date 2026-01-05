# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Workflow

- **TDD**: Specs first, then implementation. Write the failing test before writing code.
- Focus on relevant specs that catch broken business logic, not trivial boilerplate.
- 2 spaces for indentation.

## Project Overview

Hospital is a Ruby gem framework for application self-checks and diagnostics. Classes extend the `Hospital` module to define checkups that produce diagnoses with errors, warnings, info, and skip messages.

## Commands

```bash
# Run tests
rake spec

# Run a single test file
bundle exec rspec spec/hospital/checkup_spec.rb

# Interactive console
bin/console

# Install gem locally
bundle exec rake install

# In Rails apps: run all checkups
rake doctor           # normal mode
rake doctor[true]     # verbose mode
```

## Architecture

### Core Components

- **Hospital module** (`lib/hospital.rb`): Main entry point. Classes `extend Hospital` (not include) to gain the `checkup` method. Manages global registry of checkup groups.

- **Checkup** (`lib/hospital/checkup.rb`): Individual diagnostic check. Takes a block that receives a Diagnosis object. Supports conditional execution via `if:` lambda and grouping via `group:` parameter.

- **CheckupGroup** (`lib/hospital/checkup_group.rb`): Organizes related checkups. Supports precondition checkups that must pass before dependent checkups run.

- **Diagnosis** (`lib/hospital/diagnosis.rb`): Result container passed to checkup blocks. Methods: `add_info`, `add_warning`, `add_error`, `add_skip`, `require_env_vars`.

- **Runner** (`lib/hospital.rb:61`): Orchestrates all checkups and outputs results via a formatter.

- **Formatters** (`lib/hospital/formatter/`): Output strategies - Shell (colored terminal), Pre (markdown/HTML), Raw (structured data).

### Usage Pattern

```ruby
class MyService
  extend Hospital

  checkup group: :api, title: "API connectivity" do |d|
    if connected?
      d.add_info "Connected successfully"
    else
      d.add_error "Connection failed"
    end
  end

  checkup group: :api, precondition: true do |d|
    # If this fails, other :api checkups are skipped
    d.add_error "Missing API key" unless ENV['API_KEY']
  end

  checkup if: -> { Rails.env.production? } do |d|
    # Only runs in production
  end
end
```

### Key Design Decisions

- Uses `extend` not `include` - checkups are class-level, not instance methods
- Checkups are registered globally in `Hospital.groups` class variable
- Uses Ruby refinements for string formatting (`StringFormatter`)
- Rails integration is optional, loaded via Railtie when Rails is defined
