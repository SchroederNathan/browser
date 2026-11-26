#!/usr/bin/env python3
"""Writes the icon set: the `icons` block of app.forma and the SVG files under assets/icons.

Each icon is an SF Symbol on Apple. Its SVG, drawn from the Browser Design System's paths (Paper,
24-unit grid), is what every other host shows. Run `python3 tools/icons.py` after a change here."""
import pathlib, re

ROOT = pathlib.Path(__file__).resolve().parent.parent
S = 'fill="none" stroke="#000" stroke-linecap="round" stroke-linejoin="round"'

# name: (SF Symbol, stroke width, SVG body)
ICONS = {
    "lock": ("lock.fill", 2.4, '<rect x="5" y="11" width="14" height="10" rx="2.5"/><path d="M8 11V8a4 4 0 0 1 8 0v3"/>'),
    "unlock": ("lock.open.fill", 2.4, '<rect x="5" y="11" width="14" height="10" rx="2.5"/><path d="M8 11V8a4 4 0 0 1 7.5-1.9"/>'),
    "chevron-up": ("chevron.up", 2.2, '<path d="M5 15l7-7 7 7"/>'),
    "microphone": ("mic", 1.9, '<rect x="9" y="3" width="6" height="11" rx="3"/><path d="M5 11a7 7 0 0 0 14 0M12 18v3"/>'),
    "clear": ("xmark.circle.fill", 0, '<path fill="#000" fill-rule="evenodd" stroke="none" d="M12 2a10 10 0 1 0 0 20a10 10 0 1 0 0-20zM12 13.41L14.76 16.17L16.17 14.76L13.41 12L16.17 9.24L14.76 7.83L12 10.59L9.24 7.83L7.83 9.24L10.59 12L7.83 14.76L9.24 16.17z"/>'),
    "search": ("magnifyingglass", 2, '<circle cx="11" cy="11" r="7"/><path d="M20 20l-4-4"/>'),
    "arrow-up-right": ("arrow.up.right", 2, '<path d="M7 17L17 7M9 7h8v8"/>'),
    "back": ("chevron.left", 2.2, '<path d="M15 5l-7 7 7 7"/>'),
    "forward": ("chevron.right", 2.2, '<path d="M9 5l7 7-7 7"/>'),
    "link": ("link", 2, '<path d="M10 14a4.5 4.5 0 0 0 6.4 0l3-3a4.5 4.5 0 0 0-6.4-6.4l-1 1"/><path d="M14 10a4.5 4.5 0 0 0-6.4 0l-3 3a4.5 4.5 0 0 0 6.4 6.4l1-1"/>'),
    "reload": ("arrow.clockwise", 2, '<path d="M20 12a8 8 0 1 1-2.4-5.7"/><path d="M20 4v5h-5"/>'),
    "find": ("doc.text.magnifyingglass", 1.8, '<path d="M14 3H7a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h4"/><path d="M9 8h6M9 12h3"/><circle cx="16.5" cy="16.5" r="3"/><path d="M21 21l-2.3-2.3"/>'),
    "sparkles": ("sparkles", 1.8, '<path d="M12 3l1.8 4.7L18.5 9.5l-4.7 1.8L12 16l-1.8-4.7L5.5 9.5l4.7-1.8z"/><path d="M18.5 15.5l.8 2 2 .8-2 .8-.8 2-.8-2-2-.8 2-.8z"/>'),
    "pin": ("pin.fill", 1.8, '<path d="M9 3h6l-1 5 3 4H7l3-4z" fill="#000"/><path d="M12 12v9"/>'),
    "share": ("square.and.arrow.up", 1.8, '<path d="M12 3v12M7.5 7.5L12 3l4.5 4.5"/><path d="M8 11H6a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-8a1 1 0 0 0-1-1h-2"/>'),
    "reader": ("doc.plaintext", 1.8, '<rect x="4" y="3" width="16" height="18" rx="2.5"/><path d="M8 8h8M8 12h8M8 16h5"/>'),
    "globe": ("globe", 1.8, '<circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18"/>'),
    "text-size": ("textformat.size", 1.8, '<path d="M2.5 19l3.2-8.5L9 19M3.7 16.2h4M11 19l4.6-12.5L20.5 19M12.8 15h5.6"/>'),
    "desktop": ("laptopcomputer", 1.8, '<rect x="4" y="5" width="16" height="11" rx="1.5"/><path d="M2 19h20"/>'),
    "sliders": ("slider.horizontal.3", 1.8, '<path d="M4 7h10M18 7h2M4 17h2M10 17h10"/><circle cx="16" cy="7" r="2"/><circle cx="8" cy="17" r="2"/>'),
    "close-circle": ("xmark.circle", 1.8, '<circle cx="12" cy="12" r="9"/><path d="M9 9l6 6M15 9l-6 6"/>'),
    "private": ("eyeglasses", 1.8, '<path d="M3 11h18M6 11l1.5-5h9L18 11"/><circle cx="7.5" cy="16" r="2.5"/><circle cx="16.5" cy="16" r="2.5"/><path d="M10 16h4"/>'),
    "close": ("xmark", 2.6, '<path d="M6 6l12 12M18 6L6 18"/>'),
    "close-all": ("xmark.square", 1.9, '<rect x="3" y="7" width="14" height="14" rx="3"/><path d="M7 3h11a3 3 0 0 1 3 3v11"/><path d="M7.5 11.5l5 5M12.5 11.5l-5 5"/>'),
    "plus": ("plus", 2.4, '<path d="M12 5v14M5 12h14"/>'),
    "minus": ("minus", 2.4, '<path d="M5 12h14"/>'),
    "checkmark": ("checkmark", 2.4, '<path d="M5 12.5l4.5 4.5L19 7.5"/>'),
}

icons = ROOT / "assets" / "icons"
icons.mkdir(parents=True, exist_ok=True)
for old in icons.glob("*.svg"):
    old.unlink()
lines = ["icons", "  // Written by tools/icons.py: an SF Symbol on Apple, the design's own path elsewhere."]
for name, (sf, width, body) in ICONS.items():
    (icons / f"{name}.svg").write_text(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" {S} stroke-width="{width}">{body}</svg>\n')
    lines.append(f'  icon.{name} = icon(sf "{sf}", svg "icons/{name}.svg")')
forma = ROOT / "app.forma"
text = re.sub(r"\nicons\n.*\Z", "\n", forma.read_text(), flags=re.S).rstrip("\n")
forma.write_text(text + "\n\n" + "\n".join(lines) + "\n")
