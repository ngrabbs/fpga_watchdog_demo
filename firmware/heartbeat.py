# firmware/heartbeat.py

import time
import board
import digitalio

heartbeat = digitalio.DigitalInOut(board.GP0)
heartbeat.direction = digitalio.Direction.OUTPUT

# This drives the Pico’s little on-board LED (GP25)
led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT

while True:
    heartbeat.value = True
    led.value       = True
    time.sleep(0.5)
    heartbeat.value = False
    led.value       = False
    time.sleep(0.5)
