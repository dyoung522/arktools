require "spec_helper"

module ArkTools
  module Mods
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
      let (:modlist) { ArkModList.new({ input: "testfile" }) }
      let (:output) { StringIO.new("Foo\n#11111 comment 1\n22222 test 1\n;55555 comment 2\n44444 test 2\n33333 test 3\n") }

      before(:each) do
        allow(File).to receive(:open).with("testfile", "r").and_yield(output)
      end

      it "instantiates a new class" do
        expect(modlist).to be_an_instance_of ArkModList
      end

      it "ignores invalid/commented lines" do
        expect(modlist.mods.length).to eq(3)
      end

      it "maintains modlist order" do
        expect(modlist.mods[0].id).to eq("22222")
        expect(modlist.mods[1].id).to eq("44444")
        expect(modlist.mods[2].id).to eq("33333")
      end

      it "responds to #csv" do
        expect(modlist).to respond_to(:csv)
        expect(modlist.csv).to eq("22222,44444,33333")
      end
      end
  end
end

