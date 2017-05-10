# ArkTools

Welcome to ArkTools!

Currently this provides a command line tool named `arktool` which will create customized Game.ini and GameUserSettings.ini lines for you.

## Installation

Install the gem from rubygems as you normally would. Once installed, you'll have access to the command line tool named `arktool`.

    $ gem install ArkConfig

## Usage

`arktool help` should get you started. Subcommands also have their own help, so `arktool mods help` will give you information about the `mods` subcommand.

## Commands

### Mods

These commands take an input file (via --file) in the following format:

    MODID Description

Each mod should be separated on it's own line and the order of the lines determine the load order (top to bottom)

e.g.  

    776464863 Ragnarok
    813220452 Ragnarok Lore

### Levels

These commands will create customized level lists for your Game.ini. Please see `arktools levels help` for additional information.

    --level  : the Maximum level for your server (required)
    --exp    : The total experience to obtain max level (optional)
    --growth : a customized logarithmic "growth rate" (very optional -- if you don't know what this means, you probably don't need it)

## Future Plans

- Web based interface (for the non-ruby world)
- Other configuration options / commands as requested by the community

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/dyoung522/arktools).

