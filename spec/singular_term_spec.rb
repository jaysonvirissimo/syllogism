RSpec.describe Syllogism::SingularTerm do
  subject { described_class.new(value) }

  describe "#match?" do
    context "with a matching value" do
      let(:value) { "a" }

      it { expect(subject).to be_match }
    end

    context "with a non-matching value" do
      let(:value) { "is" }

      it { expect(subject).to_not be_match }
    end
  end

  describe "#distributed?" do
    let(:value) { "A" }

    context "when set to true" do
      it do
        subject.distributed = true
        expect(subject).to be_distributed
      end
    end

    context "when set to false" do
      it do
        subject.distributed = false
        expect(subject).to_not be_distributed
      end
    end
  end
end
