---
title: Home
nav_order: 1
---

# DCIEM Decompression Model (1973) — Fortran IV transcription

This repository contains a faithful transcription of the DCIEM (Defence and Civil Institute of Environmental Medicine) decompression model programs described in the 1973 report "Digital Computation of Decompression Profiles" (Nishi & Kuehn). The original source was available only as scanned images inside a PDF; the goal of this project is to recover a compilable and runnable version of the 1973 Fortran code.

All example dives in `dives/` reproduce the reference output from the report.

## What's here

- `src/main.f` — Fortran source files transcribed from the 1973 document.
- `dives/` — Input files (and corresponding expected outputs extracted from the report) for several example dives.

For full technical documentation of the model, see the [Technical Reference](Model).

## Run

The original programs read deck-style input describing the dive(s) and options.
This port keeps the same spirit:
```
./run "Impulse Dive - 200ft 30m"
```

## Contributing

Help is very welcome! Suggested ways to contribute:
1. **Spot and fix transcription mistakes.** If a sample differs, isolate the first divergence versus the expected listing in `dives/` and inspect the adjacent code lines for common OCR/copying errors.
2. **Improve portability.** Test with multiple compilers/OSes and propose minimal fixes that don't deviate from the original logic.
3. **Add tests.** Small scripts that run inputs and diff outputs against references are appreciated.

Please open a PR with:
- A clear description of the change,
- The smallest possible diff,
- Before/after output snippets if you're restoring a match to the report.

## Safety disclaimer

This code is a historical and research reconstruction of a 1973 decompression model.
It is not validated for real-world dive planning or life-support decisions. **Do not use it to plan dives.**
