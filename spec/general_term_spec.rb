RSpec.describe Syllogism::GeneralTerm do
  subject { described_class.new(value) }

  describe "#match?" do
    context 'with a matching value' do
      let(:value) { 'A' }

      it { expect(subject).to be_match }
    end

    context 'with a non-matching value' do
      let(:value) { 'all' }

      it { expect(subject).to_not be_match }
    end
  end 
end
