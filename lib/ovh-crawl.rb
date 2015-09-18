#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'json'
require 'net/http'

# load localisation

$local_hash = JSON.parse(File.read("./data/localisation.json"))

# class server

class Server
  attr_reader :local, :available

  def initialize(local, available)
    @local = local
    @available = available
  end

  def change_available(available)
    @available = available
  end

  def to_s
    if $local_hash[@local]
      ret = "#{$local_hash[@local]} - "
    elsif
      ret = "#{@local} - "
    end
    if @available == "unknow"
      ret += "server unavailable for now."
    elsif
      ret += @available
    end
    return ret
  end

end

# class of server type, contain a server tab

class Server_type
  attr_reader :name, :ref, :url, :server_tab

  def initialize(name, ref, url)
    @name = name
    @ref = ref
    @url = url
    @server_tab = []
    @available = 0
  end

  def add_server(local, available)
    server_tab.push(Server.new(local, available))
  end

  def get_available()
    @available = 0
    @server_tab.each do |server|
      if server.available != "unknown"
        @available += 1
      end
    end
    return @available
  end

  def nbr_server
    return @server_tab.length
  end

  def to_s
    ret = "#{@name} : #{@available} available(s) !\n"
    @server_tab.each do |server|
      if server.available != "unknown"
        ret += "- " + server.to_s + "\n"
      end
    end
    ret += @url
    return ret
  end

end

# just a clean fonction

def clean_json(source)
  source[source.index('{')..source.rindex('}')]
end

# class for crawl

class   OVH_crawl

  def get_new_session()
      Net::HTTP::Get.new(@get_session.to_s)
    @session_id = JSON.parse(clean_json(Net::HTTP::get_response(@get_session).body))["answer"]["session"]["id"]
    @url = URI.parse("https://ws.ovh.com/dedicated/r2/ws.dispatcher/getAvailabilityFromReference?callback=Request.JSONP.request_map.request_2&params={%22sessionId%22%3A%22#{@session_id}%22%2C%22reference%22%3A%22#{@server.ref}%22}")
  end

  def initialize(name, ref, url)
    @server = Server_type.new(name, ref, url)

    @get_session = URI.parse("https://ws.ovh.com/sessionHandler/r4/ws.dispatcher/getAnonymousSession?callback=Request.JSONP.request_map.request_1")
    self.get_new_session()
  end

  def check_server(local, availability)
    @server.server_tab.each do |tab|
      if tab.local == local
        tab.change_available(availability)
        return true
      end
    end
    return false
  end

  def check_available
    Net::HTTP::Get.new(@url.to_s)
    res = JSON.parse(clean_json(Net::HTTP::get_response(@url).body))["answer"]

    if res == nil
      self.get_new_session()
      return self.check_available
    elsif res.size == 0
      return -1
    end

    res[0]["metaZones"].each do |key|
      if !self.check_server(key["zone"], key["availability"])
        @server.add_server(key["zone"], key["availability"])
      end
    end

    return @server.get_available
  end

end
