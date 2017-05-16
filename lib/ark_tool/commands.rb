require "thor"
require "ark_tool/mods"
require "ark_tool/generators/game_levels"

module ArkTools
  def self.version_string
    "#{ArkTools::PROGRAM_NAME} v#{ArkTools::VERSION} -- Copyright (c)2017 Donovan C. Young"
  end

  class Commands < Thor
    class_option :debug, :type => :boolean, :hidden => true
    class_option :verbose, :aliases => :v, :type => :boolean

    class_option :gamedir,
                 :type   => :string,
                 :banner => "DIR",
                 :desc   => "We'll attempt to write changes to the appropriate INI file in DIR"

    class_option :write,
                 :type => :boolean,
                 :desc   => "Write changes directly to the appropriate INI file, default is to screen"

    class_option :dryrun,
                 :type => :boolean,
                 :desc => "Fake any destructive changes (no not actually do them)"

    desc "version", "Show #{ArkTools::PROGRAM_NAME} version number"

    def version
      puts ArkTools::VERSION
    end

    def help(opts = nil)
      puts "#{ArkTools.version_string}\n\n"
      super opts
    end

    desc "mods", "Commands related to Mod Settings"
    subcommand "mods", Mods::Commands

    desc "levels", "Commands related to custom player/dino levels for Game.ini"
    subcommand "levels", Generate::Commands
  end # class Commands
end # module ArkTools

