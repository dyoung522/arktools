module ArkTools
  module Generate
    class GameLevels
      def initialize(max_level, options = {})
        @max_level   = max_level
        @max_exp     = options[:max_exp] == 0 ? max_level * 10000 : options[:max_exp]
        @growth_rate = options[:growth_rate] == 0 ? Math.log(@max_exp, @max_level) : options[:growth_rate]
      end

      def _calc_exp(level)
        (level ** @growth_rate).round
      end

      def _make_level_overrides
        exp_config = []

        (0..@max_level).each { |lvl|
          exp_config << "ExperiencePointsForLevel[#{lvl}]=#{_calc_exp lvl}"
        }

        "LevelExperienceRampOverrides=(#{exp_config.join(",")})"
      end

      def _make_levels(type)
        type           = type.to_s.capitalize
        max_experience = _calc_exp@max_level

        raise RuntimeError, "type must be either 'Player' or 'Dino'" unless ["Player", "Dino"].include?(type)

        "OverrideMaxExperiencePoints#{type}=#{max_experience}\n" +
          _make_level_overrides
      end

      def player_levels
        _make_levels"Player"
      end

      def dino_levels
        _make_levels"Dino"
      end
    end
  end
end
