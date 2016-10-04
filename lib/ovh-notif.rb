#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

##########################################
# require libnotify and its ruby binding #
##########################################

require 'libnotify'
# require 'launchy'

class OVHNotif

  def initialize()
    @notif_tab = Array.new
  end

  def add_or_remove_notif(notif)
    if @notif_tab.include? notif
      @notif_tab.delete notif
    else
      @notif_tab.push notif
    end
  end

  def toast(string)
    Libnotify.show(:summary => string.slice!(/^.*$/), :body => string, :icon_path => Dir.pwd + "/data/available.png")
  end

  # def url_browser(string)
  #   Launchy.open(string.slice!(/\s(\w+)$/))
  # end

  def launch(string)
    @notif_tab.each do |notif|
      Thread.new { notif.call(string) }
    end
  end

end
