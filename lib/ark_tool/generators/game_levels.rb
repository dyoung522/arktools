require "thor"
require "pp"

module ArkTools
  module Generate
    def self.level_cmd(cmd, opts)
      gl = Generate::ArkGameLevels.new(opts)

      pp gl if opts[:debug]

      if opts[:verbose]
        max_level = gl.level - 1
        printf "Generating lines for levels 0-%d with a maximum experience of %s at a growth rate of %0.3f\n",
               max_level,
               (max_level ** gl.growth + 1).round.to_s.reverse.gsub(/...(?=.)/, '\&,').reverse,
               gl.growth
        puts "Writing output to #{gl.configs.game.filename}" if opts[:write]
      end

      gl.send(cmd)
    end

    class Commands < Thor
      desc "player", "Generates custom player levels Game.ini line"
      long_desc <<-LONGDESC
Generates "OverrideMaxExperiencePointsPlayer=" and "LevelExperienceRampOverrides=" lines 
suitable to copy/paste into Game.ini

--level     ; Maximum level you wish to obtain (required)
\x5--exp    ; Maximum experience points to award per player (optional)
\x5--growth ; Provide a custom growth rate for level progression (optional)

      LONGDESC

      option :level, required: true, :type => :numeric, :banner => "MAX_LEVEL"
      option :exp, :type => :numeric, :banner => "MAX_EXPERIENCE"
      option :growth, :type => :numeric, :banner => "GROWTH_RATE"

      def player
        Generate.level_cmd("player_levels", options)
      end

      desc "dino", "Generates custom dino levels Game.ini line"
      long_desc <<-LONGDESC
Generates "OverrideMaxExperiencePointsDino=" and "LevelExperienceRampOverrides=" lines 
suitable to copy/paste into Game.ini

--level     ; Maximum level you wish to obtain (required)
\x5--exp    ; Maximum experience points to award per player (optional)
\x5--growth ; Provide a custom growth rate for level progression (optional)

*NOTE* In order to include custom Dino levels, you *MUST* also include custom player levels first
      LONGDESC

      option :level, required: true, :type => :numeric, :banner => "MAX_LEVEL"
      option :exp, :type => :numeric, :banner => "MAX_EXPERIENCE"
      option :growth, :type => :numeric, :banner => "GROWTH_RATE"

      def dino
        Generate.level_cmd("dino_levels", options)
      end
    end # class Commands

    class ArkGameLevels
      attr_reader :configs, :level, :exp, :growth

      def initialize(options = {})
        @configs = ArkTools::GameConfigs.new(options[:gamedir] || ".")
        @level = options[:level].to_i
        @exp = (options.has_key?(:exp) && options[:exp].to_i != 0) ?
            options[:exp].to_i : @level * 10000
        @growth = (options.has_key?(:growth) && options[:growth].to_f != 0) ?
            options[:growth].to_f : Math.log(@exp, @level)
        @dryrun = !!options[:dryrun]
        @write = !!options[:write]
      end

      def calc_exp(level)
        (level ** @growth).round
      end

      def _make_level_overrides
        exp_config = []

        (0..(@level-1)).each {|lvl|
          exp_config << "ExperiencePointsForLevel[#{lvl}]=#{calc_exp lvl}"
        }

        "(#{exp_config.join(",")})"
      end

      def make_levels(type)
        type = type.to_s.capitalize
        max_experience = (calc_exp @level - 1) + 1
        config = @configs.game

        raise RuntimeError, "type must be either 'Player' or 'Dino'" unless ["Player", "Dino"].include?(type)

        max_exp_string = "OverrideMaxExperiencePoints#{type}"
        level_overrides = _make_level_overrides

        config["/script/shootergame.shootergamemode"][max_exp_string] = max_experience
        config["/script/shootergame.shootergamemode"]["LevelExperienceRampOverrides"] = level_overrides

        if @write
          config.write unless @dryrun
        end

        config
      end

      def player_levels
        make_levels "Player"
      end

      def dino_levels
        make_levels "Dino"
      end
    end
  end
end
