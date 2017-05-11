require "thor"

module ArkTools
  module Generate
    class Commands < Thor
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
                                           growth_rate: options[:growth].to_f,
                                           verbose:     options[:verbose]
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
                                           growth_rate: options[:growth].to_f,
                                           verbose:     options[:verbose]
                                         }).dino_levels
      end
    end # class Commands

    class ArkGameLevels
      attr_reader :max_level, :max_exp, :growth_rate

      def initialize(max_level, options = {})
        @max_level   = max_level.to_i
        @max_exp     = (options.has_key?(:max_exp) && options[:max_exp] != 0) ?
          options[:max_exp].to_i : @max_level * 10000
        @growth_rate = (options.has_key?(:growth_rate) && options[:growth_rate] != 0) ?
          options[:growth_rate].to_f : Math.log(@max_exp, @max_level)

        if options[:verbose]
          max_level = @max_level - 1
          printf "Generating lines for levels 0-%d with a maximum experience of %s at a growth rate of %0.3f\n",
                 max_level,
                 (max_level ** @growth_rate + 1).round.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse,
                 @growth_rate
        end
      end

      def calc_exp(level)
        (level ** @growth_rate).round
      end

      def _make_level_overrides
        exp_config = []

        (0..(@max_level-1)).each { |lvl|
          exp_config << "ExperiencePointsForLevel[#{lvl}]=#{calc_exp lvl}"
        }

        "LevelExperienceRampOverrides=(#{exp_config.join(",")})"
      end

      def make_levels(type)
        type           = type.to_s.capitalize
        max_experience = (calc_exp @max_level - 1) + 1

        raise RuntimeError, "type must be either 'Player' or 'Dino'" unless ["Player", "Dino"].include?(type)

        "OverrideMaxExperiencePoints#{type}=#{max_experience}\n" +
          _make_level_overrides
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
