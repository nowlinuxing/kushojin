require "spec_helper"

RSpec.describe Kushojin::ModelMethods::RecordChangesCallbacks do
  describe ".record_changes" do
    after do
      User.delete_all
      Kushojin::Recorder.destroy
    end

    subject(:recorded_change) do
      change_record
      Kushojin::Recorder.changes.last
    end

    context "when create a record" do
      before { Kushojin::Recorder.build }
      subject(:change_record) { User.create(name: "bill", age: 20) }

      it { expect { change_record }.to change(Kushojin::Recorder.changes, :size).by(1) }
      it { expect(recorded_change.event).to eq(:create) }
    end

    context "when update attributes" do
      before do
        User.create(name: "bill", age: 20)
        Kushojin::Recorder.build
      end

      subject(:change_record) { User.take.update(name: "bob", age: 21) }

      it { expect { change_record }.to change(Kushojin::Recorder.changes, :size).by(1) }
      it { expect(recorded_change.event).to eq(:update) }
    end

    context "when delete a record" do
      before do
        User.create(name: "bill", age: 20)
        Kushojin::Recorder.build
      end

      subject(:change_record) { User.take.destroy }

      it { expect { change_record }.to change(Kushojin::Recorder.changes, :size).by(1) }
      it { expect(recorded_change.event).to eq(:destroy) }
    end
  end
end
