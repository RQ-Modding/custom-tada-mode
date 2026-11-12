# Changelog

Each section is a version of the mod, the `version` in `mod.json`. The release workflow copies the
section of a tagged version into the release notes.

## 1.2.0

- One multiplier for each thing TADA mode changes: battle gold, battle EXP and familiar growth, each
  a number from 1 to 100 on the Mods tab page (the game's own is 2 for all three).
- The first start of 1.2.0 gives the one number of 1.1 to each of the three, so your setting carries
  over.
- If the game's code lacks one of the three places, only that row is greyed.

## 1.1.2

- The page reads TADA mode with the loader's `rq.game.mode()` instead of the game's flag. Needs loader
  2.36.0. No change in the game.

## 1.1.1

- The Config page is built with the loader's `rq.config.settings`: the same number field, kept under
  the same key, and a **Reset** button that puts back 2. Needs loader 2.35.0.

## 1.1.0

- The multiplier is on the mod's page in Config's Mods tab, a number field from 1 to 100, and a
  change counts from the next fight with no restart. It is kept for every save.
- `config.ini` is gone: the first start reads 1.0.0's file once, so a number set there carries over.
- Needs loader 2.22.0 (`rq.uikit.stepper`, the places of `rq.ain.patch_int_after` and
  `rq.ain.set_code_int`).

## 1.0.0

First version.

- `config.ini` sets how many times TADA mode multiplies battle gold, battle EXP and familiar growth
  (the game's 2). A value the mod cannot use warns on screen at start and keeps 2.
