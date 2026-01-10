# Rofi Calendar Script Best Practices

## Do's and Don'ts

### 1. Enable Markup in Rofi Themes

- **Do**: Add `markup: true;` to the `element-text` section in your rofi theme file when using Pango markup (e.g., `<span>` tags) for styling list items.
- **Don't**: Forget to enable markup, as it will display HTML-like tags literally instead of rendering them.

### 2. Handle State Persistence in Interactive Scripts

- **Do**: Reset state (e.g., set `OFFSET=0`) on initial launch (`$# -eq 0`) for scripts that should refresh on each run, while loading saved state only during user selections to maintain session navigation.
- **Don't**: Always load persisted state on start, as it prevents resetting to default (e.g., current month) across launches.

### 3. Quote Command Substitutions in Bash

- **Do**: Always quote command substitutions like `"$(date ...)"` to prevent word splitting and shell warnings.
- **Don't**: Leave them unquoted, as it can lead to unexpected behavior with multi-word outputs.

## General Tips

- Test rofi scripts manually to verify output and behavior before full use.
- Use temp files for session-specific persistence, but ensure they reset appropriately.
- Check rofi version compatibility for features like markup (e.g., 1.7.3+).
