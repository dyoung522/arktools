require "spec_helper"

module ArkTools
  module Generate
    describe ArkGameLevels do
      let (:gli) { ArkGameLevels.new({ level: 100 }) }

      it "instantiates a new class with reasonable defaults" do
        expect(gli).to be_an_instance_of ArkGameLevels
        expect(gli.exp).to eq(1000000)
        expect(gli.growth.round(2)).to eq(3.0)
      end

     it "responds to #calc_exp" do
        expect(gli).to respond_to(:calc_exp)
      end

      it "responds to #make_levels" do
        expect(gli).to respond_to(:calc_exp)
      end

      it "responds to #player_levels" do
        expect(gli).to respond_to(:player_levels)
      end

      it "responds to #dino_levels" do
        expect(gli).to respond_to(:dino_levels)
      end

      it "accepts a given max exp" do
        gl = ArkGameLevels.new(level: 100, exp: 500)
        expect(gl.exp).to eq(500)
      end

      it "accepts a given growth rate" do
        gl = ArkGameLevels.new(level: 100, growth: 5.0)
        expect(gl.growth).to eq(5.0)
      end

      context "#calc_exp" do
        it "calculates the logarithmic experience required for a given level" do
          expect(gli.calc_exp(1)).to eq(1)
          expect(gli.calc_exp(10)).to eq(1000)
          expect(gli.calc_exp(100)).to eq(1000000)
        end
      end

      context "#make_levels" do
        it "raises an error if not provided with valid input" do
          expect { gli.make_levels("foo") }.to raise_error RuntimeError
        end

        it "returns a string containing a valid LevelExperienceRampOverrides=" do
          expect(ArkGameLevels.new(level: 2).make_levels("Player").to_s).
            to include("LevelExperienceRampOverrides = (ExperiencePointsForLevel[0]=0,ExperiencePointsForLevel[1]=1)")
        end
      end

      context "#player_levels" do
        it "returns a string containing a valid OverrideMaxExperiencePointsPlayer" do
          expect(ArkGameLevels.new(level: 1).player_levels).
            to match /^OverrideMaxExperiencePointsPlayer=\d/
        end
      end

      context "#dino_levels" do
        it "returns a string containing a valid OverrideMaxExperiencePointsDino" do
          expect(ArkGameLevels.new(level: 1).dino_levels).
            to match /^OverrideMaxExperiencePointsDino=\d/
        end
      end
    end
  end
end


