## atomic-devmode

This package provides a developer-friendly way to use an
[Atomic Host](http://www.projectatomic.io) locally without
having to manually set up a cloud-init source. It's a great
way to try out Atomic with the minimum amount of fuss.

The package provides a new GRUB2 menu item which, if booted,
sets up cloud-init to use a local datasource, creates a new
root password, sets up autologin for root on `tty1`, and
starts a new interactive tmux session in which the
[cockpit](http://cockpit-project.org/) image is downloaded
and started.

It is meant to be included in the initial tree installed by
the `%ostreesetup` kickstart command. The kickstart should
then (in its `%post`) call out to the
`atomic-devmode-install` script in order to have the GRUB2
menu item created.
