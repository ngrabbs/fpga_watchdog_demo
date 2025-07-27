# FPGA Watchdog Demo

This hands-on tutorial walks you through building and testing an external watchdog on an Arty A7 FPGA that monitors two RP2040 Pico boards in a DMR (dual-modular redundant) configuration. The FPGA will hold the standby Pico in reset until the master Pico’s heartbeat fails.

## Repo Structure

```
fpga_watchdog_demo/
├── hdl/
│   ├── CustomCounter.vhd
│   └── Watchdog.vhd
├── docs/
│   └── connection.md
├── firmware/
│   └── heartbeat.py
└── README.md
```

## Prerequisites (≈30 min)

- **Vivado 2020.2 (or newer)** installed on your host PC.
- **CircuitPython** on both Pico boards (v7.x recommended). Copy the UF2 from https://circuitpython.org/board/raspberry_pi_pico/
- **USB cables** for the Pico boards and the Arty A7 JTAG.

## Step-by-Step Guide

1. **Clone the repo**
   ```bash
   git clone https://github.com/youruser/fpga_watchdog_demo.git
   cd fpga_watchdog_demo
   ```

2. **Create Vivado project**
   - Launch Vivado → Create New Project → RTL Project.
   - Add `hdl/CustomCounter.vhd` and `hdl/Watchdog.vhd` as design sources.
   - Target the Arty A7 device (xc7a35ticsg324-1L).

3. **Implement and generate bitstream**
   - Run Synthesis → Implementation → Generate Bitstream.
   - Export hardware (.hwh) and program the board via Hardware Manager.

4. **Prepare RP2040 Pico boards**
   - Plug each Pico into USB, enter bootloader (hold BOOTSEL) and flash CircuitPython UF2.
   - After reboot, copy `firmware/heartbeat.py` to the CIRCUITPY drive on **both** boards.

5. **Wire up hardware**
   - Follow `docs/connection.md` to connect GP0 and RUN pins between the Picos and the FPGA Pmod headers.
   - Power on the boards; ensure shared ground and 3.3 V.

6. **Test the system**
   - Observe the master Pico toggling GP0 at 1 Hz (LED indicator optional).
   - Manually pull the master RUN line low to simulate a failure; FPGA should release the standby Pico from reset.

## Time-Block Plan for Sorted³

| Task                                    | Duration |
|-----------------------------------------|----------|
| Install Vivado & set up project         | 30 min   |
| Add HDL sources & generate bitstream    | 30 min   |
| Configure CircuitPython on Picos        | 15 min   |
| Wire hardware & power-up                | 15 min   |
| Functional testing & failover demo      | 15 min   |

Block out ~2 hours for a smooth, uninterrupted session.
