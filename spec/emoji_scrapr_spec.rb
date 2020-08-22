require 'fakeweb'
require 'development/emoji_scrapr'

FakeWeb.allow_net_connect = false

RSpec.describe EmojiScrapr do
  subject(:emoji_scrapr) { EmojiScrapr.new }

  let(:emoji_root_page) { "spec/data/emoji_root_page.html" }
  let(:emoji_category_page) { "spec/data/emoji_category_page.html" }
  let(:emoji_entry_page) { 
    { 
      basic: "spec/data/emoji_entry.html",
      hyphens: "spec/data/emoji_entry_with_hyphens.html",
      multiple_shortcodes: "spec/data/emoji_entry_with_multiple_shortcodes.html",
      multiple_unicodes: "spec/data/emoji_entry_with_multiple_unicodes.html"
    }
  }

  let(:emoji_page_response) { 
    {
      unicode: ['U+ABCDE1'],
      shortcodes: [':shortcode_test_1:']
    }
  }

  after(:each) do
    FakeWeb::Registry.instance.clean_registry
  end

  def stub_request(url, response)
    FakeWeb.register_uri(:get, %r|#{EmojiScrapr::BASE_URL}/#{url}|, body: response, content_type: "application/xml")
  end

  describe "#scrape_emoji_page" do    
    subject { emoji_scrapr.scrape_emoji_page('/fake.html') }

    before do
      stub_request('fake.html', response)
    end

    context "when the page has a single shortcode and unicode pair" do
      let(:response) { emoji_entry_page[:basic] }

      it "responds with a hash of unicode and shortcodes" do
        expect(subject[:unicode]).to match_array(['U+ABCDE1'])
        expect(subject[:shortcodes]).to match_array([':shortcode_test_1:'])
      end
    end

    context "when the page has a hyphens in the shortcodes" do
      let(:response) { emoji_entry_page[:hyphens] }

      it "responds with a hash of unicode and shortcode" do
        expect(subject[:unicode]).to match_array(['U+ABCDE1'])
        expect(subject[:shortcodes]).to match_array([':shortcode-test-1:'])
      end
    end

    context "when the page has multiple shortcodes" do
      let(:response) { emoji_entry_page[:multiple_shortcodes] }

      it "responds with a hash of unicode and shortcodes" do
        expect(subject[:unicode]).to match_array(['U+ABCDE1'])
        expect(subject[:shortcodes]).to match_array([':shortcode_test_1:', ':shortcode_test_2:'])
      end
    end

    context "when the page has multiple unicodes" do
      let(:response) { emoji_entry_page[:multiple_unicodes] }

      it "responds with a hash of unicode and shortcodes" do
        expect(subject[:unicode]).to match_array(['U+ABCDE1', 'U+FEDCB2'])
        expect(subject[:shortcodes]).to match_array([':shortcode_test_1:'])
      end
    end
  end

  describe "#scrape_categories_page" do
    subject { emoji_scrapr.scrape_categories_page }

    before do
      stub_request('', response)
    end

    context "when querying the homepage" do
      let(:response) { emoji_root_page }

      it "retrieves a hash of the categories and sections" do
        expect(subject).to eq({ 'Section 1' => '/test-url-1/', 'Section 2' => '/test-url-2/', 'Section 3' => '/test-url-3/' })

      end
    end
  end

  describe "#scrape_category_page" do
    subject { emoji_scrapr.scrape_category_page('/category.html') }

    before do
      stub_request('category.html', emoji_category_page)
    end

    it "returns a hash of the emoji on the page, paired with their URLs" do
      expect(subject).to be_a(Hash)
      expect(subject.values).to match_array([{ url: '/emoji-slug-1/' }, { url: '/emoji-slug-2/' }, { url: '/emoji-slug-3/' }])
      expect(subject.keys).to match_array(['😃 Emoji Description 1', '😄 Emoji Description 2', '😁 Emoji Description 3'])
    end
  end

  describe "scrape_all_emoji_in_category" do
    subject { emoji_scrapr.scrape_all_emoji_in_category(category, 0) }

    let(:category) { 
      { 
        "\U0001F600 Grinning Face": { url: 'https://emojipedia.org/emoji-slug-1/' },
        "\U0001F603 Grinning Face with Big Eyes": { url: 'https://emojipedia.org/emoji-slug-2/' }
      }
    }

    before do
      allow(emoji_scrapr).to receive(:scrape_emoji_page).with("https://emojipedia.org/emoji-slug-1/").and_return(emoji_page_response)
      allow(emoji_scrapr).to receive(:scrape_emoji_page).with("https://emojipedia.org/emoji-slug-2/").and_return(emoji_page_response)
    end

    it "returns a hash of the emoji on the page, paired with their URLs" do
      expect(subject).to be_a(Hash)
      expect(subject.values.first).to eq(emoji_page_response.merge(category.values.first))
      expect(subject.values.last).to eq(emoji_page_response.merge(category.values.last))
    end
  end
end