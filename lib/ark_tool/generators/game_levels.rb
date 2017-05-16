require "thor"
require "pp"

module ArkTools
  module Generate
    def self.level_cmd(cmd, opts)
      gl = Generate::ArkGameLevels.new(opts)

      pp gl if opts[:debug]
      pp gl.configs.game.ini["/script/shootergame.shootergamemode"] if opts[:debug]

      if opts[:verbose]
        max_level = gl.level - 1
        printf "Generating lines for levels 0-%d with a maximum experience of %s at a growth rate of %0.3f\n",
               max_level,
               (max_level ** gl.growth + 1).round.to_s.reverse.gsub(/...(?=.)/, '\&,').reverse,
               gl.growth
      end

      doc = gl.send(cmd)
      doc = gl.make_engrams if opts[:engrams]
      puts "Distributed #{gl.total_engrams} total engrams (rounded up) across #{gl.level} levels" if opts[:verbose]

      if opts[:write]
        doc.save(gl.configs.game.filename)
        puts "Wrote output to #{gl.configs.game.filename}" if opts[:verbose]
      end

      doc.to_ini
    end

    class Commands < Thor
      desc "player", "Generates custom player levels Game.ini line"
      long_desc <<-LONGDESC
Generates "OverrideMaxExperiencePointsPlayer=" and "LevelExperienceRampOverrides=" lines 
suitable to copy/paste into Game.ini

--level     ; Maximum level you wish to obtain (required)
\x5--exp    ; Maximum experience points to award per player (optional)
\x5--growth ; Provide a custom growth rate for level progression (optional)
\x5--engrams [N] ; Create customized engram points lines as well (optional N is the total engrams to award)

*NOTE* This option will *CLEAR* any current custom levels (including Dinos), this is necessary
       in order to create them in the proper order.
      LONGDESC

      option :level, required: true, :type => :numeric, :banner => "MAX_LEVEL"
      option :exp, :type => :numeric, :banner => "MAX_EXPERIENCE"
      option :growth, :type => :numeric, :banner => "GROWTH_RATE"
      option :engrams, :type => :numeric, :banner => "ENGRAM_POINTS", :lazy_default => 5000

      def player
        doc = Generate.level_cmd("player_levels", options)
        puts doc if options[:verbose] && !options[:write]
      end

      desc "dino", "Generates custom dino levels Game.ini line"
      long_desc <<-LONGDESC
Generates "OverrideMaxExperiencePointsDino=" and "LevelExperienceRampOverrides=" lines 
suitable to copy/paste into Game.ini

--level     ; Maximum level you wish to obtain (required)
\x5--exp    ; Maximum experience points to award per player (optional)
\x5--growth ; Provide a custom growth rate for level progression (optional)

*NOTE* In order to include custom Dino levels, you *MUST* first include custom player levels
      LONGDESC

      option :level, required: true, :type => :numeric, :banner => "MAX_LEVEL"
      option :exp, :type => :numeric, :banner => "MAX_EXPERIENCE"
      option :growth, :type => :numeric, :banner => "GROWTH_RATE"

      def dino
        doc = Generate.level_cmd("dino_levels", options)
        puts doc if options[:verbose] && !options[:write]
      end
    end # class Commands

    class ArkGameLevels
      attr_reader :configs, :level, :exp, :growth, :engrams, :total_engrams

      def initialize(options = {})
        opts = options.to_h
        opts.keys.each { |key| opts[key.to_sym] = opts.delete(key) }

        @configs       = ArkTools::GameConfigs.new(opts[:gamedir] || ".")
        @dryrun        = !!opts[:dryrun]
        @force         = !!opts[:force] # for testing
        @level         = opts[:level].to_i
        @exp           = (opts.has_key?(:exp) && opts[:exp].to_i != 0) ?
          opts[:exp].to_i : @level * 10000
        @growth        = (opts.has_key?(:growth) && opts[:growth].to_f != 0) ?
          opts[:growth].to_f : Math.log(@exp, @level)
        @engrams       = (opts.has_key?(:engrams) && opts[:engrams].to_i != 0) ?
          opts[:engrams].to_i : 5000
        @total_engrams = 0
      end

      def calc_exp(level)
        (level ** @growth).round
      end

      def _make_level_overrides
        exp_config = []

        (0..(@level-1)).each { |lvl|
          exp_config << "ExperiencePointsForLevel[#{lvl}]=#{calc_exp lvl}"
        }

        "(#{exp_config.join(",")})"
      end

      def make_engrams
        config = @configs.game.ini
        base   = config["/script/shootergame.shootergamemode"]
        key    = "OverridePlayerLevelEngramPoints"

        base.lines.delete(key) if base.has_option?(key)

        growth = Math.log(@engrams, @level)

        (1..@level).each do |level|
          engrams        = ((level ** growth) / level * growth).ceil
          engrams        = 3 if engrams < 3
          @total_engrams += engrams
          base.lines << IniParse::Lines::Option.new(key, engrams)
        end

        config
      end

      def make_levels(type)
        type           = type.to_s.capitalize
        max_experience = (calc_exp @level - 1) + 1
        config         = @configs.game.ini
        base           = config["/script/shootergame.shootergamemode"]
        key            = "LevelExperienceRampOverrides"

        raise RuntimeError, "type must be either 'Player' or 'Dino'" unless ["Player", "Dino"].include?(type)

        if type == "Dino" && !base.has_option?(key)
          raise RuntimeError, "You must supply Player levels prior to Dino levels" unless @force
        end

        # Clear any existing lines if we're generating player stats
        base.lines.delete(key) if type == "Player" && base.has_option?(key)

        max_exp_string  = "OverrideMaxExperiencePoints#{type}"
        level_overrides = _make_level_overrides

        base.lines.delete(max_exp_string) if base.has_option?(max_exp_string)

        base.lines << IniParse::Lines::Option.new(max_exp_string, max_experience)
        base.lines << IniParse::Lines::Option.new(key, level_overrides)

        config
      end

      def player_levels
        make_levels("Player")
      end

      def dino_levels
        make_levels("Dino")
      end
    end
  end
end
