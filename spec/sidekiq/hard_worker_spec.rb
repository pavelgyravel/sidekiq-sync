RSpec.describe HardWorker do
  it "performs sync" do
    result = HardWorker.perform_sync "hardly working", 0.0001
    expect(result).to eq "hardly working"
  end

  it "performs sync two times" do
    result1 = HardWorker.perform_sync "first", 0.0001
    result2 = HardWorker.perform_sync "second", 0.0001

    expect(result1).to eq "first"
    expect(result2).to eq "second"
  end

  it "performs async" do
    Sidekiq.redis do |r|
      r.del "didasync"
    end
    HardWorker.perform_async "async", 0.0001
    loop do
      value = Sidekiq.redis do |r|
        r.get "didasync"
      end
      break if value
      puts "waiting for async job to finish..."
      sleep 0.1
    end
  end

  it "performs sync with timeout and does not raise" do
    options = Sidekiq::Sync::Options.new timeout: 1, raise: false

    started_at = Time.now
    value = HardWorker.perform_sync options, "timeout", 2
    stopped_at = Time.now
    delta = stopped_at - started_at

    expect(value).to eq nil
    expect(delta).to be > 1
    expect(delta).to be < 2
  end

  it "performs sync with timeout and raises" do
    options = Sidekiq::Sync::Options.new timeout: 1
    value = nil
    expect {
      value = HardWorker.perform_sync options, "timeout", 2
    }.to raise_error Sidekiq::Sync::TimeoutError

    expect(value).to eq nil
  end

  it "options can be in any position" do
    options = Sidekiq::Sync::Options.new timeout: 1
    value = nil

    started_at = Time.now
    expect {
      value = HardWorker.perform_sync "timeout", options, 2
    }.to raise_error Sidekiq::Sync::TimeoutError
    stopped_at = Time.now
    delta = stopped_at - started_at

    expect(value).to eq nil
    expect(delta).to be > 1
    expect(delta).to be < 2
  end
end
