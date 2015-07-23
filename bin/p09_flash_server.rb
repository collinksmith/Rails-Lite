require 'webrick'
require_relative '../lib/phase9/controller_base'

# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPRequest.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/HTTPResponse.html
# http://www.ruby-doc.org/stdlib-2.0/libdoc/webrick/rdoc/WEBrick/Cookie.html

class MyController < Phase9::ControllerBase
  def set_flash
    flash["test"] = "This is my flash message!"
    render :blank
  end

  def flashred
    flash["test"] = "Testing flash redirection"
    redirect_to :see
  end

  def see_flash
    render :flash
  end

  def nowred
    flash.now["test"] = "TESTING FLASH.NOW REDIRECT. You should never see this >-("
    redirect_to :see
  end

  def nowren
    flash["test"] = "Testing merge of flash and flash.now."
    flash.now["test"] = "Testing flash.now render. You should see this!"
    render :flash
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  case req.path
  when '/set'
    MyController.new(req, res).set_flash
  when '/see'
    MyController.new(req, res).see_flash
  when '/nowred'
    MyController.new(req, res).nowred
  when '/nowren'
    MyController.new(req, res).nowren
  when '/flashred'
    MyController.new(req, res).flashred
  end
end

trap('INT') { server.shutdown }
server.start
