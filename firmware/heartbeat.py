import time
import board
import digitalio

# Toggle GP0 at 1 Hz (0.5 s high, 0.5 s low)
heartbeat = digitalio.DigitalInOut(board.GP0)
heartbeat.direction = digitalio.Direction.OUTPUT

while True:
    heartbeat.value = True
    time.sleep(0.5)
    heartbeat.value = False
    time.sleep(0.5)
