import board
import digitalio
import time

files = (
    "set os_hw_switch=0\n",
    "set os_hw_switch=1\n"
)

pins = (board.GP1, board.GP2)

mapping = (0, 1)

## functions
def setup_pins(handles, is_input=True):
    pins = []
    for handle in handles:
        pin = digitalio.DigitalInOut(handle)
        if is_input:
            pin.direction = digitalio.Direction.INPUT
            pin.pull = digitalio.Pull.UP
        else:
            pin.direction = digitalio.Direction.OUTPUT
        pins.append(pin)
    return pins

def pins_to_state(pins):
    for i, pin in enumerate(pins):
        if not pin.value:
            return i

def write_state(state, mapping, files, filename, dbg=False):
    if dbg:
        print(files[mapping[state]])
    with open(filename, "w+") as fp:
        fp.write(files[mapping[state]])
        fp.flush()
    

## main entry

pins = setup_pins(pins)
pins_to_state(pins)
state = pins_to_state(pins)
write_state(state, mapping, files, filename="/switch.cfg", dbg=True)

## keep it running
led = digitalio.DigitalInOut(board.LED)
led.direction = digitalio.Direction.OUTPUT
while True:
    time.sleep(1)
    led.value = True
    time.sleep(1)
    led.value = False
    # print(f"state: {state}")