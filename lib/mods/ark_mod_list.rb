require "mods/ark_mod"

module ArkTools
  class ArkModList
    attr_reader :mods
    
    def initialize(file)
      @mods = []

      File.open(file, "r") do |f|
        f.each_line do |line|
          next if line =~ /^\s*[^\d]+/
          if match = line.match(/(\d+)[\s\/#;]+(.*)$/)
            @mods.push ArkMod.new(match.captures)
          end
        end
      end
    end

    def each
      @mods.each { |mod| yield mod }
    end
  end
end
