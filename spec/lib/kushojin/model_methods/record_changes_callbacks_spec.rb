require "spec_helper"

RSpec.describe Kushojin::ModelMethods::RecordChangesCallbacks do
  describe ".record_changes" do
    let(:model) do
      Class.new(ActiveRecord::Base) do
        self.table_name = "users".freeze
      end
    end

    shared_context "create a record" do
      before { Kushojin::Recorder.build }
      subject(:change_record) { model.create(name: "bill", age: 20) }
    end

    shared_context "update a record" do
      before do
        model.create(name: "bill", age: 20)
        Kushojin::Recorder.build
      end

      subject(:change_record) { model.take.update(name: "bob", age: 21) }
    end

    shared_context "destroy a record" do
      before do
        model.create(name: "bill", age: 20)
        Kushojin::Recorder.build
      end

      subject(:change_record) { model.take.destroy }
    end

    shared_examples "record a change" do |event|
      it { expect { change_record }.to change(Kushojin::Recorder.changes, :size).by(1) }
      it { expect(recorded_change.event).to eq(event) }
    end

    shared_examples "record no change" do |event|
      it { expect { change_record }.not_to change(Kushojin::Recorder.changes, :size) }
    end

    after do
      model.delete_all
      Kushojin::Recorder.destroy
    end

    subject(:recorded_change) do
      change_record
      Kushojin::Recorder.changes.last
    end

    context "when record_changes has no option" do
      before do
        model.record_changes
      end

      context "and create a record" do
        include_context "create a record"
        include_examples "record a change", :create
      end

      context "and update attributes" do
        include_context "update a record"
        include_examples "record a change", :update
      end

      context "and delete a record" do
        include_context "destroy a record"
        include_examples "record a change", :destroy
      end
    end

    context "when record_changes has only option" do
      before do
        model.record_changes only: [:create, :destroy]
      end

      context "and create a record" do
        include_context "create a record"
        include_examples "record a change", :create
      end

      context "and update attributes" do
        include_context "update a record"
        include_examples "record no change", :update
      end

      context "and delete a record" do
        include_context "destroy a record"
        include_examples "record a change", :destroy
      end
    end
  end
end
