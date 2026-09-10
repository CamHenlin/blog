---
title: Introducing Dangerous Alone
date: 2026-09-09 23:30:00
tags:
    - zelda
    - nes
    - javascript
    - pixi
    - retro
    - multiplayer
    - dev
---

## What is it?

[Dangerous Alone](https://github.com/CamHenlin/Dangerous-Alone) is an unofficial browser engine for *The Legend of Zelda* (NES, 1986). You drop a legally obtained USA NES dump on the window, the engine extracts the cartridge in the browser, and from there it can run the full first and second quests: overworld, labyrinths, caves, combat, items, bosses, saves, and music.

It is not a Nintendo product, it does not include Nintendo assets, and it is not an emulator wrapped in a window. Maps, graphics, and audio come from the ROM you already own. Without that ROM, the window is a dropzone.

What the engine *adds* is a modern play layer around the original game:

- **Split-screen co-op** — one to four players share the same world, each with a full NES-sized camera. Join or leave mid-session. Seats can be in different modes at once (overworld, dungeon, cave).
- **Continuous camera** — walk the overworld and visited dungeon rooms without the original screen-wipe. Unvisited dungeon rooms stay fogged until you enter.
- **Readable story** — expanded NPC, pickup, and labyrinth text in a paged dialogue box, plus map marks for the next dungeon and hinted secrets.
- **Feel tweaks** — arcing sword, integer display scale, keyboard/gamepad rebinding, and browser saves that survive a refresh.

Solo play is meant to stay recognizable. You can [run the engine here](https://camhenlin.github.io/Dangerous-Alone/) or clone the source at [github.com/CamHenlin/Dangerous-Alone](https://github.com/CamHenlin/Dangerous-Alone).

![Four-player split-screen: one seat in a dungeon, one on the overworld, two waiting to join](/images/dangerous-alone.png)

That screenshot is also in the repo: [example.png](https://github.com/CamHenlin/Dangerous-Alone/blob/master/example.png).

## Why this exists

I wanted to play through the original *Legend of Zelda* with my three kids. They pointed out the obvious problem: on a real NES, only one of us gets the controller and everybody else just watches. They figured it would be a lot more fun if we could all be in Hyrule at the same time.

So that became the goal — four seats, four cameras, one shared world. The rest of the quality-of-life work (continuous camera, longer and more coherent story text, rebindable controls) grew out of the same wish: make the 1986 cartridge something a family can play together on the couch today.

In spirit this is to NES *Zelda* what [Ship of Harkinian](https://www.shipofharkinian.com) is to *Ocarina of Time*: an unofficial engine that plays a cartridge you already own, on hardware Nintendo never shipped it for, with extras the original box could not do. The implementation is different — Ship of Harkinian is a native port on a matching decompilation; this repo extracts tables from your dump and reimplements the systems in the browser — but the overall idea is the same.

## What we did not build

The tempting shortcut is to run the ROM in an emulator and draw four copies of the PPU. That would have been playable quickly, and it would have been the wrong project.

An emulator is a 6502, a PPU, and an APU. It is a great development tool — we kept [Mesen](https://github.com/SourMesen/Mesen2) open the whole time — but it cannot give you four independent cameras looking at different rooms of one simulation. It also cannot give you a continuous overworld camera, a paged dialogue box, or a `story/` folder you can edit without reassembling the cartridge.

So the rule we wrote down on day one, and kept:

1. Load world, dungeon, item, and enemy **data from a user-supplied ROM**. No hardcoded dumps in git.
2. Implement play systems in portable JavaScript — collision, combat, secrets, save, UI, audio.
3. Render and mix audio through modern APIs. No 6502 / PPU / APU at runtime.
4. Match the supported cartridge closely enough that the original game is playable through this engine.

Emulators stayed as the reference. The product is the engine.

## The bet

NES *Zelda* is a data-driven game wearing a tiny 6502 costume. Screens are compressed columns of blocks. Dungeons are room templates plus door tables. Enemies spawn from list IDs. Caves are a handful of type bytes plus a text table. If you extract those tables into JSON you own the schema for, you can reimplement the *systems* against that data and verify them against a disassembly.

We followed that path:

1. Extract structured packs from the ROM (maps, tiles, palettes, spawn tables, music sequences).
2. Reimplement overworld, underworld, player, enemies, items, shops, and audio against those packs.
3. Use published disassemblies and Data Crystal maps as the **behavior oracle**, and Mesen as a visual/behavioral reference.

We did not need a byte-identical recompilation of the NES binary. We did need extracted data that matches the ROM, and logic that matches observed behavior.

The cartridge we targeted is USA **PRG1** / NES-ZL-1 (PRG CRC32 `EAF7ED72`). Offsets in community docs are usually PRG-relative; add `+0x10` for iNES file offsets. The extractor refuses the wrong mapper or PRG size.

Prior art we actually used, rather than reinvented:

- [aldonunez/zelda1-disassembly](https://github.com/aldonunez/zelda1-disassembly) — complete buildable ca65 disassembly
- [Computer Archeology — Zelda](https://www.computerarcheology.com/NES/Zelda/) — bank map and boot path
- [Data Crystal ROM map](https://datacrystal.tcrf.net/wiki/The_Legend_of_Zelda/ROM_map) and [Dungeon Data](https://datacrystal.tcrf.net/wiki/The_Legend_of_Zelda/Dungeon_Data)
- [RHDN column/screen docs](https://www.romhacking.net/documents/845/)
- Mesen / FCEUX for CHR viewing and RAM watch

## How we worked

The whole project was planned as **vertical slices**. Each phase had to end with something runnable or a verifiable artifact. We did not try to reverse the whole ROM before writing an engine.

That sounds obvious. It is also the only reason this shipped. The first playable thing is not "Hyrule." It is Link walking on the starting screen with collision that matches the original within a few pixels. Then you can walk to Level 1. Then you can swing a sword. Then you can clear Level 1. Then you can finish Quest 1. Then you can start arguing about cameras.

The engineering handbook lives in [`DEV.md`](https://github.com/CamHenlin/Dangerous-Alone/blob/master/DEV.md). Living checklists live in [`docs/phases/`](https://github.com/CamHenlin/Dangerous-Alone/tree/master/docs/phases). Cross-cutting rules live in a [behavior oracle](https://github.com/CamHenlin/Dangerous-Alone/blob/master/docs/behavior-oracle.md) — things like bomb fuse frames, sword knockback, and which foes count toward room clear. If a behavior had to match the NES, it got a row. If we were going to diverge on purpose, that got a row too.

The stack is boring on purpose: vanilla JavaScript (ES modules), PixiJS v8 for the 256×240 stage, Web Audio for sequenced music and SFX, Vite for the play client, Node for extractors and tests. One language across tools and engine. No game framework, because we did not want to fight Phaser over NES collision and timing.

Fidelity was earned with tests, not vibes:

- Extractor tests against table hashes (fixtures stay private; CI has no ROM).
- Unit tests for collision helpers, column expansion, damage tables, shop prices, story charset, etc.
- A headless play sim (`playSim.js`) that can be stepped with no Pixi, no `window`, and a rolling hash of every frame. Hashing only the final state once passed a deliberately broken build where the sword landed a frame late — the Octorok still died. The trajectory hash caught it.
- A Playwright harness over the real client for the orchestration the Node sim cannot reach.
- Side-by-side with Mesen when hunting a specific bug.

We also used coding agents heavily. The phase markdown was the contract: an agent would pick up a phase, implement against the checklist, keep `npm test` green, and leave notes in the phase file (offsets, decisions, the weird NES behaviors). That is why the repo is full of small modules with sharp edges — `collision.js`, `mazes.js`, `spawn.js`, `storyText.js` — instead of one 20,000-line play loop. The play loop is still large. The things you can prove things about are not.

Nintendo assets never go in git. `.gitignore` covers the ROM, `assets/extracted/`, the manual, and the walkthrough. CI builds with no cartridge. In the browser, extraction happens on the device; the file is never uploaded.

Calendar-wise this ran from early August through early September 2026: data and a completable game first, then a fidelity pass, then the quality-of-life and multiplayer work the kids actually asked for.

## The phases

There were 22 numbered phases plus a thorough review. They group into five jobs.

### Phases 0–4 — make the cartridge into data

Phase 0 was hygiene: identify the dump, ignore it in git, clone the disassembly under a gitignored `reference/` folder, install Mesen.

Phase 1 was a bank splitter. USA Zelda is MMC1, 8 × 16 KiB PRG, bank 7 fixed at `$C000–$FFFF`. `npm run extract -- info` prints the PRG hash; `banks` writes eight files whose CRC32s we pinned.

Phase 2 decoded NES 2bpp pattern tables into PNG sheets and palettes. Zelda stores patterns in PRG and copies them into CHR-RAM, so you follow the bank loads the game uses, not a CHR ROM that does not exist. A tiny Pixi tile viewer let us confirm bushes, water, dungeon walls, and Link frames before anyone walked.

Phase 3 extracted the overworld: 16×8 = 128 screens, each an arrangement byte pointing at 16 compressed columns of 11 squares, each square a 2×2 of CHR tiles, plus attribute tables for palettes, Zora, caves, enemies, secrets, and exits. The stitched map had to look like Hyrule. A `map.html` viewer let us click a screen and see why.

Phase 4 did the same for underworld levels 1–9, both quests: room templates, doors, items, LevelInfo blobs, palettes. `dungeon.html` is the sibling viewer.

At the end of this block we still did not have a game. We had a cartridge we could look at.

### Phases 5–12 — make it a game

Phase 5 was the first playable slice: Vite + PixiJS, internal 256×240, integer scaled, Link on start screen `$77` at the ROM spawn (`X=$78`, `Y=$8D`), 1.5 px/frame, NES walkable-tile collision. Edges clamped. No enemies, no HUD that meant anything. You could walk around the rocks you spawn between.

Phase 6 made the overworld traversable: screen transitions, warp tiles into caves and dungeon stubs, a HUD. The walk to Level 1 is north four screens from start, stand on the tree mouth.

Phase 7 was Link as a verb: wood / white / magic sword timings and damage from the disassembly, bombs, inventory, knockback, invuln frames, hearts as half-hearts, rupees / keys / bombs on the HUD.

Phase 8 was enemies. Spawn tables per screen, then families: Octoroks and rocks on the overworld, Keese / Gel / Goriya / Stalfos / Wallmaster / Aquamentus in Level 1. Room-clear shutters. The bow in Level 1's item room. The "done when" for this phase was clearing Level 1 end-to-end.

Phase 9 turned dungeons into a system: keys, shutters, bombable walls, push blocks, dark rooms, candles, cellars, maps and compasses, Ganon and Zelda, Quest 2 dungeon packs. Quest 1 became completable.

Phase 10 was the overworld progression graph people actually get stuck on: shops, gambling, clue caves, sword caves with heart gates, the letter and potion shop, burn / bomb / push / recorder secrets. A blind playthrough had to be able to get the swords and required items without cheats.

Phase 11 was audio without an APU. We extracted the game's own sequence data from Bank 0 and replayed it through Web Audio with square / triangle / noise approximations. Overworld playlist, dungeon theme, item fanfares, sword and hurt SFX, mute and volume. Tone is approximate; notes and timing are from the ROM.

Phase 12 was the daily-driver 1.0: title and file select with three slots, SRAM-shaped saves in `localStorage`, options (scale, fullscreen, rebind), inventory layout matching the original, a minimap with a player dot, CI with no ROM.

At this point you could play the game. It still screen-wiped. It was still one player. The old man still spoke in 1986 telegram.

### Phases 13–17 — make it match

A thorough review compared `tools/shared/`, `game/src/`, and the extractors against the ca65 disassembly, with a local walkthrough as playability context. Every item cited a ROM label. Community lore that did not match the disassembly got rejected, not implemented.

That audit is why Lost Woods and Lost Hills exist as `CheckMazes`, why attract mode and the death / continue menu and the ending exist, why registering the name `ZELDA` unlocks Quest 2, why Gohma only dies through the eye, why Like-Likes steal the magic shield, why Wallmasters send you back to the dungeon entrance.

Phases 13–17 were that work plus stretch systems: raft and ladder, flute, sword beam, Magical Rod, Moldorm, Lamnola, whirlwind, boss AI for Manhandla / Gleeok / Patra, Quest 2 overworld. The behavior oracle grew to well over a hundred rules. Where we diverged, we wrote it down (Web Audio instead of a cycle-accurate APU; an arcing sword later; B-item select that is a little more convenient than 1986).

### Phases 18–21 — make it nicer to sit with

Phase 18 replaced the NES screen-wipe on the overworld and in visited dungeon rooms with a camera that follows Link and streams neighbor tiles and enemies as they come into view. Hard cuts stayed for caves, dungeon enter/exit, cellars, raft, whirlwind, and death. Unvisited dungeon rooms draw black fog. Link's sword started swinging on an arc, closer to *Link's Awakening* than to the original jab.

Phase 20 existed because Phase 18 broke four assumptions that were only true on a single screen. Enemy sprites outlived their enemies (a 4,200-frame walk left 45 orphaned pictures and 8 live foes). One monster table served a whole neighborhood of rooms, so you could starve a screen of slots. Collision was sampled against the anchor room's grid while Link's pixel position had already crossed a seam, which is how you walk into a tree that is visually in the next screen. Cave mouths and shutter triggers were still "are you on this screen," which is a different question from "are you standing on this tile in a camera that spans two rooms." Streaming cleanup was a phase because those bugs were not one-liners.

Phase 19 built a paged, typewriter dialogue box and a `story/` folder. Phase 21 filled it in: prologue, pickups, labyrinth briefings, an ending that pays off the story the rest of the text tells, and map marks for the next dungeon and hinted secrets. The pack keeps one name per thing so a nine-year-old never has to decide whether two words mean the same object. The box draws with the NES background charset — `A–Z`, digits, and a handful of punctuation — and `npm test` fails on a character the font cannot draw.

The story files are ordinary JavaScript. Edit them, reload, no re-extract. Delete an entry and you get the 1986 line back, except for item pickups, which the NES never narrated at all.

### Phase 22 — make it a party

Every phase until this one assumed one hero. `main.js` had closure-local `link`, `inv`, and `sword`, with well over a thousand references. The shared helpers were already parameterized (`stepLink(link, …)`), but they were parameterized for *the* hero, not *a* hero.

Three decisions were made before the code:

1. Two or more players grow the frame so each quadrant is a full-size NES view. Solo never pays for the larger canvas.
2. Players are fully independent and may be in different modes at the same time.
3. There is still one simulation. Four cameras draw it.

The work that made that possible, in order:

**A sim you can prove things about.** Lift the step out of the Pixi closure. Golden hashes over the trajectory. Solo goldens had to stay on the same traces through the whole plural-hero refactor. If `players.length === 1` ever behaved differently from the original one Link, we stopped and fixed that first.

**A roster, not a rewrite.** The first player record holds the same objects the old locals pointed at, so existing references kept working while the structure went in around them. World context (`mode`, `roomId`, `screen`, `dungeon`) is not threaded through 600 call sites. A `playerFocus` module says *whose* those variables are for this frame. Copying happens when focus moves, not every frame — the first attempt saved and loaded every frame and hung the boot path, because `startGame()` sets `mode` from outside any frame.

**Shared purse, private hearts.** Items, quest flags, rupees, keys, bombs, and dungeon progress are shared. Hearts, knockback, B-slot, and death are per player. The clock is shared because it freezes enemies and the enemies are global. That split is an inventory-shaped view over two objects, not a signature change through 200 call sites.

**Join on Start, leave with Start+Select.** Two keyboard bind sets so two people can play with no gamepads. Spare pads join instead of stealing player one's inventory. Empty quadrants say `PRESS START TO JOIN`. Dropping back to one player puts the ROM frame back on the stage.

**One playfield, several pictures.** At two or more players the same scene graph is rendered into a texture per camera. Streaming and culling answer to every camera. Two labyrinths do not share a room store; four people in the same overworld screen share one stream, because four copies of the same tiles would be four times the work for the same picture. The other Links in your quadrant get a player number over their head. Yours does not.

Solo still looks like the 1986 game plus the QoL we already shipped. That was the constraint that made the rest of this phase take as long as it did.

## A few things that surprised me

**The overworld is a compression format, not a map.** Once you have columns → squares → tiles, stitching 128 screens is the easy part. The hard part is every table that sits *on* those screens: enemy groups, secret flags, cave IDs, dock heart, recorder secrets. Getting the map picture right in week one hid about two weeks of "why can't I enter this cave from this pixel."

**NES collision is a hotspot, not a sprite box.** Link's walkable probe is not his drawn rectangle. Ground enemies use a different probe. Keese ignore tiles. Continuous camera made that painfully obvious, because the probe and the art can be in different rooms.

**Room clear is a policy, not "all sprites dead."** Bubbles and traps do not count. Ringleader rooms care about slot 1. Last-boss rooms care about a flag. Carry that policy into multiplayer and you have to decide whether *your* clear is *the* clear. The world is shared, so it is.

**Determinism is a feature you implement.** The browser goldens needed `?debug=1&pause=1` so the loop stopped advancing on wall-clock time, a seeded RNG for edge spawns, and draining in-flight room loads at each frame boundary. Without those, "same inputs" is a wish.

## How to try it

You need a legally obtained *The Legend of Zelda* USA NES dump (iNES `.nes`). Nothing is uploaded; the file stays in your browser.

**On the web:** [camhenlin.github.io/Dangerous-Alone](https://camhenlin.github.io/Dangerous-Alone/). Drop the ROM and wait for extract. Clearing site data removes the ROM (saves live in the same browser storage). `play.html?resetRom=1` forgets the dump without wiping save slots.

**On your machine:**

```bash
git clone https://github.com/CamHenlin/Dangerous-Alone.git
cd Dangerous-Alone
npm install
npm run dev
# open http://localhost:5173/play.html
```

File select: ↑↓ slot · Enter continue/new · N rename · R register/overwrite · E erase · O options.

In play: Arrows/WASD move · Z/Space sword · X/C B-item · Tab cycle item · Enter inventory · H / spare Start joins a second player · F5/F9 practice · M mute · ,/. volume.

Progress autosaves to this browser. Options cover scale, fullscreen, and per-player keyboard/gamepad binds.

## What is still rough

The game is 100% playable. The bugs that remain do not massively impact the experience, but they are real:

- Small collision errors at times, usually making Link not fully align to paths. Mostly visual.
- Some enemies do not behave as they are supposed to. Dodongos, for example, eat bombs much more easily than they should.
- Second quest text is a bit incoherent, because it reuses story text from the first quest.

If you notice others, open a GitHub issue with screenshots and a detailed description.

## Legal

This project ships engine code, not a cartridge. You bring a NES Zelda ROM you own. Nintendo owns *The Legend of Zelda*. Naming it here only describes which cartridge this engine understands. Personal / educational use with a ROM in your possession.

## Links

- [GitHub: CamHenlin/Dangerous-Alone](https://github.com/CamHenlin/Dangerous-Alone)
- [Play it in the browser](https://camhenlin.github.io/Dangerous-Alone/)
- [Example screenshot](https://github.com/CamHenlin/Dangerous-Alone/blob/master/example.png)
- [DEV.md — architecture, extract CLI, phases](https://github.com/CamHenlin/Dangerous-Alone/blob/master/DEV.md)
