require "optparse"
require "config"

module ArkTool
  class OptParse
    attr_reader :parser, :version

    def initialize(opts)
      program_path  = ArkTool::PROGRAM
      program_files = []

      %W(~/.#{program_path} ./.#{program_path} ./#{program_path}.conf ./#{program_path}.rc).each do |path|
        program_files.push File.expand_path(path)
      end

      Config.setup do |config|
        config.const_name = "Options"
        config.use_env    = true
      end

      Config.load_and_set_settings opts[:testing] ? String.new : program_files

      default_options(Options, opts[:defaults]) if opts[:defaults]

      Options.verbose = Options.verbose ? 1 : 0 unless Options.verbose.is_a?(Numeric)

      @parser  ||= common_options opts[:testing]
      @version ||= sprintf "%s v%s (%s v%s)\n",
                           opts[:name] || ArkTool::PROGRAM, opts[:version] || ArkTool::VERSION,
                           "ArkTool", ArkTool::VERSION

      Options.debug = Options.verbose >= 5
    end


    def self.default_options
      {
        basedir:  "src/js",
        changed:  false,
        commands: Config::Options.new,
        jest:     true,
        mocha:    true,
        verbose:  0
      }
    end

    #
    # Return a structure describing the Options.
    #
    def self.parse(args, unit_testing=false)
      # The Options specified on the command line will be collected in *Options*.
      # We set default values here.
      opt_parse = ArkTool::OptParse.new({ name:     PROGRAM,
                                          version:  VERSION,
                                          defaults: default_options,
                                          testing:  unit_testing })

      opt_parse.default_options(Options.commands, {
        diff:       "git diff --name-only develop src/js | egrep \".js$\"",
        jest:       "$(npm bin)/jest",
        jest_full:  "npm run test:jest",
        mocha:      "$(npm bin)/mocha --require src/js/util/test-dom.js --compilers js:babel-core/register",
        mocha_full: "npm run test:mocha"
      })

      parser = opt_parse.parser

      parser.banner = "Usage: #{ArkTool::PROGRAM} [COMMAND] [OPTIONS]"
      parser.banner += "\n\nWhere [PATTERN] is any full or partial filename."
      parser.banner += " All tests matching this filename pattern will be run."

      parser.separator ""
      parser.separator "[OPTIONS]"

      parser.separator ""
      parser.separator "Specific Options:"

      # Base directory
      parser.on("-b", "--basedir DIR", "Specify the base directory to search for tests (DEFAULT: '#{Options.basedir}')") do |dir|
        Options.basedir = dir
      end

      # Changed switch
      parser.on("-c", "--changed", "Run specs for any files that have recently been modified") do
        Options.changed = true
      end

      parser.separator ""
      parser.separator "Test Runners:"

      parser.on("-j", "--[no-]jest", "Only/Don't run Jest tests") do |jest|
        Options.jest = true; Options.mocha = false
        (Options.jest = false; Options.mocha = true) unless jest
      end

      parser.on("-m", "--[no-]mocha", "Only/Don't run Mocha tests") do |mocha|
        Options.jest = false; Options.mocha = true
        (Options.jest = true; Options.mocha = false) unless mocha
      end

      parser.separator ""
      parser.separator "Test Commands:"

      parser.on("--diff-cmd CMD", "Overwrite git diff command: '#{Options.commands.diff}'") do |cmd|
        Options.commands.diff = cmd
      end

      parser.on("--jest-cmd CMD", "Overwrite Jest command: '#{Options.commands.jest}'") do |cmd|
        Options.commands.jest = cmd
      end

      parser.on("--jest-full-cmd CMD", "Overwrite Jest full-suite command: '#{Options.commands.jest_full}'") do |cmd|
        Options.commands.jest_full = cmd
      end

      parser.on("--mocha-cmd CMD", "Overwrite Mocha command: '#{Options.commands.mocha}'") do |cmd|
        Options.commands.mocha = cmd
      end

      parser.on("--mocha-full-cmd CMD", "Overwrite Mocha command: '#{Options.commands.mocha_full}'") do |cmd|
        Options.commands.mocha_full = cmd
      end

      parser.separator ""
      parser.separator "Common Options:"

      parser.parse!(args)

      return Options
    end

    def common_options(unit_testing = false)
      OptionParser.new do |opts|
        opts.on_tail("-h", "--help", "Show this message") do
          unless unit_testing
            puts version + "\n"
            puts opts
            exit
          end
        end

        # Config file
        opts.on_tail("-c", "--config FILE", "Specify an alternate configuration file") do |file|
          Options.add_source! file
          Options.reload!
        end

        # dry-run switch
        opts.on_tail("--dry-run", "Don't actually run commands") do
          Options.dryrun = true
        end

        # Verbose switch
        opts.on_tail("-q", "--quiet", "Run quietly") do
          Options.verbose = 0
        end

        opts.on_tail("-v", "--verbose", "Run verbosely (may be specified more than once)") do
          Options.verbose += 1
        end

        opts.on_tail("--version", "Show version") do
          unless unit_testing
            puts version
            exit
          end
        end

        Options.debug = Options.verbose >= 5
      end
    end

    def default_options(options, opts)
      opts.each do |key, value|
        options[key] = value unless options.keys.include?(key)
      end
    end

  end # class OptParse
end # module ArkTool
