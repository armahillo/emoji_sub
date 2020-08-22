require 'fakeweb'
require 'development/emoji_scrapr'

RSpec.describe EmojiScrapr do
  subject { EmojiScrapr.new }

  let(:emoji_category_page) { "spec/data/emoji_category.html" }
  let(:emoji_entry_page) { 
    { 
      basic: "spec/data/emoji_entry.html",
      hyphens: "spec/data/emoji_entry_with_hyphens.html",
      multiple_shortcodes: "spec/data/emoji_entry_with_multiple_shortcodes.html",
      multiple_unicodes: "spec/data/emoji_entry_with_multiple_unicodes.html"
    }
  }

  def stub_request(url, response)
    FakeWeb.register_uri(:get, %r|#{EmojiScrapr::BASE_URL}/#{url}|, :body => response)
  end

  describe "#scrape_emoji_page" do    
    before do
      stub_request('fake.html', response)
    end

    context "when the page has a single shortcode and unicode pair" do
      let(:response) { emoji_entry_page[:basic] }

      it "responds with a hash of unicode and shortcodes" do
        result = subject.scrape_emoji_page('/fake.html')
        expect(result).to be_a(Hash)
        expect(result[:unicode]).to match_array(['U+ABCDE1'])
        expect(result[:shortcodes]).to match_array([':shortcode_test_1:'])
      end
    end

    context "when the page has a hyphens in the shortcodes" do
      let(:response) { emoji_entry_page[:hyphens] }

      it "responds with a hash of unicode and shortcode" do
        result = subject.scrape_emoji_page('/fake.html')
        expect(result).to be_a(Hash)
        expect(result[:unicode]).to match_array(['U+ABCDE1'])
        expect(result[:shortcodes]).to match_array([':shortcode-test-1:'])
      end
    end

    context "when the page has multiple shortcodes" do
      let(:response) { emoji_entry_page[:multiple_shortcodes] }

      it "responds with a hash of unicode and shortcodes" do
        result = subject.scrape_emoji_page('/fake.html')
        expect(result).to be_a(Hash)
        expect(result[:unicode]).to match_array(['U+ABCDE1'])
        expect(result[:shortcodes]).to match_array([':shortcode_test_1:', ':shortcode_test_2:'])
      end
    end

    context "when the page has multiple unicodes" do
      let(:response) { emoji_entry_page[:multiple_unicodes] }

      it "responds with a hash of unicode and shortcodes" do
        result = subject.scrape_emoji_page('/fake.html')
        expect(result).to be_a(Hash)
        expect(result[:unicode]).to match_array(['U+ABCDE1', 'U+FEDCB2'])
        expect(result[:shortcodes]).to match_array([':shortcode_test_1:'])
      end
    end
  end

  describe "#scrape_categories_page" do

  end
end