require "spec_helper"

RSpec.describe Kushojin::ModelMethods::RecordChangesCallbacks do
  let(:model) do
    Class.new(ActiveRecord::Base) do
      self.table_name = "users".freeze
    end
  end

  let(:callbacks) { Kushojin::ModelMethods::RecordChangesCallbacks.new }

  before do
    Kushojin::Recorder.build
  end

  after do
    model.delete_all
    Kushojin::Recorder.destroy
  end

  describe "#after_create" do
    let(:record) do
      model.create(name: "bill", age: 20)
    end

    subject { callbacks.after_create(record) }

    it "should record a Change of create" do
      expect { subject }.to change(Kushojin::Recorder.changes, :size).by(1)
      expect(Kushojin::Recorder.changes.last.event).to eq(:create)
    end
  end

  describe "#after_update" do
    let(:record) do
      r = model.create(name: "bill", age: 20)
      r.update(name: "bob", age: 21)
      r
    end

    subject { callbacks.after_update(record) }

    it "should record a Change of update" do
      expect { subject }.to change(Kushojin::Recorder.changes, :size).by(1)
      expect(Kushojin::Recorder.changes.last.event).to eq(:update)
    end
  end

  describe "#before_destroy" do
    let(:record) do
      r = model.create(name: "bill", age: 20)
      r.destroy
    end

    subject { callbacks.before_destroy(record) }

    it "should record a Change of destroy" do
      expect { subject }.to change(Kushojin::Recorder.changes, :size).by(1)
      expect(Kushojin::Recorder.changes.last.event).to eq(:destroy)
    end
  end
end
