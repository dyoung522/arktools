require "mods/ark_mod_list"
require "thor"

module ArkTools
  class Commands < Thor
    desc "ActiveMods FILE", "Creates an ActiveMods= line suitable for GameUserSettings.ini"
    def activemods(file)
      puts "ActiveMods=#{ArkModList.new(file).csv}"
    end

    desc "Configs FILE", "Generates both ActiveMods and ModInstaller"
    def configs(file)
      invoke :activemods, file
      puts
      invoke :modinstaller, file
    end

    desc "ListMods FILE", "Displays a list of active mods from the provided input file"
    def listmods(file)
      ArkModList.new(file).each { |mod| printf "%-25s %s\n", mod.description, mod.id }
    end

    desc "ModInstaller FILE", "Creates a [ModInstaller] block suitable for Game.ini"
    def modinstaller(file)
      puts "[ModInstaller]"
      ArkModList.new(file).each { |mod| printf "ModIds=%s ; %s\n", mod.id, mod.description }
    end
  end # class Config
end # module ArkTools
