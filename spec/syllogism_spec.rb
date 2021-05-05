RSpec.describe Syllogism do
  it "has a version number" do
    expect(Syllogism::VERSION).not_to be nil
  end

  describe "#new" do
    subject { described_class.new(*statements) }

    context "with an invalid statement" do
      let(:statements) { ["all X Y", "some Y is Z", "some X is Z"] }

      it do
        expect(subject).to_not be_valid
        expect(subject.errors).to include("'all X Y' does not contain the verb 'is'")
      end
    end
  end
end
