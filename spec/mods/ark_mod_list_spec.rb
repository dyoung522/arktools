require "spec_helper"

module ArkTools
  describe ArkMod do
    let (:mod) { ArkMod.new(["1", "test"]) }

    it "instantiates a new class" do
      expect(mod).to be_an_instance_of ArkMod
      expect(mod.id).to eq("1")
      expect(mod.description).to eq("test")
    end

    it "responds to #to_s" do
      expect(mod).to respond_to(:to_s)
      expect(mod.to_s).to eq("1:test")
    end
  end

  describe ArkModList do
    let (:modlist) { ArkModList.new("spec/modlist_test") }

    it "instantiates a new class" do
      expect(modlist).to be_an_instance_of ArkModList
    end

    it "ignores invalid/commented lines" do
      expect(modlist.mods.length).to eq(2)
    end

    it "maintains modlist order" do
      expect(modlist.mods[0].id).to eq("12345")
      expect(modlist.mods[1].id).to eq("56789")
    end

    it "responds to #csv" do
      expect(modlist).to respond_to(:csv)
      expect(modlist.csv).to eq("12345,56789")
    end
  end
end
