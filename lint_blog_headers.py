import os
import re
from pathlib import Path
from urllib.parse import urlparse, urlunparse, parse_qsl, urlencode
import sys

def ensure_double_newlines_before_headers(content):
    """Ensure every markdown header (##, ###, ####, etc.) has two newlines before it, unless at the very start."""
    def replacer(match):
        header = match.group(2)
        return f"\n\n{header}"
    # Only match headers that are not at the start of the file
    content = re.sub(r'([^\n])((?:\n)?(#{2,}[^#].*))', lambda m: m.group(1) + replacer(m), content)
    # Also handle the case where a header is at the start but not at the very beginning (e.g. after a code block)
    content = re.sub(r'(?<!\n)\n(#{2,}[^#].*)', r'\n\n\1', content)
    return content

def add_utm_to_tinybird_links(content):
    """Append UTM parameters to all tinybird.co URLs in the markdown."""
    def replacer(match):
        url = match.group(0)
        parsed = urlparse(url)
        if 'tinybird.co' not in parsed.netloc:
            return url
        # Parse existing query params
        query = dict(parse_qsl(parsed.query))
        # Add/overwrite UTM params
        query['utm_source'] = 'DEV'
        query['utm_campaign'] = 'tb create --prompt DEV'
        # Rebuild the URL
        new_query = urlencode(query, doseq=True)
        new_url = urlunparse(parsed._replace(query=new_query))
        return new_url
    # Regex to match http(s)://...tinybird.co... (stop at space, ), ], or ")
    url_pattern = r'https?://[\w\.-]*tinybird\.co[^\s)\]">]+'
    return re.sub(url_pattern, replacer, content)

def lint_all_blogs(templates_dir='templates', first_only=False):
    updated = 0
    checked = 0
    for template_dir in Path(templates_dir).iterdir():
        if template_dir.is_dir():
            blog_path = template_dir / 'BLOG.md'
            if blog_path.exists():
                checked += 1
                with open(blog_path, 'r', encoding='utf-8') as f:
                    original = f.read()
                fixed = ensure_double_newlines_before_headers(original)
                fixed = add_utm_to_tinybird_links(fixed)
                if fixed != original:
                    with open(blog_path, 'w', encoding='utf-8') as f:
                        f.write(fixed)
                    updated += 1
                    print(f"Updated: {blog_path}")
                else:
                    print(f"Checked (no changes): {blog_path}")
                if first_only:
                    print(f"Stopped after first BLOG.md (use without --first to lint all)")
                    break
    print(f"\nChecked {checked if not first_only else 1} BLOG.md file(s). Updated {updated} file(s).")

if __name__ == "__main__":
    first_only = '--first' in sys.argv
    lint_all_blogs(first_only=first_only) 