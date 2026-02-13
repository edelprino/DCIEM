# DCIEM Decompression Model — Technical Reference

This document consolidates all information from the 1973 DCIEM Report No. 884,
"Digital Computation of Decompression Profiles" by R.Y. Nishi and L.A. Kuehn.
The original report is available only as a poorly scanned PDF; this reference
is intended to replace it for development purposes.

---

## 1. Background

The Kidd-Stubbs pneumatic analogue decompression computer is used for
real-time prediction of the safe ascent depth following an excursion to depth.
The theoretical model derived from this computer can be solved numerically on a
digital computer. The report describes a series of Fortran IV programs written
for a PDP-9T system at DCIEM (Defence and Civil Institute of Environmental
Medicine, 1133 Sheppard Avenue West, Downsview, Ontario).

References cited in the report:

1. Weaver, R.S., and Stubbs, R.A. "The transient response of an M-loco series
   filter system with special application to the decompression problem in man —
   Non-linear model." DRET Report No. 674, September 1968.
2. Weaver, R.S., Kuehn, L.A. and Stubbs, R.A. "Decompression calculations:
   Analogue and digital methods." DRET Report No. 703, May 1968.
3. Modern Computing Methods, Notes on Applied Science No. 16. National Physical
   Laboratory, Teddington, Middlesex, 1961.

---

## 2. Theory

### 2.1 The Four-Compartment Series Model

The model consists of four compartments connected in series by pneumatic
resistor elements. It is an analogue of the gas transfer characteristics of
body tissues during compression and decompression. The equations of gas flow
between compartments are non-linear and cannot be explicitly solved; they
require numerical analysis.

The absolute pressures in the four compartments are expressed by four
non-linear first-order differential equations describing gas dynamics in the
"slip-flow" regime:

    dPj/dt = {aj (Bj + Pj + Pj-1)(Pj-1 - Pj)
             - aj+1(Bj+1 + Pj+1 + Pj)(Pj - Pj+1)} / Vj

where:
- j = 1, 2, 3 or 4 (compartment number)
- Pj, Vj are the absolute pressure and volume of the jth compartment
- Pa is the ambient or driving pressure (input to the model)
- aj, Bj are flow constants of the jth resistor
- P0 = Pa (ambient pressure) and P5 = 0

### 2.2 Flow Constants

The constant `a` is defined by:

    a = a0 (Nd^2L) / 4

where:
- N is the number of pores in the resistor material
- L is the mean length of the porous sample in the direction of flow
- d is the mean pore diameter (assuming circular cross-section)
- eta is the viscosity of the gas

The value of `a` may be determined by measuring the steady state gas flow
through the pneumatic resistor and by recourse to the following equation:

    a = P_A / (T_A * delta_P (B_0 + delta_P + 2P_A))

where:
- P_A is the atmospheric pressure
- T_A is the time required for 1 cm^3 of gas to flow through the resistor
- delta_P is the "driving" pressure differential across the resistor

The flow constant B is defined by:

    B = B0 (T * sqrt(pi*M) / d)

where:
- T is the absolute temperature of the gas
- M is the molecular weight of the gas

### 2.3 Half-Times and Resistor Properties

The half-time T_h of a resistor-volume combination is defined as the time
required for the compartment pressure to decrease from a value of P_i to
(P_i + P_f)/2. It can be expressed as:

    T_h = V / (a(B+3P_f)) * ln[(2B + 3P_i + P_f) / (B + P_i - P_f)]

For this decompression model, the half-time is specified for a compartmental
pressure decrease from 50 psig to 25 psig.

**Table 1 — Values of a, B, and T_h for several gases and gas mixtures**
(pertinent to a pneumatic resistor with a mean pore diameter of 0.125 um):

| Gas          | M    | T_h (minutes) | V (c.c.) | a (x10^-3) | B     |
|--------------|------|---------------|-----------|------------|-------|
| O2           | 32   | 22.4          | 28.9      | 4.575      | 130.2 |
| 20/80 O2/N2  | 28.4 | 20.8          | 25.9      | 5.133      | 122.3 |
| N2           | 28   | 20.4          | 28.9      | 5.309      | 119.9 |
| 20/80 O2/He  | 9.6  | 14.4          | 28.9      | 8.725      | 230.2 |
| 10/90 O2/He  | 6.8  | 12.5          | 28.9      | 4.740      | 272.5 |

### 2.4 Pressure-Time Relation

The pressure-time relation for transient flow of gas through a
resistor-volume combination is:

    t = V / (a(B+3Pf)) * ln[(Pf - Pi)(B + Pi + Pf) / ((Pf - Pt)(B + Pt + Pf))]

where:
- a, B are flow constants of the resistor
- V is the compartment volume
- P_i is the initial compartment pressure at t = 0
- P_t is the compartment pressure at time t
- P_f is the final compartment pressure

---

## 3. Numerical Analysis

### 3.1 Runge-Kutta Method

The differential equations are solved using a 4th-order Runge-Kutta method
due to Gill (Reference 3), characterized by the first dependent variable:

    y(n+1) = y(n) + (k1 + 2(1 - 1/sqrt(2))k2 + 2(1 + 1/sqrt(2))k3 + k4) / 6

where h is the step size and:

    k1 = h * f(x_n, y_n)
    k2 = h * f(x_n + h/2, y_n + k1/2)
    k3 = h * f(x_n + h/2, y_n + (sqrt(2)-1)/2 * k1 + (1 - (sqrt(2)-1)/2) * k2)
    k4 = h * f(x_n + h, y_n - k2/sqrt(2) + (1 + 1/sqrt(2)) * k3)

This method is applied to all four dependent variables (compartment pressures).

### 3.2 Runge-Kutta Constants

The program uses pre-calculated constants derived from sqrt(2) = 1.414213562:

| Constant | Value         | Derivation                    |
|----------|---------------|-------------------------------|
| Z1       | 0.207106781   | (sqrt(2) - 1) / 2            |
| Z2       | 0.292893219   | 1 - 1/sqrt(2) = 1 - Z3       |
| Z3       | 0.707106781   | 1/sqrt(2)                     |
| Z4       | 1.707106781   | 1 + 1/sqrt(2) = 1 + Z3        |
| Z5       | 0.585786438   | 2 - sqrt(2)                   |
| Z6       | 3.414213562   | 2 + sqrt(2)                   |

The final update formula in the code is:

    P(I) = P(I) + (AK(1,I) + Z5*AK(2,I) + Z6*AK(3,I) + AK(4,I)) / 6

The function evaluated at each stage is:

    F(I) = A * (X - Y) * (B + X + Y)

where X is the pressure of the upstream compartment (or ambient pressure for
compartment 1) and Y is the pressure of the current compartment. This
implements the non-linear slip-flow gas transfer equation.

### 3.3 Safe Ascent Criterion

After the four compartment pressures are calculated, the safe ascent depth
for decompression is determined from the greatest of these pressures divided
by a supersaturation ratio. The supersaturation ratio is defined by:

    K_T = P_T / D_SA

where:
- P_T is the greatest absolute compartment pressure
- D_SA is the pressure to which ascent may be made safely

Experiments involving more than 4000 man-dives at DCIEM to depths as great
as 300 ft of seawater have indicated that K_T can be expressed as:

    K_T = 1.385(1 - 17.7/P_T)

That is, K_T varies as a function of the absolute pressure. This is the
"pressure-dependent supersaturation ratio."

**Table 2 — Pressure-Dependent Supersaturation Ratio:**

| P_T (ft sw) | P_T - P_A (ft sw) | D_SA (ft sw) | K_T  |
|-------------|-------------------|--------------|------|
| 33          | 0                 | -19.07       | 2.37 |
| 59.4        | 26.4              | 0            | 1.80 |
| 99          | 66                | 28.6         | 1.61 |
| 132         | 99                | 52.4         | 1.55 |
| 165         | 132               | 76.2         | 1.51 |
| 198         | 165               | 100.1        | 1.49 |
| 231         | 198               | 123.9        | 1.47 |
| 264         | 231               | 147.7        | 1.46 |
| 297         | 264               | 171.5        | 1.45 |
| 330         | 297               | 195.4        | 1.445|
| 363         | 330               | 219.2        | 1.44 |

The safe ascent depth in gauge pressure, D_SA, can be determined from:

    D_SA = P_T / K_T - P_A

where P_A is the barometric pressure at the water surface. Expressed in feet
of seawater (where P_A = 33 ft abs.):

    D_SA = P_T / 1.385 - 42.9

This is the formula used in the code as `GBIG(I) = P(I)/R - 42.9` where
R = 1.385.

### 3.4 Altitude Calculations

For altitude calculations, the safe ascent altitude in thousands of feet is:

    W = 145.53 * (1 - (PBIGK/33)^0.1903)

This converts the safe ascent pressure to equivalent altitude above sea level,
using the standard atmosphere pressure-altitude relationship.

---

## 4. Program Variants

The report describes several programs, all sharing the same Runge-Kutta
integration method and safe ascent criterion:

### Identical Compartment Programs

All compartments and pneumatic resistors are identical in these programs.

| Program | Description                                           |
|---------|-------------------------------------------------------|
| D6S     | Basic model with ramp descent and altitude calculations. Source listing in Appendix 1. |
| D6SA    | Abbreviated D6S without altitude calculations. Allows teletype, line printer, or disk output. |
| M6S     | Like D6S but with variable descent rate (staircase approximation). |
| M6SA    | Like D6SA but with variable descent rate.             |
| D6ST    | Dive table analysis: constrains the model to follow a stop decompression profile. Uses RDES and RASC for ascent/descent between stops. Source not in report; described in text only. |

### Non-Identical Compartment Programs

Each resistor-volume compartment can have different parameters.

| Program  | Description                                          |
|----------|------------------------------------------------------|
| D6SVA    | Specification in terms of a, B, and V.               |
| D6SVA1   | Specification in terms of T_h, T_h, and B.           |
| D6SVA2   | Specification in terms of V, T_h, and B.             |

### Online Programs

| Program  | Description                                          |
|----------|------------------------------------------------------|
| DIVER    | Real-time hyperbaric chamber monitoring. Source in Appendix 2. |
| DIVER1   | Abbreviated DIVER output.                            |
| DIVER2   | Like DIVER1 with DICTAPE output.                     |

### Other

| Program  | Description                                          |
|----------|------------------------------------------------------|
| D6SAC2   | Modified D6SA for changes in atmospheric pressure. Uses B' = B + 2P_A and D_SA = T_DST/(0.574 * P_A), where P_A is barometric pressure. |
| D6SMC    | Modified D6SA for up to nine identical compartments. Number of compartments entered as two-digit number after R in input. |
| D6SAT    | Combination of D6SA and D6ST for series of standard dives at same depth but different times. |

---

## 5. D6S Program — Detailed Reference

This is the main program transcribed in `src/main.f` (Appendix 1 of the report).

### 5.1 KEY Options

The KEY integer (first field of the input file) selects the dive mode:

| KEY    | Mode                                                      |
|--------|-----------------------------------------------------------|
| 00     | Standard dive: descent at constant rate (RDES), ascent governed by safe ascent criterion. |
| 04     | Impulse dive: step impulse of pressure at time zero, maintained for a duration, then instantly returned to sea level. Used for calibration of pneumatic decompression computers. |
| 05     | Flying after diving: standard dive followed by altitude calculations for 18 hours (1080 minutes) with output every 15 minutes. |
| 10, 20, 30... | Repetitive dive: standard dive, surface interval, then another dive. N = KEY/10 is the number of repetitions. Compartment pressures at end of each dive are initial conditions for the next. |
| *5, 25, 35... | Repetitive dive followed by flying after diving: like repetitive dive, but after the last excursion the safe ascent altitude is calculated. |
| 09     | Terminator: stops the program.                            |

### 5.2 Input File Format (NLDIV.SRC)

The input file uses fixed-format Fortran fields:

**Line 1 — Dive identification:**

| Field   | Format | Description                                          |
|---------|--------|------------------------------------------------------|
| KEY     | I2     | Dive mode selector (see above)                       |
| TITL    | 14A5   | Title string (70 characters, printed as-is)          |

**Line 2 — Model constants:**

| Field | Format | Description                                            |
|-------|--------|--------------------------------------------------------|
| A     | E8.4   | Flow constant of the pneumatic resistor (a)            |
| B     | F5.1   | Flow constant related to gas properties (B)            |
| R     | F5.3   | Dimensionless decompression factor (supersaturation ratio constant) |

For the standard DCIEM model with 10/90 O2/He mixture: A = .7912E-4, B = 274.5, R = 1.385.

**Line 3 — Dive parameters:**

| Field | Format | Description                                            |
|-------|--------|--------------------------------------------------------|
| DTL   | F4.1   | Maximum step time for Runge-Kutta integration (minutes)|
| TMAX  | F4.1   | Maximum length of the computer run (minutes)           |
| PTOUT | F4.1   | Print output interval (minutes)                        |
| RDES  | F4.1   | Descent rate (ft of seawater per minute)               |
| RASC  | F4.1   | Ascent rate (ft of seawater per minute)                |

Note: for impulse dives (KEY=04), RDES and RASC are not used; the format
still requires 5 fields.

**Line 4 — Initial conditions:**

| Field   | Format | Description                                          |
|---------|--------|------------------------------------------------------|
| T       | F5.1   | Initial time                                         |
| G1      | F5.1   | Initial ambient gauge pressure (ft seawater)         |
| G(1..4) | 4×F5.1 | Initial compartment gauge pressures                  |

If G(1) = 0, all four compartments are set equal to G1. Normally all zeros
(diver at surface, tissues equilibrated).

**Line 5 — Bottom time:**

| Field | Format | Description                                            |
|-------|--------|--------------------------------------------------------|
| T     | F5.1   | Time at which the diver begins ascent (absolute, includes descent time) |
| G1    | F5.1   | Bottom gauge pressure (depth in ft of seawater)        |

If a stop or delay is desired during descent on a standard dive, additional
T, G1 lines can be inserted immediately below line 5 in the same format.

**Line 6 — Terminator:**

    -T     (any negative T value ends the dive phase)

**Lines 7-9 — Repetitive dive only (KEY >= 10):**

| Field | Format | Description                                            |
|-------|--------|--------------------------------------------------------|
| TTOP  | F5.1   | Duration of surface interval (minutes)                 |

Lines 7 (`TTOP`), 8 (`T, G1` for next dive), and 9 (`-T`) can be repeated
for the number of dives specified by KEY/10.

**Last line — Next dive or terminator:**

    09     (KEY = 09 terminates the program)

### 5.3 D6ST Extensions (Dive Table Analysis)

For dive table analysis, additional lines after the bottom time specify
decompression stops. The descent and ascent rates between stops are
established by RDES and RASC:

    T, G1      (bottom time at maximum depth — absolute time)
    T, G1      (duration at first stop, gauge pressure of stop)
    T, G1      (duration at second stop, gauge pressure of stop)
    ...
    T, G1      (duration at last stop, gauge pressure of stop)
    -T
    09

The time at which the pressure maximum is reduced (bottom time) includes the
descent time. The duration at each stop does NOT include the ascent time
between stops — it is the time spent at the stop depth only. The program
converts these durations to absolute times internally.

If the safe ascent depth has not reached sea level at the termination of the
last stop, the program continues to calculate the safe ascent depth until
sea level is reached (continuous controlled ascent).

### 5.4 Output File Format (NLDIV.LST)

The output file contains:

1. Title line (from input, with Fortran carriage control character '1')
2. Model parameters: A, B, R, DTL
3. For non-impulse dives: ASC and DESC rates
4. Column headers
5. Data rows with the following columns:

| Column              | Description                                          |
|---------------------|------------------------------------------------------|
| TOTAL DIVE TIME     | Elapsed time in minutes (TT)                         |
| ACTUAL DEPTH        | Current depth in ft of seawater (GB = W - 33)        |
| ALTITUDE / (1000 FT)| Controlling compartment number K (1-4), or altitude when KTEST is true and GBIG(K) < 0 |
| 1, 2, 3, 4         | Safe ascent depths for each compartment (GBIG(I) = P(I)/R - 42.9) |

The "ACTUAL DEPTH" column shows:
- P1 - 33 during descent, bottom time, and standard ascent
- PBIGK - 33 during continuous controlled ascent (when C = .TRUE. and T < 0)

---

## 6. Code Structure and Control Flow

### 6.1 Variables

| Variable     | Type    | Description                                        |
|--------------|---------|----------------------------------------------------|
| P(4)         | REAL    | Absolute compartment pressures (gauge + 33)        |
| G(4)         | REAL    | Gauge compartment pressures                        |
| GBIG(4)      | REAL    | Safe ascent depth for each compartment             |
| AK(4,4)      | REAL    | Runge-Kutta intermediate coefficients              |
| F(5)         | REAL    | Function values for RK (F(5)=0 for last compartment) |
| P1           | REAL    | Current ambient absolute pressure                  |
| PBIGK        | REAL    | Greatest safe ascent absolute pressure (GBIG(K)+33)|
| K            | INTEGER | Controlling compartment (deepest required stop)    |
| TT           | REAL    | Current simulation time                            |
| DT           | REAL    | Current Runge-Kutta step size                      |
| DTL          | REAL    | Maximum step time (from input)                     |
| DTI          | REAL    | Fine step time = DTL * 0.1                         |
| NS           | INTEGER | State variable for computed GOTO routing (1-5)     |
| NS2          | INTEGER | Sub-state for repetitive dive routing (1-2)        |
| NS3          | INTEGER | Output routine return dispatch (1-5)               |
| C            | LOGICAL | TRUE during continuous controlled ascent            |
| KTEST        | LOGICAL | TRUE when altitude calculations are needed         |
| PMIN         | REAL    | Minimum pressure threshold (0 during dive, 33 during ascent) |
| KPT          | INTEGER | Flag: 1 when in controlled ascent (resets DT to DTL) |
| PLAST        | REAL    | P1 at last entry to label 11 (for step size control) |
| TTEST        | REAL    | TT modulo PTOUT (for output timing)                |
| TL           | REAL    | Target time minus 0.01 (for time comparison)       |

### 6.2 NS Routing (label 32 computed GOTO)

The computed GOTO at label 32 dispatches based on NS:

| NS | Target | Phase                                               |
|----|--------|-----------------------------------------------------|
| 1  | 56     | Descent (or ascent between stops): P1 ramping       |
| 2  | 10     | Impulse ascent: P1 at sea level, integrating        |
| 3  | 18     | Standard ascent to first stop: P1 decreasing by RASC|
| 4  | 17     | Continuous controlled ascent: P1 = PBIGK            |
| 5  | 57     | At constant depth: P1 stable                        |

### 6.3 NS3 Routing (label 44 computed GOTO)

The computed GOTO at label 44 dispatches after the output print routine:

| NS3 | Target | Context                                             |
|-----|--------|-----------------------------------------------------|
| 1   | 11     | Normal: go read next step time / check time          |
| 2   | 32     | After periodic output: return to main dispatch       |
| 3   | 33     | Dive complete: test for repetitive/flying options    |
| 4   | 10     | Enter Runge-Kutta after controlled ascent output     |
| 5   | 25     | Initial setup: go to PMIN/KPT initialization         |

### 6.4 Label Map

| Label | Location            | Purpose                                    |
|-------|---------------------|--------------------------------------------|
| 1     | Main loop start     | Read KEY and TITL                          |
| 2     | Header output       | Write title and parameters                 |
| 6     | Initial conditions  | Read T, G1, G; initialize compartments     |
| 25    | Dive start          | Set PMIN=0, KPT=0                          |
| 11    | Step reader         | Read next T, G1; setup descent/ascent      |
| 56    | Descent check       | Branch: descend (58), ascend (55), or snap (59) |
| 59    | Snap to depth       | P1 = G1+33, NS=5                          |
| 55    | Ascent step         | P1 -= RASC*0.1 (D6ST extension)           |
| 58    | Descent step        | P1 += RDES*0.1                             |
| 57    | Step size control   | Set DT=DTI if P1 changed                  |
| 19    | Time check          | If TT < TL, continue integration          |
| 43    | Output trigger      | NS3=1, go to output                        |
| 10    | Runge-Kutta entry   | Begin RK integration step                  |
| 22    | RK completion       | Update GBIG, PBIGK, TT; check output timing |
| 32    | Main dispatch       | Route based on NS                          |
| 30    | Output routine      | Print current state                        |
| 38    | Write statement     | (label exists but never jumped to)         |
| 44    | Output return       | Route based on NS3                         |
| 12    | Dive end            | PMIN=33, branch to ascent type             |
| 13    | Standard ascent     | DT=0.1, DP=RASC*0.1, NS=3                 |
| 18    | Ascent step         | P1 -= DP; check P1 > PBIGK                |
| 21    | Impulse ascent      | NS=2, P1=33                                |
| 24    | (cont.)             | C=FALSE, go to RK                          |
| 17    | Controlled ascent   | P1 = PBIGK, go to RK                      |
| 20    | Flying after diving | KEY=0, extend TMAX by 1080 min             |
| 23    | Repetitive dive     | Read surface interval                      |
| 41    | (cont.)             | PMIN=0, go to impulse ascent (surface)     |
| 26    | Dive repetition     | Reset TMAX, KEY -= 10                      |
| 33    | End-of-dive tests   | Branch: repetitive, flying, or next dive   |
| 77    | (alias)             | GO TO 30                                   |
| 401-409 | RK DO loops       | Runge-Kutta stages                         |
| 450   | RK function eval    | F(I) = A*(X-Y)*(B+X+Y)                    |
| 500   | RK coefficient calc | AK(J,I) = (F(I)-F(I+1))*DT                |

### 6.5 Simplified Flow Diagram

```
START → Read KEY, TITL (label 1)
  ├── KEY=9 → STOP
  └── Write headers (label 2)
      Read A, B, R, DTL, TMAX, PTOUT, RDES, RASC
      Read initial conditions (label 6)
      Initialize compartments, output first line (label 30)
      → label 25: PMIN=0, KPT=0
      → label 11: Read T, G1
          ├── T < 0 → label 12: start ascent
          │     ├── KEY=4 → Impulse ascent (label 21): P1=33, NS=2
          │     └── KEY≠4 → Standard ascent (label 13): NS=3
          │           → label 18: P1 -= RASC*0.1
          │               ├── P1 > PBIGK → RK (label 10)
          │               └── P1 ≤ PBIGK → Controlled ascent:
          │                     C=TRUE, NS=4, P1=PBIGK
          │                     → Output (label 30) → RK (label 10)
          │
          └── T ≥ 0 → Setup descent/ascent to target
                ├── P1 < target-DP → Descend (label 58): P1 += DP
                ├── P1 > target+RASC*0.1 → Ascend (label 55): P1 -= RASC*0.1
                └── else → Snap to target (label 59): P1 = G1+33
                → label 57 → label 19 → RK (label 10)

  RK (label 10):
      4-stage Gill RK integration
      → label 22: update GBIG, TT
          ├── Output time? → Output (label 30)
          │     → label 44: dispatch on NS3
          └── Not output time → label 32: dispatch on NS
                → back to appropriate phase label
```

---

## 7. Appendix Examples from the Report

### 7.1 Appendix 3 — D6S Standard Dive: 200 ft for 10 minutes (Flying Option)

Input (KEY=05):
```
05 STANDARD DIVE 200 FT FOR 10 MINUTES (FLYING OPTION)
,7912E-402745013853
00109999002006000600
0000000000
0010002000
-1
09
```

Note: the comma before `7912` in line 2 is as it appears in the report scan.
The E8.4 format reads `.7912E-4`. The `3` after `01385` on line 2 is the
first character of line 3 (`3` from `0010...`); this is a known scan artifact
where line wrapping was ambiguous.

This dive descends at 60 ft/min to 200 ft, stays for 10 minutes (T=10
includes descent time of ~3.3 min), then ascends. Because KEY=05, after
reaching sea level the program continues calculating safe ascent altitude
for 18 hours (1080 minutes) with output every 15 minutes.

### 7.2 Appendix 4 — D6SA Impulse Dive: 200 ft for 30 minutes

Input (KEY=04):
```
04  IMPULSE DIVE 200 FT FOR 30 MINUTES
.7912E-40274501385
00109999005006000600
0000000000
0030002000
-1
09
```

Parameters: DTL=1.0, TMAX=999.9, PTOUT=5.0, RDES=60.0 (not used), RASC=60.0 (not used).

The diver is instantly placed at 200 ft gauge (P1 = 233) for 30 minutes,
then instantly returned to sea level (P1 = 33). Compartment pressures are
continuously calculated until all safe ascent depths reach sea level.

### 7.3 Appendix 5 — D6ST USN Dive Table: 150 ft for 30 minutes

Input (KEY=01):
```
01 USN DIVE TABLE 150 FT FOR 30 MINUTES
.7912E-40274501385
00109999002006000600
0000000000
0030001500
0008000200
0024000100
-1
09
```

Parameters: DTL=1.0, TMAX=999.9, PTOUT=2.0, RDES=60.0, RASC=60.0.

Stop schedule:
- Bottom time: 30 minutes at 150 ft (includes descent at 60 ft/min)
- First stop: 8 minutes at 20 ft
- Second stop: 24 minutes at 10 ft

The program descends at 60 ft/min to 150 ft, stays until T=30, then ascends
at 60 ft/min to the first stop (20 ft), holds for 8 minutes, ascends to the
second stop (10 ft), holds for 24 minutes, and then continues with the safe
ascent criterion until reaching sea level.

---

## 8. Changes from the 1973 Source

The following changes were made to compile with modern Fortran compilers:

1. **Hollerith constants** replaced with character strings.
2. **PDP-9 file I/O calls** (SEEK, DLETE, ENTER, CLOSE, EXIT) replaced with
   standard Fortran OPEN/READ/WRITE/CLOSE/STOP.
3. **D6ST ascent handling** added: the D6S listing (Appendix 1) only handles
   descent between input entries. Ascent between decompression stops using
   RASC was added (label 55 and the duration-to-absolute-time conversion at
   label 11) to support D6ST-style input.
4. **Transcription fix**: `GO TO 10` corrected to `GO TO 30` in the
   continuous controlled ascent section, matching the original listing.

### 8.1 Transcription Notes

The PDF is a scan of line-printer output. Common reading difficulties:
- Digits 3/8, 5/6, 1/7 are easily confused in the font
- Line wrapping between input data lines is sometimes ambiguous
- Hollerith count prefixes (e.g., `5H`, `4H`) blend visually with the
  text they precede
- The compound assignment `NS=NS3=4` visible in the listing is not valid
  Fortran; it is transcribed as two statements `NS=4` / `NS3=NS`
