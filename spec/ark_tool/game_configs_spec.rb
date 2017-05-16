require "spec_helper"

module ArkTools
    describe GameConfigs do
      let (:gc) { GameConfigs.new(".") }

      it "instantiates a new class" do
        expect(gc).to be_an_instance_of GameConfigs
      end

      it "responds to #game" do
        expect(gc).to respond_to(:game)
        expect(gc.game).to be_an_instance_of IniFile
      end

      it "responds to #user" do
        expect(gc).to respond_to(:user)
        expect(gc.user).to be_an_instance_of IniFile
      end

      it "responds to #write" do
        inifile = instance_double(IniFile)
        allow(IniFile).to receive(:new).and_return(inifile)

        expect(inifile).to receive(:write).twice.and_return(true)
        gc.write
      end

      it "raises an error if given an invalid directory" do
        expect { GameConfigs.new("foo") }.to raise_error RuntimeError
      end
    end
end

