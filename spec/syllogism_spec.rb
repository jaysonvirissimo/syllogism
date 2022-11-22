RSpec.describe Syllogism do
  subject { described_class[*raw_statements] }

  it "has a version number" do
    expect(Syllogism::VERSION).not_to be nil
  end

  describe "[]" do
    context "with an invalid statement" do
      let(:raw_statements) { ["all X Y", "some Y is Z", "some X is Z"] }

      it do
        expect(subject).to_not be_valid
        expect(subject.errors).to include("'all X Y' does not contain the verb 'is' or 'are'")
      end
    end
  end

  describe "==" do
    let(:argument) { Syllogism["all A is B", "some C is A", "some C is B"] }

    context "with different statements" do
      let(:other_argument) do
        Syllogism["all A is B", "all C is A", "all C is B"]
      end

      it { expect(argument).to_not eq(other_argument) }
    end

    context "with the same statements" do
      context "using the same variables" do
        let(:other_argument) do
          Syllogism["all A is B", "some C is A", "some C is B"]
        end

        it { expect(argument).to eq(other_argument) }
      end

      context "but using different variables" do
        let(:other_argument) do
          Syllogism["all X is Y", "some Z is X", "some Z is Y"]
        end

        it { expect(argument).to eq(other_argument) }
      end
    end
  end

  describe ".sample" do
    subject { described_class.sample }

    it "results in an argument made of well-formed statements" do
      subject.premises.each do |premise|
        expect(premise).to be_wff
      end
      expect(subject.conclusion).to be_wff
    end
  end

  describe "#valid?" do
    context "when the syllogism is valid" do
      let(:raw_statements) { ["all A is B", "some C is A", "some C is B"] }

      it { expect(subject).to be_valid }
    end

    context "when the syllogism isn't valid" do
      context "because it doesn't contained any statements" do
        let(:raw_statements) { [] }

        it { expect(subject).to_not be_valid }
      end

      context "because it contains malformed statements" do
        let(:raw_statements) { ["all A B", "all C is not A", "some C is B"] }

        it { expect(subject).to_not be_valid }
      end

      context "because it doesn't preserve the truth of the premises" do
        let(:raw_statements) { ["no A is B", "no C is A", "no C is B"] }

        it { expect(subject).to_not be_valid }
      end

      context "because it doesn't meet the definition of a syllogism" do
        context "since it has an odd number count of a term" do
          let(:raw_statements) do
            ["all A is B", "all C is D", "some X is Y"]
          end

          it do
            expect(subject).to_not be_valid
            expect(subject.errors).to include("The term 'A' occured 1 time(s), but should occur exactly twice")
          end
        end

        context "since it doesn't form a chain" do
          let(:raw_statements) do
            ["all A is A", "all B is B", "some C is C"]
          end

          it do
            expect(subject).to_not be_valid
            expect(subject.errors).to include("'all A is A'' should share exactly one term with 'all B is B'")
          end
        end
      end
    end
  end
end
