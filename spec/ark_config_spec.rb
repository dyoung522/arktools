require "spec_helper"

module ArkTools
  describe ArkTools do
    it "has a version number" do
      expect(ArkTools::VERSION).not_to be nil
    end

    it "has a program file" do
      expect(ArkTools::PROGRAM_FILE).not_to be nil
    end

    it "has a program name" do
      expect(ArkTools::PROGRAM_NAME).not_to be nil
    end
  end
end
