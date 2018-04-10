defmodule ActiveJorb.QueueAdapter.Test do
  @moduledoc """
  Use this module to facilitate testing. This will not execute the jobs (we can't,
  they're on a remote system), but we can verify that you enqueued a job with
  the correct parameters.
  """

  @behaviour ActiveJorb.QueueAdapter

  alias ActiveJorb.Job

  @doc """
  Starts the Agent required to capture arguments passed to your adapter.
  """
  def start_link() do
    Agent.start_link(fn -> [] end, name: __MODULE__)
  end

  @doc """
  Probably not directly needed, but you can use this to stop our agent.
  """
  def stop() do
    Agent.stop(__MODULE__)
  end

  defp update_queue(job, timestamp \\ nil) do
    Agent.update(__MODULE__, fn jobs ->
      jobs ++ [{job, timestamp}]
    end)
  end

  @doc """
  Returns all jobs and their respective timestamps (if any) in a LIFO list.
  """
  @spec get_queue() :: [{Job.t(), timestamp :: nil | NaiveDateTime.t()}]
  def get_queue() do
    Agent.get(__MODULE__, fn jobs -> jobs end)
  end

  @doc false
  def normalize(arg) do
    arg
  end

  @doc """
  Always returns a success response and pushes the `job` into the test queue.

  ## Example

      iex> job = %ActiveJorb.Job{job_class: "EmailClients", arguments: [1]}
      iex> {:ok, _jid} = ActiveJorb.QueueAdapter.Test.enqueue(job)
      iex> [{enq_job, enq_ts}] = ActiveJorb.QueueAdapter.Test.get_queue()
      iex> job == enq_job
  """
  def enqueue(job = %Job{}) do
    update_queue(job)

    {:ok, random_jid()}
  end

  def enqueue(_job) do
    {:error, "your test adapter returned an error"}
  end

  @doc """
  Always returns a success response and pushes the `job`, and timestamp, into
  the test queue.

  ## Example

      iex> job = %ActiveJorb.Job{job_class: "EmailClients", arguments: [1]}
      iex> ts = ~N[2019-04-23 01:01:01]
      iex> {:ok, _jid} = ActiveJorb.QueueAdapter.Test.enqueue_at(job, ts)
      iex> [{enq_job, enq_ts}] = ActiveJorb.QueueAdapter.Test.get_queue()
      iex> job == enq_job
      iex> ts == enq_ts
  """
  def enqueue_at(job = %Job{}, timestamp) do
    update_queue(job, timestamp)

    {:ok, random_jid()}
  end

  def enqueue_at(_job, _timestamp) do
    {:error, "your test adapter returned an error"}
  end

  defp random_jid do
    12
    |> :crypto.strong_rand_bytes()
    |> Base.encode16(case: :lower)
  end
end
