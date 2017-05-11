require "thor"
require "ark_tool/mods"
require "ark_tool/generators/game_levels"

module ArkTools
  class Commands < Thor
    class_option :verbose, :aliases => :v, :type => :boolean

    desc "mods", "Commands related to Mod Settings"
    subcommand "mods", Mods::Commands

    desc "levels", "Commands related to custom player/dino levels for Game.ini"
    subcommand "levels", Generate::Commands
  end # class Commands
end # module ArkTools

