#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

class OVHSysTray < Qt::SystemTrayIcon

  def initialize(inactif, actif, available, error, gui)
   super()

    @icon = [Qt::Icon.new(inactif), Qt::Icon.new(actif), Qt::Icon.new(available), Qt::Icon.new(error)]
    self.icon = @icon[0]

    @observer = gui
    self.connect(SIGNAL('activated(QSystemTrayIcon::ActivationReason)')) do |click|
      if click == Qt::SystemTrayIcon::Trigger
        @observer.change_hide
      end
    end

    # menu

    menu = Qt::Menu.new
    quit = Qt::Action.new("&Quit", menu)
    quit.connect(SIGNAL(:triggered)) { exit }
    hide = Qt::Action.new("&show / &hide", menu)
    hide.connect(SIGNAL(:triggered)) { @observer.change_hide }

    menu.addAction(hide)
    menu.addAction(quit)

    self.contextMenu = menu
    show
  end

  # action

  def change_icon(index)
    Qt.execute_in_main_thread do
      self.icon = @icon[index]
      end
  end

end
