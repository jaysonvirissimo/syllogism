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
end
