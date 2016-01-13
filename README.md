## Atomic Developer Mode

This package provides a developer-friendly way to use an
[Atomic Host](http://www.projectatomic.io) locally without
having to manually set up a cloud-init source. It's a great
way to try out Atomic with the minimum amount of fuss.

The package provides a new GRUB 2 menu item which, if
booted, sets up cloud-init to use a local datasource,
creates a new root password, sets up autologin for root on
`tty1`, and starts a new interactive tmux session in which
the [cockpit](http://cockpit-project.org/) image is
downloaded and started.

It is meant to be included in the initial tree installed by
the `%ostreesetup` kickstart command. The kickstart should
then (in its `%post`) call out to the `install` script in
order to have the GRUB 2 menu item created.

NB: There is a bug in versions of ostree prior to v2016.1
which causes an invalid `grub.cfg` file to be generated if
your current bootversion is 1. The
[fix](https://github.com/GNOME/ostree/pull/165) for this
is part of v2016.1. On older ostree versions, if you are
manually calling `install` to get the boot menu added and
your bootversion is currently 1 (i.e.  `/boot/loader` points
to `loader.1`), then you can work around it by setting the
`_OSTREE_GRUB2_BOOTVERSION` env var to 1 like so:

```
_OSTREE_GRUB2_BOOTVERSION=1 /usr/libexec/atomic-devmode/install
```

### Trying it out

Images built with this package can be found
[here](https://jlebon.fedorapeople.org/atomic-devmode/latest/).

### GRUB 2 timeout

To give users more time to make their selection, the GRUB 2
timeout is increased from 1s to 2s. However, the timeout
will be restored to 1s the next time `grub.cfg` is
regenerated (e.g. during an `upgrade/rebase/rollback` or
from an explicit `grub2-mkconfig -o /boot/loader/grub.cfg`).

### Root account

A systemd configuration override file is used to make the
getty service on `tty1` to autologin as root. A password is
auto-generated using `pwmake`, making sure that it contains
only friendly characters that are less prone to typos (see
them [here](libexec/pwmake_friendly)).

### Tmux

To provide a more tailored experience,
[tmux](https://github.com/tmux/tmux) is used to set
up the Atomic Developer Mode environment. A custom
configuration file is used which provide easy shortcuts for
navigating the panes and terminals:
- `Ctrl-Space`: activate next pane
- `Alt-1`: activate window 1
- `Alt-2`: activate window 2
- `Alt-3`: activate window 3

### Memoryless

Once booted in Developer Mode, rebooting into a normal tree
should not leave any lasting effects. Additionally, any
usage of `atomic host upgrade/rebase/rollback` or directly
calling `grub2-mkconfig -o /boot/loader/grub.cfg` will wipe
out the Developer Mode GRUB 2 boot menu item.
