# Client side backup script for Dominions 5

This script will backup your games at the end of every turn.

## How to run:

First, copy this script into your `~/.dominions/savedgames` folder.

Then create `watchedgames.txt` file in this folder. This file specifies which games you want to backup. For example, I have there:
```bash
computer_generated_memes
players_enhanced
malice
```

Now you just need to run dominions with the `--preexec` option. For example, I have `dom5` in `bin` folder and it looks like this:

```bash
#!/bin/bash

BACKUPSCRIPT="~/.dominions5/savedgames/backupscript.sh"

cd /home/colombo/.steam/steam/steamapps/common/Dominions5 && bash dom5.sh --nosteam --multiai 0 --preexec ${BACKUPSCRIPT} "$@"
```

You might also have to modify some variables in the `backupscript.sh` itself. Notably the `DOMINIONS` variable, which should be path to either dominions itself or the launch script shown above (note the `"$@"` which enables passing options of script into dominions binary itself). You can chose to back map just once or every time with every turn file (more convenient as you can copy all those turn folders into savedgames directory and look at them in dominions, but this takes much more space as map is the biggest file).

## Disclaimers
Note that there is no way to detect which game turn has ended and thus which game needs to be backed up. Do to this, all your games are backed every time. While this is annoying, this operation is fast so it should not be generally problem.
