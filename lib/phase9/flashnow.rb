module Phase9
  class FlashNow
    def initialize
      @temp_data = {}
    end

    def [](key)
      @temp_data[key]
    end

    def []=(key, value)
      @temp_data[key] = value
    end
  end
end