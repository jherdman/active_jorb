# ActiveJorb [![CircleCI](https://circleci.com/gh/jherdman/active_jorb/tree/master.svg?style=svg)](https://circleci.com/gh/jherdman/active_jorb/tree/master)

An Active Job compatible queueing interface. This library will allow you to
enqueue jobs on your existing Active Job compatible backend. This is particularly
useful if you're strangling your existing Rails project to death.

The intention is to fully support any and all backends that Active Job supports.
Pull requests are much appreciated.

## Installation

```elixir
def deps do
  [
    {:active_jorb, "~> 0.1.0"}
  ]
end
```

## Supported Backends

| Backend       | Supported? | Add to mix.exs           | Link                             |
|---------------|------------|--------------------------|----------------------------------|
| Sidekiq       | Yes        | `{:sidewalk, "~> 0.3.4}` | https://hex.pm/packages/sidewalk |
| Resque        | No (#6)    |                          |                                  |
| Que           | No (#4)    |                          |                                  |
| Queue Classic | No (#5)    |                          |                                  |
| Backburner    | No (#3)    |                          |                                  |
| Sucker Punch  | No (#8)    |                          |                                  |
| Sneakers      | No (#7)    |                          |                                  |

## Usage

After installing the dependency for your required backend, it's recommended that
you proxy access to the supported queue adapter in your application:

```elixir
# config/dev.exs
config :my_application, MyApplication,
  job_queue_adapter: ActiveJorb.QueueAdapter.Sidekiq

# config/test.exs -- note the test adapter is still WIP
config :my_application, MyApplication,
  job_queue_adapter: ActiveJorb.QueueAdapter.Test

# lib/my_application/job_queue.ex
defmodule MyApplication.JobQueue do
  @queue_adapter Application.get_env(:my_application, :job_queue_adapter)

  defdelegate enqueue(job), to: @queue_adapter
  defdelegate enqueue_at(job), to: @queue_adapter
end
```

To enqueue a job you must first construct an `%ActiveJorb.Job{}`, and then pass
it to the enqueue method of choice:

```
iex> job = %ActiveJorb.Job{job_class: "MyJob", arguments: [1, 2, 3]}
iex> MyApplication.JobQueue.enqueue(job)
{:ok, "some-job-id"}

iex> ts = ~N[2019-01-01 12:30:00]
iex> MyApplication.JobQueue.enqueue_at(job, ts)
{:ok, "some-other-job-id"}
```

## Testing

WIP (#9)

## Prior Art, Credit, and Thanks

* All of the maintainers of Active Job
* The various authors of any supported backend
* The various authors of any Elixir library supporting those backends
