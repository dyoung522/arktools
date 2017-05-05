require "mods/ark_mod_list"
require "thor"

module ArkTools
  class Commands < Thor
    desc "ListMods FILE", "Creates/Updates the 'ActiveMods' line in GameUserSettings.ini"
    def listmods(file)
      ArkModList.new(file).each { |mod| printf "%-25s %s\n", mod.description, mod.id }
    end
  end # class Config
end # module ArkTools
