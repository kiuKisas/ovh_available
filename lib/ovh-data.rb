#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'json'

class Website
  attr_reader :name, :url, :server_hash

  def initialize(name, url, hash)
    @server_hash = hash
    @name = name
    @url = url
  end

  def to_s
    ret = "\nname: #{@name} \nurl: #{@url} \nserveur: "
    @server_hash.each do |name, ref|
      ret += "\n#{name} ==> #{ref}"
    end
    return ret
  end
end

def     gen_website_hash

  website_hash = Hash.new

  JSON.parse(File.read("./data/server.json")).each do |website, data|
    website_hash[website] = Website.new(website, data["url"], data["server"])
    end
  return website_hash
end
