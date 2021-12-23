---
title: Profiling your Retro68 application
date: 2021-12-21 11:08:51
tags:
---
https://github.com/CamHenlin/serialperformanceanalyzer

When moving [Nuklear]() to Macintosh, it became apparent that there would be a lot of performance optimization work necessary to provide a usable GUI experience on an 8MHz Macintosh. To make the situation worse, there is no profiling tooling available for Retro68, and no way as far as I could tell to run some kind of code profiler against the pce-macplus emulator, so I came up with a simple library for profiling code over a serial port via simple function calls.