require "mods/ark_mod_list"
require "thor"

module ArkTools
  class Commands < Thor
    desc "ListMods FILE", "Displays a list of active mods from the provided input file"
    def listmods(file)
      ArkModList.new(file).each { |mod| printf "%-25s %s\n", mod.description, mod.id }
    end

    desc "ActiveMods FILE", "Creates an ActiveMods= line suitable for GameUserSettings.ini"
    def activemods(file)
      puts "ActiveMods=#{ArkModList.new(file).csv}"
    end
  end # class Config
end # module ArkTools
