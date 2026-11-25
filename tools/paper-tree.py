#!/usr/bin/env python3
"""Prints an artboard that tools/paper-dump.mjs wrote as an indented tree: tag, node id, styles, text.

    python3 tools/paper-tree.py <out dir>/<node id>.html
"""
import sys, re
from html.parser import HTMLParser
DROP = re.compile(r'^(box-sizing|flex-shrink: 0|-webkit-font-smoothing|font-synthesis|white-space-collapse|text-wrap-mode|contain|isolation)')
class P(HTMLParser):
    def __init__(s): super().__init__(); s.d = 0; s.skip = 0
    def handle_starttag(s, tag, attrs):
        a = dict(attrs); st = a.get('style', '') or ''
        parts = [p.strip() for p in st.split(';') if p.strip() and not DROP.match(p.strip())]
        extra = ' '.join(f'{k}={v[:300]}' for k, v in a.items() if k in ('d', 'viewBox', 'fill', 'stroke', 'stroke-width', 'stroke-linecap', 'stroke-linejoin', 'cx', 'cy', 'r', 'x', 'y', 'x1', 'y1', 'x2', 'y2', 'width', 'height', 'rx', 'points', 'data-label', 'data-name') and v)
        print('  ' * s.d + f"<{tag} #{a.get('data-node-id', '')}> " + '; '.join(parts) + (' | ' + extra if extra else ''))
        if tag not in ('br', 'img', 'path', 'circle', 'rect', 'line', 'polyline', 'polygon', 'ellipse', 'input'): s.d += 1
    def handle_startendtag(s, tag, attrs): s.handle_starttag(tag, attrs); 
    def handle_endtag(s, tag):
        if tag not in ('br', 'img', 'path', 'circle', 'rect', 'line', 'polyline', 'polygon', 'ellipse', 'input'): s.d = max(0, s.d - 1)
    def handle_data(s, data):
        if data.strip(): print('  ' * s.d + '"' + data.strip() + '"')
P().feed(open(sys.argv[1]).read())
