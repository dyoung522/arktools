require "spec_helper"

module ArkTool
  RSpec.describe ArkTool do
    it "has a version number" do
      expect(ArkTool::VERSION).not_to be nil
    end

    it "has a program name" do
      expect(ArkTool::PROGRAM).not_to be nil
    end

    describe OptParse do
      it "should have a valid --config command" do
        expect { OptParse.parse(%w(--config spec/spec_config.yml), true) }.not_to raise_error
      end

      it "should have a valid --dryrun command" do
        expect(Options.dryrun).to be_falsey
        expect { OptParse.parse(%w(--dry-run), true) }.not_to raise_error
        expect(Options.dryrun).to be true
      end

      it "should have a valid --help command" do
        expect { OptParse.parse(%w(--help), true) }.not_to raise_error
      end

      it "should have a valid --verbose command" do
        expect(Options.verbose).to eq(0)
        expect { OptParse.parse(%w(--verbose --verbose), true) }.not_to raise_error
        expect(Options.verbose).to eq(2)
      end

      it "should have a valid --version command" do
        expect { OptParse.parse(%w(--version), true) }.not_to raise_error
      end

      xit "should have a valid --basedir command" do
        expect { OptParse.parse(%w(--basedir foo), true) }.not_to raise_error
        expect(Options.basedir).to eq("foo")
      end

    end
  end
end
