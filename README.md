# Vim keyboard shortcuts

* `CTRL+n` opens and closes NERDtree, `enter` to open it, `t` alone to open in tab
* `gt` to scroll between tabs, `gT` to go to the previous tab
* `CTRL+p` opens a fast jump-to-file
* In normal mode, `\ff` search for text in files
* `\cc` will comment the source code
* `/` to search, `F12` to toggle highlight of found words
* `V` (uppercase) selects a line, up, down to add or remove lines, then `d` cuts, `y` copy and `p` paste after cursor.
* `CTRL-n` twice to show or hide line numbers
* `F5` to show a list of buffers with numbers, and use them to change between them
* In visual mode, `CTRL-b` is pageUp, `CTRL-f` is pageDown

### tmux

* `CTRL-a` is the master key.
* `CTRL-a c` creates new window.
* `CTRL-a [` allows to scroll the window content.
* `CTRL-a (1-0)` allows to move between open windows, using numbers between 1 and 0.
* `CTRL-a [` to use selection mode... Space starts text selection, and enter copies, then, exit selection with `q`. Paste with `CTRL-a ]`.
* In visual mode, `CTRL-b` is pageUp, `CTRL-f` is pageDown

### Remember to create symlinks

In order to use these files, create a `.dotfiles` folder in your `$HOME` and then create a symlink to the given files...

```bash
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim/
```
