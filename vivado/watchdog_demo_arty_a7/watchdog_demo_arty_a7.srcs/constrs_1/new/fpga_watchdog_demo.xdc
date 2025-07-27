## fpga_watchdog_demo.xdc
## Merged with the ARTY Rev. A master template

#------------------------------------------------------------------
# Clock (100 MHz on the Arty-A7 sysclk oscillator)
#------------------------------------------------------------------
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { Clock }];  
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports { Clock }];

#------------------------------------------------------------------
# Heartbeat inputs from RP2040 GP0 pins on Pmod JA1 / JA2
#   JA1 → G13, JA2 → B11 per Arty-A7 Pmod JA pinout
#------------------------------------------------------------------
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { HeartBeat1 }];
set_property -dict { PACKAGE_PIN B11   IOSTANDARD LVCMOS33 } [get_ports { HeartBeat2 }];

#------------------------------------------------------------------
# "Initialize" push-button → BTN0 on the Arty (pin D9)
#------------------------------------------------------------------
set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 PULLDOWN TRUE } [get_ports { Initialize }];
#set_property -dict { PACKAGE_PIN D9    IOSTANDARD LVCMOS33 } [get_ports { Initialize }];


#------------------------------------------------------------------
# Fail-over outputs driving the RP2040 RUN lines via Pmod JA:
#   (we're re-using JA7 and JA10 here)
#    JA7  → D13  → Proc2_Enable
#    JA10 → E15  → Proc1_Enable
#------------------------------------------------------------------
set_property -dict { PACKAGE_PIN D13   IOSTANDARD LVCMOS33 } [get_ports { Proc1_Enable }];
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { Proc2_Enable }];

#------------------------------------------------------------------
# Status indicators on the onboard LEDs:
#   LED[0] (H5) ← Error
#   LED[1] (J5) ← Status
#------------------------------------------------------------------
set_property -dict { PACKAGE_PIN H5    IOSTANDARD LVCMOS33 } [get_ports { Error }];
set_property -dict { PACKAGE_PIN J5    IOSTANDARD LVCMOS33 } [get_ports { Status }];

# Blink onboard LED2 (T9) with incoming HeartBeat1
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { HB1_LED }];
set_property -dict { PACKAGE_PIN T10    IOSTANDARD LVCMOS33 } [get_ports { BTN0 }];