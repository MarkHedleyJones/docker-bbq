# Rebuilding demo.gif
This file details how to generate/regenerate the demo.gif file.
Tools used were:
* [ARandR](https://christian.amsuess.com/tools/arandr/) - for setting display resolution.
* [gifsicle](https://www.lcdf.org/gifsicle/) - for merging multiple gif images
* [Gimp](https://www.gimp.org/) - for editing the gif image
* [i3-gaps](https://github.com/Airblader/i3) (optional)
* [Inkscape](https://inkscape.org/) - for creating the background
* [peek](https://github.com/phw/peek) - for recording the screen to gif images
* [XMacro](http://xmacro.sourceforge.net/) - for recording and replaying keystrokes

## 1. Record the keyboard input

To do this [XMacro](http://xmacro.sourceforge.net/) was used to record the keyboard input as follows:

    xmacrorec2 > demo-recording-pgX

If you only want to make minor alterations to the video, it's probably easeir to hand-edit the `demo-recording-pgX` files.

## 2. Post-process the macro files

The raw macro files can be processed using the `process_recording.py` script.
That script then produces a outputs of the form `demo-recording-part-X`.
This reduces the delay between keystrokes and adds key-combinations to start and stop video recording.

## 3. Prepare for replaying the macros

Disable the status bar on your window manager.
The screen resolution was set to 800x600 (using ArandR).

Each `demo-recording-part-X` file begins and ends with the keyboard sequence that triggers `peek` to begin and stop the recording.
It was important to break the recording up into smaller chunks otherwise peek would fail to compile the final output.

I added the following line to my i3 configuration file (~/.config/i3/config).

    bindsym $mod+F12 exec cat demo-recording-part-ln | xmacroplay
    bindsym F12 exec pkill xmacroplay

Then I would link the relevant page to that file using

    ln -s <demo-recording-part-X> /home/$USER/demo-recording-ln

## 4. Run recorded macro sequences

Terminal used: gnome-terminal
Font used: terminus (14pt)
Shell used: zsh with oh-my-zsh theme "simple"

Move to an empty desktop and press your $mod+F12
$mod is either Alt or the Windows key depending on your i3 configuration.
In the event that something goes wrong, you can hit F12 to cancel playback.
Once the recording has finished, `peek` will prompt you to save the gif.
Save each part as something like `demo-recording-gif-ptX`

## 5. Merge individual GIFs
Once all gifs have been saved, use [gifsicle](https://www.lcdf.org/gifsicle/) to merge the gifs into one gif.

    gifsicle demo-recording-gif-pt* > combined.gif

## 6. Add background and trim size (optional)
Then, open demo-background.svg in Inkscape and save the output as a PNG with transparent edges (e.g. demo-background.png).
Then after opening `combined.gif` in Gimp:
1. Rescale the dimensions to that of demo-background.png
2. Add demo-background.png to the layers and move it to the lower most layer
3. Save the final gif as demo.gif
