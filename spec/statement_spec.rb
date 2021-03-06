RSpec.describe Syllogism::Statement do
  subject { described_class.parse(raw_statement) }

  describe "[]" do
    let(:raw_statement) { "all X is Y" }

    it "acts as an abbreviated parse" do
      instance = described_class[raw_statement]
      expect(instance.atoms.length).to eq(4)
    end
  end

  describe "#distribute" do
    it "distributes after an 'all'" do
      statement = described_class.parse("all A is B")
      statement.distribute
      expect(statement.subject).to be_distributed
      expect(statement.predicate).to_not be_distributed
    end

    it "distributes every term after a 'no'" do
      statement = described_class.parse("no A is B")
      statement.distribute
      expect(statement.subject).to be_distributed
      expect(statement.predicate).to be_distributed
    end

    it "distributes after a 'not'" do
      statement = described_class.parse("some A is not B")
      statement.distribute
      expect(statement.subject).to_not be_distributed
      expect(statement.predicate).to be_distributed
    end

    it "otherwise doesn't distribute" do
      statement = described_class.parse("some A is B")
      statement.distribute
      expect(statement.subject).to_not be_distributed
      expect(statement.predicate).to_not be_distributed
    end
  end

  describe "#predicate" do
    let(:raw_statement) { "all X is Y" }

    it { expect(subject.predicate.value).to eq("Y") }
  end

  describe "#subject" do
    let(:raw_statement) { "all X is Y" }

    it { expect(subject.subject.value).to eq("X") }
  end

  describe "#wff" do
    context "when the statement is well-formed" do
      let(:well_formed_raw_statements) do
        ["all X is Y", "some X is Y", "no X is Y", "some X is not Y"]
      end

      it do
        well_formed_raw_statements.each do |raw_statement|
          expect(described_class.parse(raw_statement)).to be_wff
        end
      end
    end

    context "when the statement is not well-formed" do
      let(:poorly_formed_raw_statements) do
        ["only A is B", "some a is b", "F is G", "all X is not Y"]
      end

      it do
        poorly_formed_raw_statements.each do |raw_statement|
          expect(described_class.parse(raw_statement)).to_not be_wff
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
