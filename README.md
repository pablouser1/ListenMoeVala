# Listen.moe Vala
Cross platform Listen.moe client made using Vala

## Dependencies
To use the program you will need:
* GTK4 (for GUI)
* GStreamer (for audio playback)

## Compilation
Run the `build.sh` script and done!

You should have the binary in `./builddir/ListenMoe`

## How to use
```bash
./listenmoe -u gui -g jpop
```
* -u: Pick a frontend (gui or cli) Default: gui
* -g: Pick a genre (jpop or kpop) Default: jpop

## TODO
* Controls for CLI
* Improve GUI
* Hot-swapping between JPop and Kpop

## External libraries used
* [Vala](https://vala.dev)
* [GStreamer](https://gstreamer.freedesktop.org)
