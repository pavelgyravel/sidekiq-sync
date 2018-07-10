RSpec.describe Sidekiq::Sync do
  it "has a version number" do
    expect(Sidekiq::Sync::VERSION).not_to be nil
  end
end
