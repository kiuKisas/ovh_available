# ovh_available

ovh_available is a little ovh crawler writing in ruby with a gui in Qt4. It allow you to survey if an ovh server is available for rent.

## Install

You need ruby, Qt4 and QtRuby. An example on arch:
> pacman -S qt4 ruby

You can use the gem manager for install QtRuby:
> gem install qtbindings

## Screenshots

![Menu](https://github.com/kiuKisas/ovh_available/blob/master/img/menu.png "Menu")

![Desktop](https://github.com/kiuKisas/ovh_available/blob/master/img/notif_desktop.png "Desktop")

![Popup](https://github.com/kiuKisas/ovh_available/blob/master/img/notif_popup.png "Popup")

## Known issues

* bug with kimsufi - KS-4

## To-do

* multiple server crawler
* add more server to server.json
* make a server version in RubyOnRails
* add notification
* better link to rent