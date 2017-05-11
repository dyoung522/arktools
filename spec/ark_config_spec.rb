require "spec_helper"

module ArkTools
  describe ArkTools do
    it "has a version number" do
      expect(ArkTools::VERSION).not_to be nil
    end

    it "has a program name" do
      expect(ArkTools::PROGRAM).not_to be nil
    end
  end
end
