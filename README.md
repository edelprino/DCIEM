# DCIEM Decompression Model (1973) — Fortran IV transcription

This repository contains a faithful transcription of the DCIEM (Defence and Civil Institute of Environmental Medicine) decompression model programs described in the 1973 report “Digital Computation of Decompression Profiles” (Nishi & Kuehn). The original source was available only as scanned images inside a PDF; the goal of this project is to recover a compilable and runnable version of the 1973 Fortran code.

> ⚠️ Work in progress (WIP). Only the first example dive in dives/ reproduces the reference output. The other examples currently produce different results, which indicates that transcription mistakes still remain and need to be fixed. Contributions are welcome (see below).

## What’s here
	•	src/ — Fortran source files transcribed from the 1973 document.
	•	dives/ — Input files (and corresponding expected outputs extracted from the report) for several example dives.

## Background

The code implements the Kidd–Stubbs decompression model using a 4-compartment series system and computes safe ascent depths using a pressure-dependent supersaturation ratio. The original programs were written in Fortran IV and ran on a PDP-9 system. This repository aims to preserve the original structure while making the code buildable with modern compilers.

## Changes from the 1973 source

Because the PDF contains scanned images of line-printer listings, several minimal edits were required to compile with a modern Fortran compiler:
	1.	Removal of Hollerith constants.
Legacy Hollerith constants such as 5HNLDIV, 4H SRC, etc., are not supported today. They’ve been replaced with standard character strings (e.g., 'NLDIV', ' SRC') and corresponding I/O statements have been adjusted.
	2.	File I/O portability.
The original code references system-specific file macros/routines (e.g., PDP-9 file management calls visible in the listing). These are replaced with standard Fortran OPEN/READ/WRITE/CLOSE (and INQUIRE where needed). Paths and unit numbers are configurable; see comments in the source.

Apart from the items above, the intent is to keep the code as close as possible to the 1973 listing (labels, fixed form, flow, and numerical method).

## Run

The original programs read deck-style input describing the dive(s) and options. This port keeps the same spirit:
```
./run "Impulse Dive - 200ft 30m"
```


## Contributing

Help is very welcome! Suggested ways to contribute:
	1.	Spot and fix transcription mistakes.
If a sample differs, isolate the first divergence versus the expected listing in dives/ and inspect the adjacent code lines for common OCR/copying errors.
	2.	Improve portability.
Test with multiple compilers/OSes and propose minimal fixes that don’t deviate from the original logic.
	3.	Add tests.
Small scripts that run inputs and diff outputs against references are appreciated.

Please open a PR with:
	•	A clear description of the change,
	•	The smallest possible diff,
	•	Before/after output snippets if you’re restoring a match to the report.


## Safety disclaimer

This code is a historical and research reconstruction of a 1973 decompression model.
It is not validated for real-world dive planning or life-support decisions. Do not use it to plan dives.
