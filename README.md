# ActiveJorb [![CircleCI](https://circleci.com/gh/jherdman/active_jorb/tree/master.svg?style=svg)](https://circleci.com/gh/jherdman/active_jorb/tree/master)

An Active Job compatible queueing interface. This library will allow you to
enqueue jobs on your existing Active Job compatible backend. This is particularly
useful if you're strangling your existing Rails project to death.

The intention is to fully support any and all backends that Active Job supports.
Pull requests are much appreciated.

## Supported Backends

* Sidekiq (via [sidewalk](https://hex.pm/packages/sidewalk))

## Installation

```elixir
def deps do
  [
    {:active_jorb, "~> 0.1.0"}
  ]
end
```

## Prior Art, Credit, and Thanks

* All of the maintainers of Active Job
* The various authors of any supported backend
* The various authors of any Elixir library supporting those backends
