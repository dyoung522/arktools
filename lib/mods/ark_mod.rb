module ArkTools
  class ArkMod
    attr_reader :id, :description

    def initialize(mod)
      @id          = mod[0]
      @description = mod[1]
    end

    def to_s
      "#{id}:#{description}"
    end
  end
end
