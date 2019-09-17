require "spec_helper"

RSpec.describe Kushojin::ModelMethods::Change do
  describe "#initialize" do
    after do
      User.delete_all
    end

    shared_examples "keeping a duplicated model" do
      it { expect(subject.model).to be_an_instance_of(User).and be_frozen }
      it { expect(subject.model).to have_attributes(model.attributes) }
      it { expect(subject.model.object_id).not_to eq(model.object_id) }
    end

    context "when the record is created" do
      let(:model) { User.create(name: "bill", age: 20) }
      subject { Kushojin::ModelMethods::Change.new(:create, model) }

      it { expect(subject.event).to eq(:create) }
      it_behaves_like "keeping a duplicated model"
      it do
        expect(subject.changes).to eq(
          "id"         => [nil, model.id],
          "name"       => [nil, "bill"],
          "age"        => [nil, 20],
          "created_at" => [nil, model.created_at],
          "updated_at" => [nil, model.updated_at],
        )
      end
    end

    context "when the record is updated" do
      before do
        User.create(name: "bill", age: 20)
      end

      let(:model) do
        u = User.take
        u.update(name: "bob", age: 21)
        u
      end
      subject { Kushojin::ModelMethods::Change.new(:update, model) }

      it { expect(subject.event).to eq(:update) }
      it_behaves_like "keeping a duplicated model"
      it do
        expect(subject.changes).to match(
          "name"       => ["bill", "bob"], # rubocop:disable Style/WordArray
          "age"        => [20, 21],
          "updated_at" => [an_instance_of(Time), model.updated_at],
        )
      end
    end

    context "when the record is touched" do
      before do
        User.create(name: "bill", age: 20)
      end

      let(:model) do
        u = User.take
        u.touch
        u
      end
      subject { Kushojin::ModelMethods::Change.new(:touch, model) }

      it { expect(subject.event).to eq(:touch) }
      it_behaves_like "keeping a duplicated model"

      if ActiveRecord.version >= Gem::Version.new("6.0.0")
        it { expect(subject.changes).to match("updated_at" => [an_instance_of(Time), model.updated_at]) }
      else
        it { expect(subject.changes).to match({}) }
      end
    end

    context "when the record is created" do
      before do
        User.create(name: "bill", age: 20)
      end

      let(:model) do
        u = User.take
        u.destroy
        u
      end
      subject { Kushojin::ModelMethods::Change.new(:destroy, model) }

      it { expect(subject.event).to eq(:destroy) }
      it_behaves_like "keeping a duplicated model"
      it { expect(subject.changes).to match({}) }
    end
  end
end
