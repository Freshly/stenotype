# frozen_string_literal: true

require "spec_helper"

RSpec.describe Stenotype::Adapters::Base do
  let(:klass) { Class.new(described_class) }
  let(:klass_instance) { klass.new }
  let(:event_data) { object_double(:event_data) }

  describe "#publish" do
    subject(:publish) { klass_instance.publish(event_data) }

    context "when not implemented" do
      it "raises NotImplementedError" do
        expect { publish }.to raise_error(NotImplementedError)
      end
    end

    context "when a subclass implements method #publish" do
      before do
        klass.class_eval do
          def publish(*_args)
            # do nothing
            true
          end
        end
      end

      it "does not raise" do
        expect(publish).to eq(true)
      end
    end
  end

  describe "#flush" do
    subject(:flush!) { klass_instance.flush! }

    context "when not implemented" do
      it "raises NotImplementedError" do
        expect { flush! }.to raise_error(NotImplementedError)
      end
    end

    context "when a subclass implements method #flush!" do
      before do
        klass.class_eval do
          def flush!
            # do nothing
            true
          end
        end
      end

      it "does not raise" do
        expect(flush!).to eq(true)
      end
    end
  end

  describe "#auto_initialize!" do
    subject(:auto_initialize!) { klass_instance.auto_initialize! }

    context "when not implemented" do
      it "does nothing" do
        expect(auto_initialize!).to eq(nil)
      end
    end

    context "when a subclass implements method #auto_initialize!" do
      before do
        klass.class_eval do
          def auto_initialize!
            # do nothing
            true
          end
        end
      end

      it "setups the adapter" do
        expect(auto_initialize!).to eq(true)
      end
    end
  end
end
