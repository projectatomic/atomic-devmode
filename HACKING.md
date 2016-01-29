Playing with Atomic Developer Mode is a bit cumbersome
because of its tight integration with Atomic Hosts, in which
there is no package manager and the filesystem is mostly
read-only.

### 1. Building

Building atomic-devmode is very easy. There are no build
requirements. The spec file is available from the
[Fedora dist-git repo](http://pkgs.fedoraproject.org/cgit/rpms/atomic-devmode.git).
You can use `make archive` to produce the SOURCE archive
needed for `rpmbuild`.

### 2. Composing

For composing, you will need
[`rpm-ostree`](https://github.com/projectatomic/rpm-ostree)
and a checkout of
the
[fedora-atomic](https://git.fedorahosted.org/cgit/fedora-atomic.git).
Add `atomic-devmode` to the json manifest (if it hasn't been
added yet) and make sure that you use a higher NVR than what
is in the current Fedora repos. If you've never done tree
composes before, there are
[some](http://www.projectatomic.io/blog/2015/09/creating-custom-ostree-composes-for-atomic-testing/)
[good](http://developerblog.redhat.com/2015/01/08/creating-custom-atomic-trees-images-and-installers-part-1/)
[articles](http://developerblog.redhat.com/2015/01/15/creating-custom-atomic-trees-images-and-installers-part-2/)
that describe in details how to do it.

You will also need to enable an HTTP server that serves the
`repo` directory of your resulting tree compose.

### 3. Testing

There are two ways to test your new tree. One way is to
rebase onto it (easier), and the other is to create a
bootable image (harder).

#### Testing by rebase

Get the latest official [Fedora Atomic Host
image](https://getfedora.org/en/cloud/download/atomic.html)
and boot it up.

Once you're in, add your HTTP server as a remote and rebase
onto it:

```
# ostree remote add custom http://myserver/ --no-gpg-verify
# rpm-ostree rebase custom:fedora-atomic/f23/x86_64/docker-host
```

You can now reboot into the new deployment. Once you're in,
you can add the Developer Mode entry by doing:

```
# /usr/libexec/atomic-devmode/bootentry add
```

You should now be able to reboot and see the Developer Mode
boot menu.

#### Testing by image

If you'd like to create your own qcow2 image containing your
package and with the Developer Mode boot menu, you will
first need to install
[`rpm-ostree-toolbox`](https://github.com/projectatomic/rpm-ostree-toolbox/).
We will use the `imagefactory` command to create the qcow2
image.

You will also need a checkout of the
[fedora-atomic](https://git.fedorahosted.org/cgit/fedora-atomic.git)
and the
[spin-kickstarts](https://git.fedorahosted.org/cgit/spin-kickstarts.git)
repos.

Here is an example invocation of `rpm-ostree-toolbox`:

```
# rpm-ostree-toolbox imagefactory \
	-c fedora-atomic/config.ini -i kvm \
	--ostreerepo http://myserver/ \
	--tdl fedora-atomic/fedora-atomic-f23.tdl \
	-k spin-kickstarts/fedora-cloud-atomic.ks
```
