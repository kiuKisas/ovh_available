#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'Qt4'
require_relative '../ovh-notif'

class Dialog < Qt::Dialog
  def initialize(string)
    super()
    Qt::MessageBox.about(self, string.slice(/^.*$/), string)
    end
end

class QTNotif < OVHNotif
  def initialize()
    super()
  end

  def alert(string)
    Qt.execute_in_main_thread do
      Dialog.new string
      end
  end

end
