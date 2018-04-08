defmodule ActiveJorb.QueueAdapter.TestTest do
  use ExUnit.Case, async: true

  alias ActiveJorb.Job
  alias ActiveJorb.QueueAdapter.Test

  describe "#enqueue" do
    test "puts the job definition into the Process dictionary" do
      job = %Job{job_class: "MyJob", arguments: [1]}

      {:ok, _jid} = Test.enqueue(job)

      {enqueue_job} = Process.get("active_jorb_test_queue")

      assert job == enqueue_job
    end
  end

  describe "#enqueue_at" do
    test "puts the job definition and timestamp into the Process dictionary" do
      job = %Job{job_class: "MyJob", arguments: [1]}
      ts = ~N[2048-01-31 10:30:44]

      {:ok, _jid} = Test.enqueue_at(job, ts)

      {enqueue_job, enqueued_timestamp} = Process.get("active_jorb_test_queue")

      assert job == enqueue_job
      assert ts == enqueued_timestamp
    end
  end
end
