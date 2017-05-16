require "thor"

module ArkTools
  module Mods
    class Commands < Thor
      desc "Active", "Creates an ActiveMods= line suitable for GameUserSettings.ini"

      option :input, :aliases => :i, required: true

      def activemods
        puts "ActiveMods=#{ArkModList.new(options).csv}"
      end

      desc "Configs", "Generates both ActiveMods and ModInstaller"

      option :input, :aliases => :i, required: true

      def configs
        invoke :activemods
        puts
        invoke :modinstaller
      end

      desc "List", "Displays a list of active mods from the provided input file"

      option :input, :aliases => :i, required: true

      def list
        ArkModList.new(options).each { |mod| printf "%-25s %s\n", mod.description, mod.id }
      end

      desc "ModInstaller", "Creates a [ModInstaller] block suitable for Game.ini"

      option :input, :aliases => :i, required: true

      def modinstaller
        puts "[ModInstaller]"
        ArkModList.new(options).each { |mod| printf "ModIds=%s ; %s\n", mod.id, mod.description }
      end
    end # Class Commands

    class ArkMod
      attr_reader :id, :description

      def initialize(mod, options = {})
        @id          = mod[0]
        @description = mod[1]

        puts "Adding #{@description} (#{@id})" if options[:verbose]
      end

      def to_s
        "#{id}:#{description}"
      end
    end # class ArkMod

    class ArkModList
      attr_reader :mods

      def initialize(options)
        @mods = []

        File.open(options[:input], "r") do |f|
          f.each_line do |line|
            next if line =~ /^\s*[^\d]+/
            if match = line.match(/(\d+)[\s\/#;]+(.*)$/)
              @mods.push ArkMod.new(match.captures, options)
            end
          end
        end
      end

      def each
        @mods.each { |mod| yield mod }
      end

      def csv
        @mods.map(&:id).join(",")
      end
    end
  end # Mods
end
