---
title: Technical idea - Making old Macs more useful
date: 2021-02-11 10:58:57
tags:
---

If I had unlimited time on my hands I would work on software to make old computers more useful.

My ultimate goal is that I would like to be able to use a Macintosh Plus running System 7.x to:

- browse the internet arbitrarily, meaning full execution of JS, full images (converted to grayscale of course!), etc
- handle emails (using all the modern things you'd expect in an email client)
- ssh into other machines
- probably other stuff

I would achieve this by using a combination of:

- https://github.com/autc04/Retro68 - retro68 library for using gcc to target older macs
- https://github.com/akuker/RASCSI - mac scsi library for raspberry pis
- a raspberry pi to do heavy lifting
- create a custom library to easily offload processing to the rpi over the SCSI interface

The general idea is that the Mac would be displaying items that the rpi is handling the processing for. This would allow for unmodified old Mac hardware to be useful again
