defmodule ActiveJorb.Job do
  @moduledoc """
  Represents some ActiveJob you wish to enqueue. This is a simplified form of
  the serialized form of an ActiveJob

  ## References

  * [ActiveJob::Core#serialize](https://github.com/rails/rails/blob/bedb3e2250d418b13f9531b309dcf47da792aa5b/activejob/lib/active_job/core.rb#L85-L95)
  """

  @type t :: %__MODULE__{
          job_class: String.t(),
          queue_name: String.t(),
          priority: nil | String.t(),
          arguments: list(),
          locale: String.t(),
          executions: pos_integer(),
          job_id: nil | String.t()
        }

  @enforce_keys [:job_class]

  defstruct job_class: nil,
            queue_name: "default",
            priority: nil,
            arguments: [],
            locale: "en",
            executions: 0,
            job_id: nil
end
