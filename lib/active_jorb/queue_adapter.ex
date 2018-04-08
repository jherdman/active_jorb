defmodule ActiveJorb.QueueAdapter do
  @moduledoc """
  Defines the generic implementation an adapter must provide. Make sure you read
  the documentation for your specific adapter of interest. It'll have more
  information on the particulars of using it.
  """

  @type response :: {:ok, String.t()} | {:error, String.t()}

  @doc """
  Used to enqueue a job that should be executed on a specific date and/or
  time.

  This could also be used to delay job execution by a specific amount of
  time by constructing the appropriate timestamp.
  """
  @callback enqueue_at(
              job :: ActiveJorb.Job.t(),
              when_to_execute_job :: NaiveDateTime.t()
            ) :: response

  @doc """
  Used to enqueue a job that should be executed immediately.
  """
  @callback enqueue(job :: ActiveJorb.Job.t()) :: response

  @doc """
  Not used directly by the end user, but employed by the queue adapter
  to turn an `%ActiveJorb.Job{}` into something the underlying adapter
  understands.
  """
  @callback normalize(job :: ActiveJorb.Job.t()) :: map()
end
