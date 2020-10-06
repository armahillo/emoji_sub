require 'core_extensions/string'

RSpec.describe String do
  before(:each) do
    String.prepend CoreExtensions::EmojiSub::String
  end

  subject { "I :heartbeat: NY" }

  describe "emoji_sub" do
    it { is_expected.to be_respond_to(:emoji_sub) }

    it "replaces the shortcodes with their corresponding unicode" do
      expect(subject.emoji_sub).to eq('I &#x1F493 NY')
    end

    it "allows an override to be provided as an argument" do
      expect(subject.emoji_sub({ heartbeat: "1111" })).to eq('I &#x1111 NY')
    end
  end

  describe "emoji_sub!" do
    it { is_expected.to be_respond_to(:emoji_sub!) }

    it "replaces in-place with the corresponding unicode" do
      subject.emoji_sub!
      expect(subject).to eq('I &#x1F493 NY')
    end

    it "allows an override to be provided as an argument" do
      subject.emoji_sub!({ heartbeat: "1111" })
      expect(subject).to eq('I &#x1111 NY')
    end
  end
end