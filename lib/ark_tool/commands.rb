require "thor"

module ArkTools
  class Levels < Thor
    desc "player", "Generates custom player levels Game.ini line"
    long_desc <<-LONGDESC
Generates "OverrideMaxExperiencePointsPlayer=" and "LevelExperienceRampOverrides=" lines 
suitable to copy/paste into Game.ini

--level     ; Maximum level you wish to obtain (required)
\x5--exp    ; Maximum experience points to award per player (optional)
\x5--growth ; Provide a custom growth_rate for level progression (optional)

    LONGDESC

    option :level, required: true, :type => :numeric, :banner => "MAX_LEVEL"
    option :exp, :type => :numeric, :banner => "MAX_EXPERIENCE"
    option :growth, :type => :numeric, :banner => "GROWTH_RATE"

    def player
      puts Generate::ArkGameLevels.new(options[:level].to_i,
                                       {
                                         max_exp:     options[:exp].to_i,
                                         growth_rate: options[:growth].to_f
                                       }).player_levels
    end

    desc "dino", "Generates custom dino levels Game.ini line"
    long_desc <<-LONGDESC
Generates "OverrideMaxExperiencePointsDino=" and "LevelExperienceRampOverrides=" lines 
suitable to copy/paste into Game.ini

--level     ; Maximum level you wish to obtain (required)
\x5--exp    ; Maximum experience points to award per player (optional)
\x5--growth ; Provide a custom growth_rate for level progression (optional)

*NOTE* In order to include custom Dino levels, you *MUST* also include custom player levels first
    LONGDESC

    option :level, required: true, :type => :numeric, :banner => "MAX_LEVEL"
    option :exp, :type => :numeric, :banner => "MAX_EXPERIENCE"
    option :growth, :type => :numeric, :banner => "GROWTH_RATE"

    def dino
      puts Generate::ArkGameLevels.new(options[:level].to_i,
                                       {
                                         max_exp:     options[:exp].to_i,
                                         growth_rate: options[:growth].to_f
                                       }).dino_levels
    end
  end # class Generate

  class Mods < Thor
    desc "Active", "Creates an ActiveMods= line suitable for GameUserSettings.ini"

    option :file, required: true

    def activemods(file = options[:file])
      puts "ActiveMods=#{ArkModList.new(file).csv}"
    end

    desc "Configs", "Generates both ActiveMods and ModInstaller"

    option :file, required: true

    def configs
      invoke :activemods
      puts
      invoke :modinstaller
    end

    desc "List", "Displays a list of active mods from the provided input file"

    option :file, required: true

    def list
      ArkModList.new(options[:file]).each { |mod| printf "%-25s %s\n", mod.description, mod.id }
    end

    desc "ModInstaller", "Creates a [ModInstaller] block suitable for Game.ini"

    option :file, required: true

    def modinstaller(file = options[:file])
      puts "[ModInstaller]"
      ArkModList.new(file).each { |mod| printf "ModIds=%s ; %s\n", mod.id, mod.description }
    end
  end # class Mods

  class Commands < Thor
    desc "mods", "Commands related to Mod Settings"
    subcommand "mods", Mods

    desc "levels", "Commands related to custom player/dino levels for Game.ini"
    subcommand "levels", Levels
  end # class Commands
end # module ArkTools

