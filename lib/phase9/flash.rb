require_relative '../phase4/session.rb'
require_relative 'flashnow.rb'

module Phase9
  class Flash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          cookie = JSON.parse(cookie.value)

          return if set_flash_cookie(cookie)
        end
      end

      @flash_cookie = {}
    end

    # This method returns any values with this key associated with either 
    # flash or flash.now. If they both have this key, it returns both values in an array.
    def [](key)
      if @flash_cookie[key] && now[key]
        [@flash_cookie[key][0], @now[key]]
      elsif @flash_cookie[key]
        @flash_cookie[key][0]
      else
        now[key] || nil
      end
    end

    def []=(key, value)
      @flash_cookie[key] = [value, 0]
    end

    def now
      @now ||= FlashNow.new
    end

    # Stores all flash data in a separate 'flash' hash in the browser's cookie.
    def store_flash(res)
      cookie = { 'flash' => {} }

      @flash_cookie.keys.each do |key|
        cookie['flash'][key] = @flash_cookie[key]
      end

      browser_cookie = WEBrick::Cookie.new("_rails_lite_app", cookie.to_json)
      res.cookies << browser_cookie
    end

    def increment
      new_cookie = { }

      # Each value has a counter associated with it
      # If the counter is at 0, increment it. If it's at 1, get rid of the value
      @flash_cookie.keys.each do |key|
        if @flash_cookie[key][1] == 0
          @flash_cookie[key][1] += 1
          new_cookie[key] = @flash_cookie[key]
        end
      end

      @flash_cookie = new_cookie
    end

    private

    def set_flash_cookie(cookie)
      cookie.keys.each do |key|
        if key == "flash"
          @flash_cookie = cookie[key] 
          return true
        end
      end
      false
    end
  end
end