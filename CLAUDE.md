# EmojiSub

A small Ruby gem that replaces Slack-style `:shortcode:` emoji with their hex-unicode HTML entity equivalents (e.g. `:heart:` → `&#x2764`), for use in Markdown destined for a static-site generator.

Pending items are tracked locally in @TODO.md

## Architecture

- `lib/emoji_sub.rb` — entry point; sets `GEM_ROOT` / `EMOJI_MAPPING_YAML`, requires the rest.
- `lib/emoji_sub/definitions.rb` — loads and memoizes `data/emoji.yaml` into a shortcode→unicode(s) hash.
- `lib/emoji_sub/emoji_sub.rb` — core logic: scans text for `:shortcode:` patterns, looks each up (merging in any `additional_mappings` passed by the caller, which take precedence), and substitutes matches in place.
- `lib/core_extensions/string.rb` — opt-in monkey patch (`String.prepend CoreExtensions::EmojiSub::String`) adding `.emoji_sub` / `.emoji_sub!` directly on `String`. Not loaded automatically — the consuming app must prepend it.
- `data/emoji.yaml` — the flattened shortcode→unicode(s) mapping (~9000 lines, one shortcode per key, value is an array of one or more hex codepoints since some emoji are codepoint sequences e.g. flags, ZWJ combos).
- `lib/development/` — **excluded from the built gem** (filtered out in `emoji_sub.gemspec` via the `git ls-files` reject on `^lib/development/`). Contains the tooling used to regenerate `data/emoji.yaml`:
  - `emoji_scrapr.rb` (`EmojiScrapr`) — uses `mechanize` to scrape emojipedia.org category/emoji pages into versioned YAML dumps under `lib/development/data/emoji_spec/<version>/`.
  - `emoji_yaml_parsr.rb` (`EmojiYamlParsr`) — flattens a given emoji-spec version's per-category YAMLs (plus `custom_definitions.yml`) into the single `data/emoji.yaml` consumed at runtime. Invoked via `rake data:load_spec`.

## Development

- `bin/setup` — install dependencies.
- `rake spec` — run the RSpec suite (default rake task).
- `bin/console` — interactive REPL with the gem loaded.
- `rake data:load_spec` — regenerate `data/emoji.yaml` from the newest (or a specified) version dir under `lib/development/data/emoji_spec/`.
- `rake scrape:all` — re-scrape emojipedia.org from scratch into a fresh versioned spec dir (long-running, 3-4 hrs; network-dependent).
- CI: Travis, Ruby 2.7.1 (`.travis.yml`). Gemspec declares `required_ruby_version >= 2.3.0`.

### Testing conventions

RSpec, one spec file per lib file, in `spec/`. `spec/data/*.html` are fixture pages used by `emoji_scrapr_spec.rb` to test the scraper against saved emojipedia HTML without hitting the network.

## Versioning / releases

Pre-1.0, so semver is treated loosely (breaking API changes are acceptable without a major bump). `CHANGELOG.md` is kept up to date per release. To release: bump `lib/emoji_sub/version.rb`, then `bundle exec rake release` (tags, pushes, and publishes to rubygems.org) — do not run this without being asked, per general git/release caution.
