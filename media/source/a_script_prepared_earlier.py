#!/usr/bin/env python

import cv2
import numpy as np
import os

img = np.zeros((594,800,3), np.uint8)
img += (192)

lines=[
    "This script is running",
    "inside the container.",
    "The GUI is displayed",
    "on the host."
]

for i, line in enumerate(lines):
    cv2.putText(img,
    	line,
       	(20,i*50+50),
        cv2.FONT_HERSHEY_SIMPLEX,
        1,
        (64, 64, 64),
        2)

output_path = "{}/out.jpg".format(os.environ['WORKDIR'])
cv2.imwrite(output_path, img)
print("Wrote " + output_path)

if 'DISPLAY' in os.environ:
    cv2.imshow("img",img)
    cv2.waitKey(0)
else:
    print("Display not present - skipping GUI")

print("Script finished successfully!")
