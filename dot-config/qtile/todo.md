# Todos

## testing

## in-progress

- [ ] Clear the codebase
  - Simplify the widgets
  - Simplify the constants, themes

## todo

- [ ] add zed-editor icon to tasklist widget
- [ ] bug on genpolltext widget for my scripts

```python
2025-11-04 12:49:44,697 libqtile base.py:on_done():L897  Failed to reschedule timer for my-unicorn.
Traceback (most recent call last):
  File "/usr/lib64/python3.13/site-packages/libqtile/widget/base.py", line 891, in on_done
    self.update(result)
    ~~~~~~~~~~~^^^^^^^^
  File "/usr/lib64/python3.13/site-packages/libqtile/widget/base.py", line 803, in update
    old_width = self.layout.width
                ^^^^^^^^^^^^^^^^^
  File "/usr/lib64/python3.13/site-packages/libqtile/backend/base/drawer.py", line 416, in width
    return self.layout.get_pixel_size()[0]
           ~~~~~~~~~~~~~~~~~~~~~~~~~~^^
  File "/usr/lib64/python3.13/site-packages/libqtile/pangocffi.py", line 134, in get_pixel_size
    pango.pango_layout_get_pixel_size(self._pointer, width, height)
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
TypeError: initializer for ctype 'PangoLayout *' must be a cdata pointer, not NoneType
2025-11-04 12:49:49,079 libqtile base.py:on_done():L897  Failed to reschedule timer for fedora-package-manager.
Traceback (most recent call last):
  File "/usr/lib64/python3.13/site-packages/libqtile/widget/base.py", line 891, in on_done
    self.update(result)
    ~~~~~~~~~~~^^^^^^^^
  File "/usr/lib64/python3.13/site-packages/libqtile/widget/base.py", line 803, in update
    old_width = self.layout.width
                ^^^^^^^^^^^^^^^^^
  File "/usr/lib64/python3.13/site-packages/libqtile/backend/base/drawer.py", line 416, in width
    return self.layout.get_pixel_size()[0]
           ~~~~~~~~~~~~~~~~~~~~~~~~~~^^
  File "/usr/lib64/python3.13/site-packages/libqtile/pangocffi.py", line 134, in get_pixel_size
    pango.pango_layout_get_pixel_size(self._pointer, width, height)
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
TypeError: initializer for ctype 'PangoLayout *' must be a cdata pointer, not NoneType
```

## done

- multi-monitor dynamic setup
- multi-monitor keys move them to config.py for better organization, multi machine support
