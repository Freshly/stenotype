# frozen_string_literal: true

RSpec.describe Stenotype do
  subject { described_class }

  it "has a version number" do
    expect(Stenotype::VERSION).not_to be nil
  end

  it { is_expected.to delegate_config_to Stenotype::Configuration }
end
