# DCIEM Decompression Model (1973) — Fortran IV transcription

A faithful transcription of the DCIEM decompression model programs from the 1973 report "Digital Computation of Decompression Profiles" (Nishi & Kuehn).

**[Full documentation](https://edelprino.github.io/DCIEM/)**

## What's here

- `src/main.f` — Fortran source files transcribed from the 1973 document.
- `dives/` — Input files (and corresponding expected outputs extracted from the report) for several example dives.

## Run

The original programs read deck-style input describing the dive(s) and options.
This port keeps the same spirit:
```
./run "Impulse Dive - 200ft 30m"
```

## Safety disclaimer

This code is a historical and research reconstruction of a 1973 decompression model.
It is not validated for real-world dive planning or life-support decisions. Do not use it to plan dives.
