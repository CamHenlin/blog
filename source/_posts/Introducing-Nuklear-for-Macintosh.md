---
title: Introducing Nuklear for Macintosh
date: 2021-12-21 10:53:34
tags:
---

I was curious what people's opinions were on the state of GUI programming on old Macs. Here goes my rambling post on the subject, hopefully this is enough to get a discussion going. :D
 
For some background, I am new to Mac programming but experienced with programming in general. I have been doing a fair amount of programming using the Retro68 console recently, but now I'm looking to create some more GUI-based applications, so they can feel more "Mac-like".
 
I've been pouring through the books "Inside Macintosh: Macintosh Toolbox Essentials" and "Inside Macintosh: More Macintosh Toolbox" along with some other resources online, and have been playing around a bit manipulating the "MenuSample" test app from this blog post: http://www.toughdev.com/content/2018/12/developing-68k-mac-apps-with-codelite-ide-retro68-and-pce-macplus-emulator/.
 
I'm forming some opinions that I'm wondering if I should be swayed on: 
programming against the Macintosh Toolbox is cumbersome, difficult to use
for example, even creating a textbox to handle input on the screen requires multiple steps across multiple files (res file definition + handling in code and the code is non-trivial compared to how one might do it today)
it is difficult to define layouts and respond to size changes. adding lots of elements to a window and dealing with them is pretty hard
this is probably hindering the creation of at least a subset of new Mac apps that could be getting developed... Personally I think there is a lot of interest but the barrier to entry is high
GUI programming has advanced a lot in the last 30 years and even basic GUI libraries do a lot more for the programmer these days
Programmers writing software for Macs in the 80s and 90s were heroes. It's amazing what they accomplished with the tooling and resources that they had

Am I wrong about any of that? What do you think?
 
So, I'm wondering: back in the day, were there libraries or other resources used to aide the creation of complicated Mac GUIs? Obviously you could slap together whatever you want in HyperCard or something, but I mean libraries that would have been used with MPW, THINK C, etc
 
Additionally, along those lines, but more modern: Has anyone considered writing a QuickDraw implementation for https://github.com/Immediate-Mode-UI/Nuklear or https://github.com/ocornut/imgui? I think that either would be relatively straightforward. For example the Allegro5 and SDL2 back ends for both libraries have a lot of the same functionality that QuickDraw exposes and these libraries both support the creation of some pretty complicated apps without a lot of the difficult code involved. As an aside, I think there used to be an old SDL1 version that supported PPC Classic MacOS that could likely be backported further as well (see: https://nondisplayable.ca/2017/12/20/sdl-on-classic-mac.html), but I think that just rolling with QuickDraw here would be the way to go and likely more performant.
 
I'm interested in hearing your thoughts on GUI programming for old Macs, things that you've dealt with in your own code, your opinion on why I am wrong about Macintosh Toolbox, opinions on single file C libraries, etc

I'm still interested in others' input, but I think I am pretty set on trying to create a QuickDraw back end for nuklear using the allegro5 back end as a guide. I am going to start looking at this tonight or tomorrow evening. I have some older experience with Alllegro so this seems like a good fit for me. 
 
My intents up front will be:
- Get a POC working as quickly as possible to prove the idea is solid, get the source code online for others to look at.
- only support 1 font up front - loading in other fonts from nuklear would require more complex image rendering that QuickDraw can't provide
- no image support of any kind - again, QuickDraw has limited facilities for handling images, I think PICTv1 only. this could happen in the future maybe, but someone would need to create a function to render at least BMPs using quickdraw (probably pretty easy tbh)
- b&w support only - again, might be easy to use color QuickDraw here, but I am personally more interested in coding for b&w Macs

I made some progress on building a QuickDraw backend for Nuklear (https://github.com/Immediate-Mode-UI/Nuklear) last night and finally got it drawing a UI! Not usable yet but I’m liking where it’s going. I’ve found the “Inside Macintosh: Imaging with QuickDraw” most helpful here so far: https://github.com/CamHenlin/nuklear-quickdraw/tree/messy-but-kinda-working
 
I’ve got it trying to display (and run) a calculator and took a short video. I believe I’ll have it fully functioning soon. Even if it ends up not being entirely useful I’m learning a lot building it out 

I've now got nuklear fully working outside of a few small things and code cleanup  (for test apps anyways, going to start using it to build something more useful soon...) using B&W QuickDraw at https://github.com/CamHenlin/nuklear-quickdraw. I think having a simple immediate mode GUI library is really nice and is going to be an excellent choice for building out small apps for Classic Macs rather than needing to dive in on the toolbox. The UI performance is excellent, with no flicker of any kind and instant response to user input, on the Mac Classic emulator running at standard speed. Using the default system font and standard drawing routines I think also gives things a very "Mac-like" feel.

Yes, I was able to do the same thing. The entire UI is drawn using QuickDraw commands to an offscreen bitmap, then then drawn to the window as a single CopyBits command, much like double buffering in a video game engine. This works really really well and made the UI perform perfectly, eliminated flicker, etc. Like I said the performance here is really, really good. 

It looks and runs pretty good, maybe needs a little tweaking here and there but seems totally acceptable to build an app with, keeping the limitations in mind. The code behind the app demo is really small in terms of what you would expect for such a complicated Mac gui (see: https://github.com/CamHenlin/nuklear-quickdraw/blob/main/overview.c) - some of the features don't quite work correctly or could just be ignored on Mac. Text input isn't perfect, graphs aren't perfect (looking at you axis labels), I don't have images implemented, (but now have myself eyeing adding a B&W PNG decoder to the repo!) etc...
