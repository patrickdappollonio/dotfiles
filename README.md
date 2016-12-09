# Vim keyboard shortcuts

* `CTRL+n` opens and closes NERDtree, `enter` to open it, `t` alone to open in tab
* `gt` to scroll between tabs, `gT` to go to the previous tab
* `CTRL+p` opens a fast jump-to-file
* In normal mode, `\ff` search for text in files
* `\cc` will comment the source code
* `/` to search, `F8` to toggle highlight of found words
* `V` (uppercase) selects a line, up, down to add or remove lines, then `d` cuts, `y` copy and `p` paste after cursor.
* `F5` to show a list of buffers with numbers, and use them to change between them
* `\(1-9)` allows to switch between buffers with numbers as well.
* `CTRL-g` toggle line numbers and git gutter
* In visual mode, `CTRL-b` is pageUp, `CTRL-f` is pageDown
* In any mode, write an emmet HTML markup, then press `CTRL-y-,` to get full completion
* In any mode, press `F7` to fix indentation problems
* `\u` shows an undo-history. Useful to move back and forth between changes
* `\a:` or `\a=` will sort variable declaration "a la Golang"

Jumping to definitions and in the file:
* `gd` will take you to the local declaration.
* `gD` will take you to the global declaration.
* `g*` search for the word under the cursor (like `*`, but `g*` on 'rain' will find words like 'rainbow').
* `g#` same as `g*` but in backward direction.
* `gg` goes to the first line in the buffer (or provide a count before the command for a specific line).
* `G` goes to the last line (or provide a count before the command for a specific line).
* `gf` will go to the file under the cursor
* `g]` and other commands will jump to a tag definition (a tag can be a function or variable name, or more).

Moving in a file:
* `k` is Up, `j` is Down, `h` is Left, `l` is Right. `w` moves a word forward.

### tmux

* `CTRL-a` is the master key.
* `CTRL-a c` creates new window.
* `CTRL-a [` allows to scroll the window content.
* `CTRL-a (1-0)` allows to move between open windows, using numbers between 1 and 0.
* `CTRL-a [` to use selection mode... Space starts text selection, and enter copies, then, exit selection with `q`. Paste with `CTRL-a ]`.
* `CTRL-a n` allows to change the window name
* `CTRL-a w` shows a list of windows
* `CTRL-a x` prompts to kill the window
* In visual mode, `CTRL-b` is pageUp, `CTRL-f` is pageDown

To manage panels:

* `CTRL-a |` creates a new vertical panel
* `CTRL-a -` creates a new horizontal panel
* `Alt-Up`, `Alt-Down`, `Alt-Left`, `Alt-Right` allows to move between panels
* Resize panels by using `CTRL-a-(h,l)` to resize left or right, and `CTRL-a-(j,k)` to resize up and down

### Remember to create symlinks

In order to use these files, create a `.dotfiles` folder in your `$HOME` and then create a symlink to the given files...

```bash
ln -s ~/.dotfiles/.bash_profile ~/.bash_profile
ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/.vimrc ~/.vimrc
ln -s ~/.dotfiles/.vim ~/.vim/
```

### Attach tmux session automatically

```
which tmux >/dev/null 2>&1 && { tmux attach || tmux new -s ssh-conn;  } || bash -l
```

The command above will create a tmux session or attach to an existent one called `ssh-conn`.
