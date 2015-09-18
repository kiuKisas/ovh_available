# ovh_available

ovh_available is a little ovh crawler written in ruby with a gui in Qt4. It allows you to survey if an ovh server is available for rent.

## Install

You need ruby, Qt4 and QtRuby. An example on arch:
> pacman -S qt4 ruby

You can use the gem manager to install QtRuby:
> gem install qtbindings

## Screenshots

![Menu](https://github.com/kiuKisas/ovh_available/blob/master/img/menu.png "Menu")

![Desktop](https://github.com/kiuKisas/ovh_available/blob/master/img/notif_desktop.png "Desktop")

![Popup](https://github.com/kiuKisas/ovh_available/blob/master/img/notif_popup.png "Popup")

## Known issues

* bug with kimsufi - KS-4

## To-do

* multiple server crawler
* add more servers to server.json
* make a server version in RubyOnRails
* add notifications
* better link to rent