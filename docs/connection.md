# Hardware Connection Diagram

Use the Arty A7 Pmod headers JA and JB to interface with two RP2040 Pico boards.

```ascii
         +-----------+          +-----------------+
         |  RP2040   |          |   Arty A7 FPGA  |
         |  Pico 1   |          |                 |
         |           |          | Pmod JA (input) |
GP0 -->  | GP0 (heartbeat1) -->| JA1 (pin F13)   |
RUN  <-- | RUN (reset1)    <--| JB1 (pin D13)   |
         +-----------+          +-----------------+

         +-----------+          +-----------------+
         |  RP2040   |          |   Arty A7 FPGA  |
         |  Pico 2   |          |                 |
         |           |          | Pmod JA (input) |
GP0 -->  | GP0 (heartbeat2) -->| JA2 (pin F14)   |
RUN  <-- | RUN (reset2)    <--| JB2 (pin D14)   |
         +-----------+          +-----------------+

3V3/GND connections: share power and ground across all boards.
```
