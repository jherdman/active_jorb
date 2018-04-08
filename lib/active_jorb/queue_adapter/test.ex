defmodule ActiveJorb.QueueAdapter.Test do
  @moduledoc """
  Use this module to facilitate testing. This will not execute the jobs (we can't,
  they're on a remote system), but we can verify that you enqueued a job with
  the correct parameters.
  """

  @behaviour ActiveJorb.QueueAdapter

  alias ActiveJorb.Job

  @process_queue_name "active_jorb_test_queue"

  @doc false
  def normalize(arg) do
    arg
  end

  @doc """
  Always returns a success response and pushes the `job` into the `Process`
  dictionary at the "active_jorb_test_queue" key.

  ## Example

      iex> job = %ActiveJorb.Job{job_class: "EmailClients", arguments: [1]}
      iex> {:ok, _jid} = ActiveJorb.QueueAdapter.Test.enqueue(job)
      iex> {enq_job} = Process.get("active_jorb_test_queue")
      iex> job == enq_job
  """
  def enqueue(job = %Job{}) do
    Process.put(@process_queue_name, {job})

    {:ok, random_jid()}
  end

  def enqueue(_job) do
    {:error, "your test adapter returned an error"}
  end

  @doc """
  Always returns a success response and pushes the `job`, and timestamp, into
  the `Process` dictionary at the "active_jorb_test_queue" key.

  ## Example

      iex> job = %ActiveJorb.Job{job_class: "EmailClients", arguments: [1]}
      iex> ts = ~N[2019-04-23 01:01:01]
      iex> {:ok, _jid} = ActiveJorb.QueueAdapter.Test.enqueue_at(job, ts)
      iex> {enq_job, enq_ts} = Process.get("active_jorb_test_queue")
      iex> job == enq_job
      iex> ts == enq_ts
  """
  def enqueue_at(job = %Job{}, timestamp) do
    Process.put(@process_queue_name, {job, timestamp})

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
