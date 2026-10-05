# Launcher

The launcher uses normal KERNAL disk I/O and
does not upload a custom fastloader to the drive.

![Categories](./categories.png)

![Launcher](./launcher.png)

Regenerate both native 320×200 screenshots after a build with:

```sh
python scripts/render_launcher_screenshots.py
```

The renderer boots the built disk through the deterministic machine harness and
writes the captured C64 pixels without resizing.

## Controls

| Key | Launcher action |
| --- | --- |
| Cursor keys / shifted cursor keys | Move the selection; cross a grid edge to change page when another page exists |
| RETURN | Open a category or launch a program |
| A–Z | In a program list, jump to the first program starting with that letter or a later letter |
| F5, DEL, or RUN/STOP | Return to the first category page |
| RUN/STOP during a program | Return to the same launcher page |

The selected icon's name has a cyan background. Its 64-byte description and
payload size appear below the grid. An oversized entry has a red `!` beside its
name and a red `! OVER 256` label. Empty categories remain selectable.


[Home](../readme.md)