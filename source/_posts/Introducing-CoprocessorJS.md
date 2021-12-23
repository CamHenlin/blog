---
title: Introducing CoprocessorJS
date: 2021-12-21 10:52:34
tags:
---

## The motivation -- what is CoprocessorJS and what am I hoping to accomplish?
One of my dreams is to create a modern piece of software that allows programmers on any old machine to hand off work loads off to a modern machine over the serial port and get a response back that they can then interact with. This software will provide a standard interface for serial-connected devices to provide code to execute.
 
For my first approach, I am going to have workloads all be in modern nodejs. I like nodejs because it has a vast ecosystem of easy to use packages via npm, and if you are using an old computer, should be "fast enough" to do whatever it is you are trying to do. I have built a C-based package aimed at classic (System 6-based) Macintoshes as a first use case.
 
Ultimately I think that using libraries like CoprocessorJS, we can enable a new class of useful, modern, Internet-connected applications for classic machines without hacking around old TCP/IP libraries or fighting encryption.

## What can it do?
The basic functions that will go into a library include: 
- one for loading nodejs programs over the serial port
- one function for calling functions in the nodejs program over the serial port back and getting a response
- one for evaluating raw string code within the nodejs app on the serial port and getting a response.

The current iteration of the code allows chunks of data in a function or eval response to reach up to 100kb, beyond that a programmer will have to manually chunk data. That's really a lot of data and should allow for some interesting stuff.

## Testing it out
In addition to that, I've worked out a simple shell script for packaging complete nodejs applications in to a C application to send over the wire, and used this strategy to create a slightly more interesting Retro68 C test application. The test application includes a nodejs application that sets up puppeteer (headless chrome) on the remote system, and uses puppeteer to grab the text contents of a web page, then dumps that text back across the serial port. I think this is pretty neat. 

This code is up at https://github.com/CamHenlin/retro68-coprocessorjs-test

At this point, I think someone could use the Retro68 test application to create just about any terminal-based application they want, with all of the heavy lifting done in modern JS on the other side of a serial port, as long as the Retro68 console suits their needs. Writing Internet-conected applications is now easy, without mucking around with old TCP libraries or expensive hardware. If you need instructions on how to build a physical USB cable to plug in to your Mac's serial port, see my other post [here]()
 
## Getting the library
In addition to that, the C library file itself is also up in a discrete repository with a lengthy README explaining how to use the library to build a coprocessorjs application. That new repo is at: https://github.com/CamHenlin/coprocessorjslib. I tried to make the README as clear as possible, let me know if you have any questions about it. I intend to consume this library in a more interesting application (with a corresponding post!) soon.
