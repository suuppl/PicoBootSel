# SPDX-FileCopyrightText: 2017 Limor Fried for Adafruit Industries
#
# SPDX-License-Identifier: MIT

import board
import digitalio
import storage

switch = digitalio.DigitalInOut(board.GP14)
switch.direction = digitalio.Direction.INPUT
switch.pull = digitalio.Pull.UP

# If the GP14 is connected to ground with a wire
# CircuitPython can write to the drive
print(f"readonly: {not switch.value}")
storage.remount("/", readonly=switch.value)
