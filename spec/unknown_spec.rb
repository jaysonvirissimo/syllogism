RSpec.describe Syllogism::Unknown do
  describe "#match?" do
    context "with literally anything not recognized as another atom" do
      let(:values) { [1, false, "foo"] }

      it do
        values.each do |value|
          expect(described_class.new(value)).to be_match
        end
      end
    end
  end
end
