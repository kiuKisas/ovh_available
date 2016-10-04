#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'Qt4'

require_relative 'qt-crawl-binding'
require_relative 'qt-notification'
require_relative 'qt-systray'

$width = 250
$height = 250

# window class

class QtParam < Qt::Widget

  attr_reader :systray, :notification

  def initialize(website_hash, notification)

    super()
    @notification = notification
    @website_hash = website_hash
   @systray = OVHSysTray.new("data/inactif.png", "data/actif.png", "data/available.png", "data/error.png", self)

    @website_name = website_hash.keys[0]
    @server_ref = @website_hash[@website_name].server_hash.values[0]

    @hide = false

    setWindowTitle "ovh-available"
    center
    init_ui

    show
  end

  # GUI

  def center
    tmp = Qt::DesktopWidget.new
    move (tmp.width - $width) / 2, (tmp.height - $height) / 2
  end

  def init_ui
    main_box = Qt::VBoxLayout.new self

    main_box.addWidget server_groupBox
    main_box.addWidget notif_groupBox
    main_box.addLayout gen_buttonBox
  end

  def server_groupBox
    group = Qt::GroupBox.new(tr("Choose &server :"))
    hbox = Qt::HBoxLayout.new

    hbox.addWidget(gen_comboBox(@website_hash, "change_website(QString)"))
    hbox.addWidget((@box_ref = gen_comboBox(@website_hash[@website_name].server_hash, "change_ref(QString)")))

    group.layout = hbox
    return group
  end

  def notif_groupBox
    group = Qt::GroupBox.new(tr("Choose &notification :"))
    vbox = Qt::VBoxLayout.new

    vbox.addWidget gen_checkBox("&alert popup", "alert")
    vbox.addWidget gen_checkBox("&desktop popup", "toast")
    group.layout = vbox
    return group
  end

  # systray

  def change_hide
    @hide = !@hide

    if @hide == true
      hide
      @thr = Thread.new {Qt_crawl.new(@website_hash[@website_name].server_hash.key(@server_ref), @server_ref, @website_hash[@website_name].url, 8, self).crawl_loop}
    else
      show
      Thread.kill(@thr)
    end
  end

  # function for radioButton

  def gen_checkBox(name, check)
    radio = Qt::CheckBox.new(name)
    radio.connect(SIGNAL(:clicked)) { on_notif(check) }
    return radio
  end

  # function for comboBox

  def change_comboBox(combo, hash, action)
    combo.clear
    hash_to_comboBox(combo, hash, action)
    return combo
  end

  def gen_comboBox(hash, action)
    combo = Qt::ComboBox.new self
    hash_to_comboBox(combo, hash, action)
  end

  def hash_to_comboBox(combo, hash, action)
    hash.each do |name, ref|
      combo.addItem name
    end
    connect combo, SIGNAL("activated(QString)"), self, SLOT(action)
    return combo
  end

  # function for button

  def gen_buttonBox()
    hbox = Qt::HBoxLayout.new

    hbox.addWidget(gen_button("&Ok", "on_ok()"), 1, Qt::AlignRight);
    hbox.addWidget(gen_button("&Quit", "on_quit()"));
    return hbox
  end

  def gen_button(string, action)
    ret = Qt::PushButton.new string, self
    connect ret, SIGNAL("clicked()"), SLOT(action)
    return ret
  end

  # def slot

  slots "on_quit()", "on_ok()", "change_website(QString)", "change_ref(QString)"

  def change_website(name)
    @website_name = name
    @server_ref = @website_hash[@website_name].server_hash.values[0]
    change_comboBox(@box_ref, @website_hash[@website_name].server_hash, "change_ref(QString)")
  end

  def change_ref(name)
    @server_ref = @website_hash[@website_name].server_hash[name]
  end

  def on_notif(notif)
    @notification.add_or_remove_notif(@notification.method(notif))
  end

  def on_quit
    Qt.execute_in_main_thread do
      close
    end
  end

  def on_ok
    @hide = true
      @thr = Thread.new {Qt_crawl.new(@website_hash[@website_name].server_hash.key(@server_ref), @server_ref, @website_hash[@website_name].url, 8, self).crawl_loop }

    hide
  end

end

# main class

class QtGUI

  def initialize(website_hash)
    @master = Qt::Application.new []
    @param = QtParam.new(website_hash, QTNotif.new)
  end

  def show
    @master.exec
  end

end
