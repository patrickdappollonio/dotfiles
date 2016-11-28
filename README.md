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

### Remember to create symlinks

In order to use these files, create a `.dotfiles` folder in your `$HOME` and then create a symlink to the given files...

```bash
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim/
```
