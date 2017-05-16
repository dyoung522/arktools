require "spec_helper"

module ArkTools
    describe GameConfigs do
      let (:gc) { GameConfigs.new(".") }

      it "instantiates a new class" do
        expect(gc).to be_an_instance_of GameConfigs
        expect { GameConfigs.new(".") }.not_to raise_error
      end

      it "responds to #game" do
        expect(gc).to respond_to(:game)
        expect(gc.game.ini).to be_an_instance_of IniParse::Document
        expect(gc.game.filename).to include("Game.ini")
      end

      it "responds to #user" do
        expect(gc).to respond_to(:user)
        expect(gc.user.ini).to be_an_instance_of IniParse::Document
        expect(gc.user.filename).to include("GameUserSettings.ini")
      end

      it "responds to #save" do
        inifile = instance_double(IniParse::Document)
        allow(IniParse).to receive(:parse).and_return(inifile)
        allow(inifile).to receive(:path=).and_return(true)

        expect(inifile).to receive(:save).twice.and_return(true)
        gc.save
      end

      it "raises an error if given an invalid directory" do
        expect { GameConfigs.new("foo") }.to raise_error RuntimeError
      end
    end
end

