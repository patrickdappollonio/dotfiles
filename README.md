# Vim keyboard shortcuts

* `CTRL+n` opens and closes NERDtree, `enter` to open it, `t` alone to open in tab
* `gt` to scroll between tabs, `gT` to go to the previous tab
* `CTRL+p` opens a fast jump-to-file
* `\cc` will comment the source code
* `/` to search, `F8` to toggle highlight of found words
* `V` (uppercase) selects a line, up, down to add or remove lines, then `d` cuts, `y` copy and `p` paste after cursor.
* `\(1-9)` allows to switch between buffers with numbers as well.
* `CTRL-g` toggle line numbers and git gutter
* In visual mode, `CTRL-b` is pageUp, `CTRL-f` is pageDown
* In any mode, write an emmet HTML markup, then press `CTRL-y-,` to get full completion
* In any mode, press `F7` to fix indentation problems
* `\u` shows an undo-history. Useful to move back and forth between changes
* `\z` closes a buffer preview windows (such as the ones created by vim-go)
* `ds"` will delete surrounding double quotes (as in `[d]elete-[s]urrounding-"`). You can change quotes to anything.
* `cs'"` will change surrounding single quotes to double (as in `[c]hange-[s]urrounding-'-"`). You can change quotes to anything.
* `ysiw"` will add quotes to the given word (as in `[y]ank-[s]urrounding-[i]nner-[w]ord-"`). You can change quotes to anything.
* `\r` is a handy way to replace the selected text with confirmation.
* `CTRL-j` and `CTRL-k` will move the current line or selected text up and down

Jumping to definitions and in the file:
* `gd` will take you to the local declaration.
* `gD` will take you to the global declaration.
* `g*` search for the word under the cursor (like `*`, but `g*` on 'rain' will find words like 'rainbow').
* `g#` same as `g*` but in backward direction.
* `gg` goes to the first line in the buffer (or provide a count before the command for a specific line).
* `G` goes to the last line (or provide a count before the command for a specific line).
* `gf` will go to the file under the cursor
* `g]` and other commands will jump to a tag definition (a tag can be a function or variable name, or more).

Moving between split windows
* `\wh` will create a new horizontal window inside vim
* `\wv` will create a new vertical window inside vim
* `\s` will create a split window horizontal
## Requirements

```bash
sudo apt-get update && \
    sudo apt-get upgrade -y && \
    sudo apt-get install xclip tmux vim-nox -y
    
# in old environments you might need a newer version of tmux
sudo add-apt-repository ppa:jamesw05/tmux
```

### Copy and paste to and from tmux buffers

Since tmux has its own buffer where you can store stuff by copying accessing copy-mode with `CTRL-a [` and pasting with `CTRL-a ]` then
you might want to access it programatically, so `pbc` (taken from `pbcopy`) copy any piped data into the tmux buffer, and `pbp` outputs
it, so you can do stuff like:

```txt
$ echo "hello" | pbc

$ pbp > data.txt && cat data.txt
hello
```

### Save PuTTY settings

Save sessions only:
```
regedit /e "%USERPROFILE%\Desktop\putty-sessions.reg" HKEY_CURRENT_USER\Software\SimonTatham\PuTTY\Sessions
```

Save all settings:
```
regedit /e "%USERPROFILE%\Desktop\putty.reg" HKEY_CURRENT_USER\Software\SimonTatham
```

### tmux

* `CTRL-a` is the master key.
* `CTRL-a c` creates new window.
* `CTRL-a [` allows to scroll the window content.
* `CTRL-a [` then `enter` allows to copy the content selected (using `CTRL+v` or `space`), while `CTRL-a ]` paste it.
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
chmod +x ~/.dotfiles/symlinks.sh

# to create symlinks
~/.dotfiles/symlinks.sh create

# to update symlinks
~/.dotfiles/symlinks.sh update

# to delete symlinks
~/.dotfiles/symlinks.sh delete
```

### Install vundle.vim

```
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
```

### Source bash profile if it exists

```bash
# Source my own
if [ -f ~/.dotfiles/.bash_profile ]; then
    . ~/.dotfiles/.bash_profile
fi
```

### Update Vim to Vim 8.0

```bash
# add ppa repository
sudo add-apt-repository ppa:jonathonf/vim

# update and install
sudo apt-get update && sudo apt-get install vim vim-nox
```

### Use updated versions of Git

```bash
# add ppa repository
sudo add-apt-repository ppa:git-core/ppa

# update and install
sudo apt-get update && sudo apt-get install git
```

### Disable IPv6

```bash
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4
```

### Install Go

Download the appropiate version from [golang.org/dl](https://golang.org/dl/) and then run the following commands (since it's trying to write to `/usr/local` you might want to throw a `sudo` here):

```bash
wget -O /tmp/golang.tar.gz $(curl -s https://golang.org/dl/ | grep "linux-amd64.tar.gz" | sed -n 1p | sed -E 's/.*"([^"]+)".*/\1/') && \
    rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/golang.tar.gz && rm -rf /tmp/golang.tar.gz
```

Then add the path to `/etc/profile.d/golang.sh` (create if not exists) or your own profile file and add:

```bash
if [ -d "/usr/local/go" ]; then
    export PATH=$PATH:/usr/local/go/bin
fi
```

### Reading service logs with `journalctl`

```bash
# Example with cntlm:
journalctl -f --no-pager -u cntlm.service
```

### Git configuration

   * [Create the SSH keys](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)
   * [Signing commits](https://help.github.com/articles/generating-a-new-gpg-key/)
