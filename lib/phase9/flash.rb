require_relative '../phase4/session.rb'

module Phase9
  class Flash
    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          value = JSON.parse(cookie.value)
          cookie = value

          cookie.keys.each do |key|
            if key == "flash"
              @flash_cookie = cookie[key] 
              return
            end
          end
        end
      end

      @flash_cookie = {}
    end

    def [](key)
      @flash_cookie[key] ? @flash_cookie[key][0] : nil
    end

    def []=(key, value)
      @flash_cookie[key] = [value, 0]
      p "FLASH COOKIE: #{@flash_cookie}"
    end

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

      @flash_cookie.keys.each do |key|
        if @flash_cookie[key][1] == 0
          @flash_cookie[key][1] += 1
          new_cookie[key] = @flash_cookie[key]
        end
      end

      @flash_cookie = new_cookie
    end
  end
end