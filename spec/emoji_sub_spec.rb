RSpec.describe EmojiSub do
  it "has a version number" do
    expect(EmojiSub::VERSION).not_to be nil
  end

  describe "emoji_sub" do
    subject { EmojiSub.emoji_sub(text) }

    context "with one or more different emoji" do
      let(:text) { 'This is testing text :100:. It is great :slightly_smiling_face:.' }

      it "replaces the shortcodes with their corresponding unicode" do
        expect(subject).to eq('This is testing text &#x1F4AF. It is great &#x1F642.')
      end
    end

    context "with one or more repeated emoji" do
      let(:text) { 'This is testing text :100: :100: :100:. It is great :slightly_smiling_face:.' }

      it "replaces the shortcodes with their corresponding unicode" do
        expect(subject).to eq('This is testing text &#x1F4AF &#x1F4AF &#x1F4AF. It is great &#x1F642.')
      end
    end

    context "with shortcodes that aren't recognized" do
      let(:text) { 'This is testing text :100: :a_nonexistent_emoji:. It is great :slightly_smiling_face:.' }

      it "leaves the shortcodes intact" do
        expect(subject).to eq('This is testing text &#x1F4AF :a_nonexistent_emoji:. It is great &#x1F642.')
      end
    end
  end
end
