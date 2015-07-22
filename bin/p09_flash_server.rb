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

  def see_flash
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
  end
end

trap('INT') { server.shutdown }
server.start
