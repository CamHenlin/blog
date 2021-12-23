---
title: A simplified guide to classic Macintosh development using Retro68 and pce-macplus
date: 2021-12-03 23:44:32
tags:
---
I started playing around using [Retro68](https://github.com/autc04/Retro68) on a modern Linux-based machine to do development work for old Macintosh computers in the spirit of [one of my previous posts](/2021/02/11/technical-things-i-would-work-on-if-i-had-unlimited-time/).

Who can use this guide? Anyone who wants to get up and running with Mac development being cross compiled from a modern Linux environment as quickly as possible. I've laid out the commands and explanations in the most straightforward way I could with the simple goal of running a hello world application.

I used a few other guides to build up to what I ultimately wound up using for my development workflow:

- http://www.toughdev.com/content/2018/12/developing-68k-mac-apps-with-codelite-ide-retro68-and-pce-macplus-emulator/ - this is hands down the best guide I have seen and what I base most of this workflow on
- http://www.toughdev.com/content/2016/11/pcemacplus-the-ultimate-68k-classic-macintosh-emulator/
- http://www.toughdev.com/content/2017/03/exploring-retro68-gcc-based-sdk-for-68k-macintoshes/
- https://github.com/autc04/Retro68

I used Ubuntu running on an intel-based Mac Mini for my build environment. To run the complete toolchain that I'll outline in this post and several other following posts, you'll need a Linux-based environment as that is the only way I'm aware of to make full use of pce-macplus's serial port. Off we go...

## Setting up Retro68
There are complete instructions at http://www.toughdev.com/content/2017/03/exploring-retro68-gcc-based-sdk-for-68k-macintoshes/, these are abridged for Ubuntu between the toughdev and Retro68 docs:

First ensure prereqs are installed:

```
sudo apt-get install cmake libgmp-dev libmpfr-dev libmpc-dev libboost-all-dev bison flex texinfo ruby
```

Then clone the repo:

```
git clone https://github.com/autc04/Retro68.git
cd Retro68
git pull
git submodule update
cd ..
```

Get the MPW includes downloaded and in place:

```
wget https://henlin.net/images/Retro68_includes.zip
unzip Retro68_includes.zip
mv -R ./Retro68_includes/* Retro68/InterfacesAndLibraries
```

Build Retro68:

```
mkdir Retro68-build
cd Retro68-build
../Retro68/build-toolchain.bash
```

If everything went well, you should now have a functional Retro68 environment! Back to that in a bit...

## Setting up serial port emulation
One of the motivations here is that we have full serial communication to enable the development of software utilizing the serial port on the Macintosh for bidirectional communication. We emulate that locally with tty0tty

```
git clone https://github.com/freemed/tty0tty
tar xf tty0tty-1.2.tgz
cd tty0tty-1.2/module
make
sudo cp tty0tty.ko /lib/modules/$(uname -r)/kernel/drivers/misc/
sudo depmod
sudo modprobe tty0tty
sudo chmod 666 /dev/tnt*
```

You should now have functional fake serial port pairs at `/dev/tnt*` (ex, `/dev/tnt0` is linked to `/dev/tnt1`, etc)

## Setting up pce-macplus
Again, complete instructions are available at http://www.toughdev.com/content/2016/11/pcemacplus-the-ultimate-68k-classic-macintosh-emulator/

To run pce-macplus on latest Ubuntu, we need to compile it ourselves. We'll do that with the following:

First we need some prereqs:
```
sudo apt-get install libx11-dev libx11-doc libxau-dev libxcb1-dev libxdmcp-dev x11proto-core-dev x11proto-input-dev x11proto-kb-dev xorg-sgml-doctools xtrans-dev
sudo apt-get install libsdl1.2-dev libsdl1.2debian
```

Then we'll download and install pce-macplus:

```
wget http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz
tar -xvf pce-0.2.2.tar.gz
cd pce-0.2.2
./configure -with-x --with-sdl --enable-tun --enable-char-ppp --enable-char-tcp --enable-sound-oss --enable-char-slip --enable-char-pty --enable-char-posix --enable-char-termios
make
sudo make install
```

Now we'll drop a custom configuration in place for pce-macplus, which is used for setting up our serial port to point at `/dev/tnt0` that we set up in the last part of the guide. If we use the default configuration in place, it will work, but will not interact with tty0tty if we want to do serial port development.

```
wget https://gist.githubusercontent.com/CamHenlin/054adf631210cc46159f40b04f5c34a0/raw/8d545c497a26aa5f5f956efb3b77c75f2d08dcbf/mac-classic.cfg
mv ./mac-classic.cfg ~/Documents/Mac\ OS\ Emulators/pce-mac/pce-mac-classic/mac-classic.cfg
```

## Setting up VSCode
Download a sample application to start working with. I recommend https://github.com/CamHenlin/nuklear-quickdraw as a project base and I will use it as the example here as I know it will function in this environment.


##  Setting up VSCode
We're about ready to start coding. VSCode is a great place to do development work on Retro68 projects. Here's how we can set it up:

## Running a "hello world" application

## Next steps
