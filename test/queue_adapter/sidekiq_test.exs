defmodule ActiveJorb.QueueAdapter.SidekiqTest do
  use ExUnit.Case

  setup do
    {:ok, conn} = Redix.start_link()
    {:ok, "OK"} = Redix.command(conn, ~w(FLUSHDB))

    {:ok, [redis: conn]}
  end

  alias ActiveJorb.Job
  alias ActiveJorb.QueueAdapter.Sidekiq

  describe "#enqueue" do
    test "enqueue immediately performed job" do
      job = %Job{
        job_class: "MyJob",
        arguments: [1, 2, 3],
        queue_name: "high"
      }

      assert {:ok, _jid} = Sidekiq.enqueue(job)
    end

    test "enqueue immediately performed fails" do
      assert {:error, _msg} = Sidekiq.enqueue(nil)
    end

    test "enqueue job delayed until certain date", %{redis: redis} do
      job = %Job{
        job_class: "MyJob",
        arguments: [1, 2, 3],
        queue_name: "high"
      }

      delay = ~N[2048-01-01 12:30:00]

      assert {:ok, jid} = Sidekiq.enqueue_at(job, delay)

      [raw_stored_job, _raw_execution_time] =
        Redix.command!(redis, ~w(ZRANGE schedule 0 0 WITHSCORES))

      stored_job = Poison.decode!(raw_stored_job, as: %Sidewalk.Job{})

      assert stored_job.jid == jid
    end

    test "enqueue at a certain date fails" do
      assert {:error, _msg} = Sidekiq.enqueue_at(nil, nil)
    end
  end

  describe "#normalize" do
    test "it wraps the ActiveJob accordingly" do
      job = %ActiveJorb.Job{
        job_class: "MyJob",
        arguments: [1, 2, 3],
        queue_name: "high"
      }

      normalized_job = Sidekiq.normalize(job)

      assert normalized_job.class == "ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper"
      assert normalized_job.wrapped == job.job_class
      assert normalized_job.queue == job.queue_name
      assert normalized_job.args == [job]
    end
  end
end
