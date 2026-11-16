# Yubikey on Fedora

With [mise](https://github.com/jdx/mise) installed, run the following to get the dependencies needed for yubikey's python command line tool.

```bash
sudo dnf install pcsc-lite-devel swig
mise use --global pipx:yubikey-manager
```

## Instructions

Follow [https://blog.infected.systems/posts/2026-11-03-i-deleted-all-my-ssh-keys/](https://blog.infected.systems/posts/2026-11-03-i-deleted-all-my-ssh-keys/) for more.
