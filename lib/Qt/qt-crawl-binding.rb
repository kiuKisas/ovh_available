#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'Qt4'
require_relative '../ovh-crawl'

class Qt_crawl < OVH_crawl

  def initialize(name, ref, url, time, gui)
    super(name, ref, url)

    @time = time
    @tray = gui.systray
    @notif = gui.notification
    @gui = gui
  end

  def crawl_loop
    available = 0
    while (available == 0)
      @tray.change_icon(1)
      available = self.check_available
     @tray.change_icon(0)

      if available == -1
        return crawl_error
      elsif available > 0
        return is_available
      end

      sleep @time
    end
  end

  def crawl_error
    @tray.change_icon(3)
    @notif.launch "ovh_available error\n they don't have any #{@name}, please try again"
    @gui.on_quit
  end

  def is_available
    @tray.change_icon(2)
    @notif.launch @server.to_s
    @gui.on_quit
  end

end
