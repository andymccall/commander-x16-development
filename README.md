### VSCode Configuration

Ensure the Commander X16 headers are incldued in the includePath:

### Install VSCode

Install the following Extensions

https://marketplace.visualstudio.com/items?itemName=ms-vscode.makefile-tools  
https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-extension-pack  
https://marketplace.visualstudio.com/items?itemName=SharpNinja.cc65  

### Install cc65

```
username@host:~$ cd ~
username@host:~$ mkdir development
username@host:~$ cd development
username@host:~$ git clone git@github.com:cc65/cc65.git
username@host:~$ make install PREFIX=~/development/tools/cc65
```

Add cc65 bin to the path and add CC65_HOME environment variable:

```
username@host:~$ vi ~/.profile
```

Add the following at the bottom of the file:

```
# set PATH so it includes cc65 if it exists
if [ -d "$HOME/development/tools/cc65/bin" ] ; then
   PATH="$HOME/development/tools/cc65/bin:$PATH"
fi

# Add CC65_HOME
if [ -d "$HOME/development/tools/cc65/share/cc65" ] ; then
   CC65_HOME=$HOME/development/tools/cc65/share/cc65
fi
```

Test:

```
username@host:~$ source ~/.profile
username@host:~$ cc65 --version
cc65 V2.19 - Git 0541b65aa
```

### Install X16 Emulator

https://github.com/X16Community/x16-emulator/releases/

Download the latest release.

```
username@host:~$ unzip x16emu_linux-x86_64-r47.zip -d ~/development/tools/x16emu
```

Add the emulator to path:

```
username@host:~$ vi ~/.profile
```

Add the following at the bottom of the file:

```
# set PATH so it includes x16emu if it exists
if [ -d "$HOME/development/tools/x16emu" ] ; then
   PATH="$HOME/development/tools/x16emu:$PATH"
fi
```

Test:

```
username@host:~$ source ~/.profile
username@host:~$ x16emu
```