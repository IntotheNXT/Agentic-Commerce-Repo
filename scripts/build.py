#!/usr/bin/env python3
"""Cross-platform site build: embed sources/sources.json into output/index.html.

Single source of truth: sources/sources.json -> embedded between the
/*__SOURCES_DATA__*/ ... /*__END__*/ markers in output/index.html.
Usage: python3 scripts/build.py  (mirrors build.ps1 for the Linux cloud routine).
"""
import json, re, pathlib, sys

root = pathlib.Path(__file__).resolve().parent.parent
data_path = root / "sources" / "sources.json"
index_path = root / "output" / "index.html"

if not data_path.exists():
    sys.exit(f"ERROR: {data_path} not found")

data = json.loads(data_path.read_text(encoding="utf-8"))
compact = json.dumps(data, ensure_ascii=False, separators=(",", ":"))

html = index_path.read_text(encoding="utf-8")
pattern = re.compile(r"/\*__SOURCES_DATA__\*/.*?/\*__END__\*/", re.S)
if not pattern.search(html):
    sys.exit("ERROR: data markers not found in output/index.html")

html = pattern.sub(lambda m: "/*__SOURCES_DATA__*/" + compact + "/*__END__*/", html)
index_path.write_text(html, encoding="utf-8")
print(f"embedded {len(data)} sources -> output/index.html")
