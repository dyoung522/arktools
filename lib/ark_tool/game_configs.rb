require "iniparse"
require "ostruct"

module ArkTools
  class GameConfigs
    attr_reader :configs, :filenames

    def initialize(gamedir = ".")
      raise RuntimeError, "Directory does not exist #{gamedir}" unless Dir.exists?(gamedir)

      @configs = {}

      %w(Game.ini GameUserSettings.ini).each do |filename|
        key = File.basename(filename, ".ini").downcase.to_sym
        filename = File.expand_path(filename, gamedir)

        @configs[key] = OpenStruct.new(
            :filename => filename,
            :ini => File.exists?(filename) ? IniParse.open(filename) : IniParse.parse("[/script/shootergame.shootergamemode]")
        )
      end
    end

    def game
      @configs[:game]
    end

    def user
      @configs[:gameusersettings]
    end

    def save
      @configs.keys.each do |key|
        filename = @configs[key].filename
        raise RuntimeError, "Unable to write to #{filename}" unless @configs[key].ini.save(filename)
      end
    end

  end # class GameConfigs
end # module ArkTools