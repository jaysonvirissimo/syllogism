RSpec.describe Syllogism::Statement do
  subject { described_class.new(raw_statement) }

  describe "#wff" do
    context "when the statement is well-formed" do
      let(:well_formed_raw_statements) do
        ["all X is Y", "some X is Y", "no X is Y", "no X is Y"]
      end

      it do
        well_formed_raw_statements.each do |raw_statement|
          expect(described_class.new(raw_statement)).to be_wff
        end
      end
    end

    context "when the statement contains unrecognizable atoms" do
      let(:raw_statement) { "all 1s are numbers" }

      it "records which atoms are unknown" do
        expect(subject).to_not be_wff
        expect(subject.errors).to include("'1s' is an unknown atom")
        expect(subject.errors).to include("'numbers' is an unknown atom")
      end
    end

    context "when the statement lacks a verb" do
      let(:raw_statement) { "all X Y" }

      it { expect(subject).to_not be_wff }
    end
  end
end
