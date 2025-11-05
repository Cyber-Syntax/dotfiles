# TODO.md

## todo

- [ ] systray icon so small
- [ ] percentage not aligned correctly on widgets
- [ ] ewmh is completely wrong paddings
  - switch i3 workspaces more easy
- [ ] update polybar status when scripts done

## testing

- [X] character errors
  - below checkbox is cause issue, even with siji + other all fonts
    I changed that character on my script to work with polybar for workaround solution
  - Problem was `polybar|notice:  Loaded font "Noto Color Emoji:style=Regular=Medium:size=11" (name=Noto Color Emoji, offset=0, file=/usr/share/fonts/google-noto-color-emoji-fonts/NotoColorEmoji.ttf)
` this font missing

```bash
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
polybar|warn:  Dropping unmatched character '✅' (U+2705) in '✅ Up-to-date'
```
