module ArkTools
  module Generate
    class ArkGameLevels
      attr_reader :max_level, :max_exp, :growth_rate

      def initialize(max_level, options = {})
        @max_level   = max_level
        @max_exp     = options.has_key?(:max_exp) ? options[:max_exp].to_i : max_level * 10000
        @growth_rate = options.has_key?(:growth_rate) ? options[:growth_rate].to_i : Math.log(@max_exp, @max_level)
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
