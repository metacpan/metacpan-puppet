# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v3.1.0](https://github.com/voxpupuli/puppet-logrotate/tree/v3.1.0) (2017-11-13)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v3.0.1...v3.1.0)

**Implemented enhancements:**

- Allow dateyesterday at the global level [\#83](https://github.com/voxpupuli/puppet-logrotate/pull/83) ([cliff-wakefield](https://github.com/cliff-wakefield))

**Fixed bugs:**

- Fix "Puppet Unknown variable: 'default\_su\_group'" [\#82](https://github.com/voxpupuli/puppet-logrotate/pull/82) ([mookie-](https://github.com/mookie-))

**Closed issues:**

- Config is not a string but a hash [\#77](https://github.com/voxpupuli/puppet-logrotate/issues/77)
- Support Ubuntu 16.04 [\#59](https://github.com/voxpupuli/puppet-logrotate/issues/59)
- Does this module attempt to apply the defaults for the GNU distribution? [\#48](https://github.com/voxpupuli/puppet-logrotate/issues/48)

## [v3.0.1](https://github.com/voxpupuli/puppet-logrotate/tree/v3.0.1) (2017-10-14)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v3.0.0...v3.0.1)

**Fixed bugs:**

- wrong datatype for $config, s/String/Hash [\#78](https://github.com/voxpupuli/puppet-logrotate/pull/78) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- release 3.0.1 [\#79](https://github.com/voxpupuli/puppet-logrotate/pull/79) ([bastelfreak](https://github.com/bastelfreak))

## [v3.0.0](https://github.com/voxpupuli/puppet-logrotate/tree/v3.0.0) (2017-10-10)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v2.0.0...v3.0.0)

**Closed issues:**

- Remove old CHANGELOG or merge with CHANGELOG.md [\#69](https://github.com/voxpupuli/puppet-logrotate/issues/69)

**Merged pull requests:**

- release 3.0.0 [\#75](https://github.com/voxpupuli/puppet-logrotate/pull/75) ([bastelfreak](https://github.com/bastelfreak))
- Fix changelog [\#73](https://github.com/voxpupuli/puppet-logrotate/pull/73) ([alexjfisher](https://github.com/alexjfisher))
- Added support for dateyesterday within logrotate::rule [\#71](https://github.com/voxpupuli/puppet-logrotate/pull/71) ([cliff-wakefield](https://github.com/cliff-wakefield))
- BREAKING: Introduce Puppet 4 datatypes and drop Puppet 3 support [\#68](https://github.com/voxpupuli/puppet-logrotate/pull/68) ([mmerfort](https://github.com/mmerfort))
- release 2.0.0 [\#64](https://github.com/voxpupuli/puppet-logrotate/pull/64) ([bastelfreak](https://github.com/bastelfreak))

## [v2.0.0](https://github.com/voxpupuli/puppet-logrotate/tree/v2.0.0) (2017-05-25)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v1.4.0...v2.0.0)

**Closed issues:**

- Logrotate rule ERB template should not take variables from the scope object [\#37](https://github.com/voxpupuli/puppet-logrotate/issues/37)
- Ubuntu Xenial 16.04 compaibility [\#34](https://github.com/voxpupuli/puppet-logrotate/issues/34)
- string 'undef' now treated as undef [\#26](https://github.com/voxpupuli/puppet-logrotate/issues/26)
- Allow adjustment of OS-specific defaults [\#9](https://github.com/voxpupuli/puppet-logrotate/issues/9)

**Merged pull requests:**

- Fix typo [\#58](https://github.com/voxpupuli/puppet-logrotate/pull/58) ([gabe-sky](https://github.com/gabe-sky))
- Adding support for maxsize also in main config [\#57](https://github.com/voxpupuli/puppet-logrotate/pull/57) ([seefood](https://github.com/seefood))
- Fix rubocop checks [\#53](https://github.com/voxpupuli/puppet-logrotate/pull/53) ([coreone](https://github.com/coreone))
- Another attempt at FreeBSD support [\#52](https://github.com/voxpupuli/puppet-logrotate/pull/52) ([coreone](https://github.com/coreone))
- Fixes \#34 - Ubuntu Xenial and up support [\#43](https://github.com/voxpupuli/puppet-logrotate/pull/43) ([edestecd](https://github.com/edestecd))
- Fixes \#37 - Logrotate rule ERB template should not take variables from the scope object [\#38](https://github.com/voxpupuli/puppet-logrotate/pull/38) ([imriz](https://github.com/imriz))
- Fix puppet-lint issues and bad style [\#32](https://github.com/voxpupuli/puppet-logrotate/pull/32) ([baurmatt](https://github.com/baurmatt))
- Add gentoo support [\#27](https://github.com/voxpupuli/puppet-logrotate/pull/27) ([baurmatt](https://github.com/baurmatt))

## [v1.4.0](https://github.com/voxpupuli/puppet-logrotate/tree/v1.4.0) (2016-05-30)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v1.3.0...v1.4.0)

**Closed issues:**

- Optional config settings are no longer optional?!? [\#29](https://github.com/voxpupuli/puppet-logrotate/issues/29)
- wtmp and btmp are different when using the future parser [\#13](https://github.com/voxpupuli/puppet-logrotate/issues/13)

**Merged pull requests:**

- Changed default string "undef" to "UNDEFINED" to work around this bug… [\#28](https://github.com/voxpupuli/puppet-logrotate/pull/28) ([durist](https://github.com/durist))
- Fix typo in README.md [\#25](https://github.com/voxpupuli/puppet-logrotate/pull/25) ([siebrand](https://github.com/siebrand))
- Added ability to override default btmp and/or wtmp [\#21](https://github.com/voxpupuli/puppet-logrotate/pull/21) ([ncsutmf](https://github.com/ncsutmf))
- remove special whitespace character [\#20](https://github.com/voxpupuli/puppet-logrotate/pull/20) ([jfroche](https://github.com/jfroche))
- Update Gemfile for Rake/Ruby version dependencies [\#19](https://github.com/voxpupuli/puppet-logrotate/pull/19) ([ncsutmf](https://github.com/ncsutmf))
- add official puppet 4 support [\#17](https://github.com/voxpupuli/puppet-logrotate/pull/17) ([mmckinst](https://github.com/mmckinst))
- Feature/fix wtmp btmp [\#16](https://github.com/voxpupuli/puppet-logrotate/pull/16) ([robinbowes](https://github.com/robinbowes))

## [v1.3.0](https://github.com/voxpupuli/puppet-logrotate/tree/v1.3.0) (2015-11-05)

[Full Changelog](https://github.com/voxpupuli/puppet-logrotate/compare/v1.2.8...v1.3.0)

**Closed issues:**

- The logrotate package should be 'present' by default, or at least tunable [\#11](https://github.com/voxpupuli/puppet-logrotate/issues/11)

**Merged pull requests:**

- Set default package ensure value to 'installed' [\#12](https://github.com/voxpupuli/puppet-logrotate/pull/12) ([natemccurdy](https://github.com/natemccurdy))
- Add support for maxsize directive [\#10](https://github.com/voxpupuli/puppet-logrotate/pull/10) ([zeromind](https://github.com/zeromind))

## v1.2.8 (2015-09-14)

- Fix hidden unicode character (#8)
- Allow config to be passed in as an hash (#6)
- Fix dependency issue (#7)
- refactor main class (mostly to facilitate #7)
- update test environment to use puppet 4
- switch stdlib fixture to https source

## v1.2.7 (2015-05-06)

- Metadata-only release (just bumped version)

## v1.2.6 (2015-05-06)

- Fix test failures on future parser

## v1.2.5 (2015-05-06)

- Switch some validation code to use validate_re

## v1.2.4 (2015-05-06)

- Add puppet-lint exclusions

## v1.2.3 (2015-05-06)

- More work on testing
- fix warning when running puppet module list caused by "-" instead of "/" in dependencies in metadata

## v1.2.3 (2015-05-06)

- removed (pushed without CHANGELOG update

## v1.2.1 (2015-05-06)

- Update tests, Rakefile, etc.

## v1.2.0 (2015-03-25)

- First release to puppetforge


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*