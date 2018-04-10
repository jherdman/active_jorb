if Code.ensure_loaded?(Sidewalk) do
  defmodule ActiveJorb.QueueAdapter.Sidekiq do
    @moduledoc """
    Uses the [sidewalk](https://hex.pm/packages/sidewalk) library to enqueue jobs
    with Sidekiq.

    ## Example

    ```
    iex> job = %ActiveJorb.Job{job_class: "MyJob", arguments: [1, 2, 3], queue_name: "high"}
    iex> ActiveJorb.QueueAdapter.Sidekiq.enqueue(job)
    {:ok, "some-job-id"}
    ```
    """

    @behaviour ActiveJorb.QueueAdapter

    @doc """
    Used to normalize an `%ActiveJorb.Job{}` into a `%Sidewalk.Job{}`. You
    shouldn't use this directly.
    """
    @spec normalize(ActiveJorb.Job.t()) :: Sidewalk.Job.t()
    def normalize(job) do
      %Sidewalk.Job{
        class: "ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper",
        wrapped: job.job_class,
        queue: job.queue_name,
        retry: job.retry,
        args: [job]
      }
    end

    @doc """
    Enqueues a job at some future date.
    """
    @spec enqueue_at(ActiveJorb.Job.t(), NaiveDateTime.t()) :: ActiveJorb.QueueAdapter.response()
    def enqueue_at(job = %ActiveJorb.Job{}, timestamp = %NaiveDateTime{}) do
      normalized_timestamp = normalize_timestamp(timestamp)

      job
      |> normalize()
      |> Sidewalk.Client.enqueue_at(normalized_timestamp)
    end

    def enqueue_at(_, _) do
      {:error, "you must provide both an %ActiveJorb.Job{} and a NaiveDateTime."}
    end

    @spec normalize_timestamp(NaiveDateTime.t()) :: float()
    defp normalize_timestamp(timestamp) do
      ts =
        timestamp
        |> DateTime.from_naive!("Etc/UTC")
        |> DateTime.to_unix()

      ts / 1
    end

    @doc """
    Enqueues a job that will be executed immediately.
    """
    @spec enqueue(ActiveJorb.Job.t()) :: ActiveJorb.QueueAdapter.response()
    def enqueue(job = %ActiveJorb.Job{}) do
      job
      |> normalize()
      |> Sidewalk.Client.enqueue()
    end

    def enqueue(_) do
      {:error, "you must provide an %ActiveJorb.Job{}"}
    end
  end
end
