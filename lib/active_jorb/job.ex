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
          priority: String.t(),
          arguments: list(),
          locale: String.t(),
          retry: boolean
        }

  @enforce_keys [:job_class]

  defstruct job_class: nil,
            queue_name: "default",
            priority: "",
            arguments: [],
            locale: "en",
            retry: true
end
