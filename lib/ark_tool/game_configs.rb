require "inifile"

module ArkTools
  class GameConfigs
    def initialize(gamedir = ".")
      raise RuntimeError, "Directory does not exist #{gamedir}" unless Dir.exists?(gamedir)

      @configs = {
          game: IniFile.new(filename: File.expand_path("Game.ini", gamedir), encoding: "UTF-8"),
          user: IniFile.new(filename: File.expand_path("GameUserSettings.ini", gamedir), encoding: "UTF-8"),
      }
    end

    def game
      @configs[:game]
    end

    def user
      @configs[:user]
    end

    def write
      @configs.keys.each do |key|
        raise RuntimeError, "Unable to write to #{@configs[key].filename}" unless @configs[key].write
      end
    end

  end # class GameConfigs
end # module ArkTools