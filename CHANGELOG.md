# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2020-08-22

Last night I wrote a script to scrape down all the emoji definitions w/ shortcodes from emojipedia. I refined it, added specs, and created a rake task for it.

### Added

- `EmojiScrapr` (available for development use only)
- specs

## [0.1.0] - 2020-08-21

This is the first release. The goal is to get a method that works for substitution of
emoji HTML entities (hex-unicode) for slack shortcut format (:this_kind:)

### Added

- Creates initial module and :emoji_sub method
- data/emoji.yml file, 
- Specs covering basic funcitonality

[0.2.0]: https://github.com/armahillo/emoji_sub/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/armahillo/emoji_sub/releases/tag/v0.1.0