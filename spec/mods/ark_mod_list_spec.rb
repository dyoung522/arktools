require "spec_helper"

RSpec.describe ArkModList do
  let (:modlist) { ArkModList.new }

  it "instantiates a new class" do
    expect(modlist).to be_an_instance_of ArkModList
  end
end
