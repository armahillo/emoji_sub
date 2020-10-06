# Changelog

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

N.B. until it hits 1.0 do not make any expectations about API consistency! (SemVer says it's OK so nyah!)

## [0.3.0] - 2020-10-05

- Adds monkey-patch to allow String to call `:emoji_sub` directly

## [0.2.2] - 2020-08-22

- Some reorganization of files, and cleanup
- Fixes the YAML data so that it doesn't use categories


## [0.2.1] - 2020-08-22

Emoji are now categorized, and flattened during `emoji_sub`. Some additional parsing logic exists to take generated YML from emoji spec (versioned!) and convert it into the serialized YML used by the script. 

### Added

- `EmojiYamlParsr` (available for development use only)
- Versioned Emoji YMLs


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

[0.3.0]: https://github.com/armahillo/emoji_sub/compare/v0.2.2...v0.3.0
[0.2.2]: https://github.com/armahillo/emoji_sub/compare/v0.2.1...v0.2.2
[0.2.1]: https://github.com/armahillo/emoji_sub/compare/v0.2.0...v0.2.1
[0.2.0]: https://github.com/armahillo/emoji_sub/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/armahillo/emoji_sub/releases/tag/v0.1.0