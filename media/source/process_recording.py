#!/usr/bin/env python

import os

input_scripts = [
    "dockerflow-recording-pg1",
    "dockerflow-recording-pg2",
    "dockerflow-recording-pg3",
    "dockerflow-recording-pg4",
    "dockerflow-recording-pg5",
]

output_script = "dockerflow-recording-processed"

if os.path.isfile(output_script):
    os.remove(output_script)
    with open(output_script, "w") as f:
        pass


counter = 0

new_lines=[]

latch = None

start_stop = [
    "KeyStrPress Control_L\n",
    "Delay 120\n",
    "KeyStrPress Alt_L\n",
    "Delay 432\n",
    "KeyStrPress r\n",
    "KeyStrRelease r\n",
    "KeyStrRelease Alt_L\n",
    "KeyStrRelease Control_L\n"
    "Delay 500\n",
]

for input_script in input_scripts:

    with open(input_script, "r") as f:
        lines=f.readlines()

    last_key = None
    last_chars = ""
    for line in lines:
        if line[:5] == "Delay" and last_key != "Return":
            delay = int(line.split(" ")[1])
            if last_key == "space":
                delay = (delay % 50) + 85
            elif last_key == "period":
                delay = 250
            elif last_key == "Super_L":
                delay = 5000
            else:
                delay = min(delay, 300)
                delay = int(delay/3)
            new_lines.append("Delay {}\n".format(delay))
        else:
            new_lines.append(line)

        last_line = line.split(' ')
        last_key = last_line[-1][:-1]
        last_cmd = last_line[0]


        if last_cmd == "KeyStrPress":
            if len(last_key) == 1 and last_key.isalpha():
                last_chars += last_key
            else:
                last_chars = ""
            # print(last_chars)

        if latch == None and last_chars == "clear":
            latch = 2

        if latch is not None and last_key == "Return":
            latch -= 1

        if latch is not None and latch <= 0:
            counter += 1
            output_filename = f"dockerflow-recording-part-{counter}"
            with open(output_filename, "w") as f:
                f.write("".join(start_stop))
                f.write("".join(new_lines))
                f.write("".join(start_stop))
            print(f"Wrote {output_filename}")
            new_lines = []
            last_chars = ""
            latch = None

counter += 1
output_filename = f"dockerflow-recording-part-{counter}"
with open(output_filename, "w") as f:
    f.write("".join(start_stop))
    f.write("".join(new_lines))
    f.write("".join(start_stop))
print(f"Wrote {output_filename}")
