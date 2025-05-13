import os
import argparse
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import math
import json

# Font paths (update as needed for your system)
FONT_PATH = "/Library/Fonts/Lato-Regular.ttf"
MONO_FONT_PATH = "/Library/Fonts/iawriterduos-regular-webfont.ttf"
FALLBACK_FONT = "/Library/Fonts/Arial.ttf"
FONT_SIZE_TITLE = 56
FONT_SIZE_AUTHOR = 32
FONT_SIZE_CODE = 28
PADDING = 60
AVATAR_SIZE = 80
LOGO_WIDTH = 150
CODE_BG = (21, 21, 21)
CODE_FG = (220, 220, 220)
TITLE_MAX_WIDTH = 520
AVATAR_OUTLINE_WIDTH = 4
AVATAR_OUTLINE_GAP = 6
CODE_OUTLINE_WIDTH = 4
CODE_OUTLINE_GAP = 6

# Template config defaults (current hardcoded values)
DEFAULT_TEMPLATE = {
    "bg_color": "#0a0a0a",
    "bg_gradient_colors": None,
    "bg_gradient_angle": 0,
    "title_font_color": "#ffffff",
    "title_font": FONT_PATH,
    "outline_color": "#27f795",
    "code_font": MONO_FONT_PATH,
    "code_font_color": "#dcdcdc",
    "code_bg": "#151515",
    "code_browser_bar_color": "#262626"
}

# Example template JSON structure (for og/og-templates/template_name.json):
# {
#   "bg_color": "#0a0a0a",
#   "bg_gradient_colors": ["#0a2240", "#1a2a60", "#2a3a80"],
#   "bg_gradient_angle": 0,
#   "title_font_color": "#ffffff",
#   "title_font": "/Library/Fonts/Lato-Regular.ttf",
#   "outline_color": "#27f795",
#   "code_font": "/Library/Fonts/iawriterduos-regular-webfont.ttf",
#   "code_font_color": "#dcdcdc",
#   "code_bg": "#151515",
#   "code_browser_bar_color": "#262626"
# }

def load_font(path, size):
    try:
        return ImageFont.truetype(path, size)
    except Exception:
        return ImageFont.truetype(FALLBACK_FONT, size)

def wrap_text(text, font, max_width):
    words = text.split()
    lines = []
    current = ''
    for word in words:
        test = current + (' ' if current else '') + word
        bbox = font.getbbox(test)
        width = bbox[2] - bbox[0]
        if width <= max_width:
            current = test
        else:
            if current:
                lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines

def draw_code_block(img, draw, code, x, y, width, height, font, left_pad=32, top_pad=56, outline_color=(39,247,149,255), outline_width=4, gap=6):
    radius = 18  # Outline radius
    code_block_radius = int(radius * 0.65)  # Code block window radius (smaller so it fits inside outline)
    # Outline position and size
    outline_x = x + outline_width / 2
    outline_y = y + outline_width / 2
    outline_w = width - outline_width
    outline_h = height - outline_width

    # Code block position and size (inset from top and left only)
    cb_x = x + gap + outline_width
    cb_y = y + gap + outline_width
    cb_w = width - (gap + outline_width)
    cb_h = height - (gap + outline_width)

    # Draw the code block background (bleeds to right and bottom)
    code_block = Image.new('RGBA', (cb_w, cb_h), CODE_BG)
    code_draw = ImageDraw.Draw(code_block)
    # Browser bar
    code_draw.rectangle([0, 0, cb_w, 40], fill=(38, 38, 38))
    # Browser dots (smaller, more gap)
    dot_d = 12
    dot_gap = 20
    dot_y = 14
    dot_x0 = 18
    for i, color in enumerate([(255, 95, 86), (255, 189, 46), (39, 201, 63)]):
        code_draw.ellipse([dot_x0+i*dot_gap, dot_y, dot_x0+dot_d+i*dot_gap, dot_y+dot_d], fill=color)
    # Code text
    code_lines = code.split('\n')
    max_lines = (cb_h - top_pad) // 36
    for i, line in enumerate(code_lines[:max_lines]):
        code_draw.text((left_pad, top_pad+i*36), line, font=font, fill=CODE_FG)
    # Blur gradient at the bottom
    gradient = Image.new('L', (cb_w, 80), color=0)
    for i in range(80):
        gradient.putpixel((0, i), int(255 * (i/80)))
    alpha = gradient.resize((cb_w, 80))
    blur_overlay = Image.new('RGBA', (cb_w, 80), (30, 34, 41, 0))
    blur_overlay = blur_overlay.filter(ImageFilter.GaussianBlur(8))
    code_block.paste(blur_overlay, (0, cb_h-80), alpha)
    # Mask for top-left rounded corner only (smaller radius than outline)
    mask = Image.new('L', (cb_w, cb_h), 255)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rectangle([0, 0, code_block_radius, code_block_radius], fill=0)
    mask_draw.pieslice([0, 0, 2*code_block_radius, 2*code_block_radius], 180, 270, fill=255)
    # Paste code block onto main image at (cb_x, cb_y) with mask
    img.paste(code_block, (int(cb_x), int(cb_y)), mask)
    # Draw outline only on top and left (using original radius)
    outline_draw = ImageDraw.Draw(img)
    r = radius
    ow = outline_width
    ox = outline_x
    oy = outline_y
    ow_w = width - outline_width
    ow_h = height - outline_width
    # Top line (with rounded left corner)
    outline_draw.arc([ox, oy, ox+2*r, oy+2*r], 180, 270, fill=outline_color, width=int(ow))
    outline_draw.line([ox+r, oy, ox+ow_w, oy], fill=outline_color, width=int(ow))
    # Left line (with rounded top corner)
    outline_draw.arc([ox, oy, ox+2*r, oy+2*r], 180, 270, fill=outline_color, width=int(ow))
    outline_draw.line([ox, oy+r, ox, oy+ow_h], fill=outline_color, width=int(ow))

def extract_title_from_blog(blog_md_path):
    if not os.path.exists(blog_md_path):
        return None
    with open(blog_md_path, 'r', encoding='utf-8') as f:
        for line in f:
            if line.strip().startswith('# '):
                return line.strip().lstrip('#').strip()
    return None

def read_code_block(code_path):
    if not code_path or not os.path.exists(code_path):
        return 'No code available'
    with open(code_path, 'r', encoding='utf-8') as f:
        code = f.read().strip()
        return code if code else 'No code available'

def mask_circle(im, size, outline_color=(39,247,149,255), outline_width=4, gap=6):
    total_pad = outline_width + gap
    outline_size = size + 2 * total_pad
    # Create mask for the avatar
    mask = Image.new('L', (size, size), 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse((0, 0, size, size), fill=255)
    result = Image.new('RGBA', (size, size))
    result.paste(im.resize((size, size)), (0, 0), mask)
    # Create outline with gap
    outline = Image.new('RGBA', (outline_size, outline_size), (0,0,0,0))
    outline_draw = ImageDraw.Draw(outline)
    ellipse_box = (outline_width//2, outline_width//2, outline_size-outline_width//2-1, outline_size-outline_width//2-1)
    outline_draw.ellipse(ellipse_box, outline=outline_color, width=outline_width)
    # Paste avatar in center with gap
    outline.paste(result, (total_pad, total_pad), result)
    return outline

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    lv = len(hex_color)
    return tuple(int(hex_color[i:i+lv//3], 16) for i in range(0, lv, lv//3))

def create_linear_gradient(size, colors, angle):
    width, height = size
    base = Image.new('RGB', (width, height), colors[0])
    if len(colors) == 2:
        stops = [0, 1]
    else:
        stops = [0, 0.5, 1]
    # Calculate gradient vector
    angle_rad = math.radians(angle % 360)
    x_dir = math.sin(angle_rad)
    y_dir = math.cos(angle_rad)
    # For each pixel, compute its position along the gradient
    for y in range(height):
        for x in range(width):
            # Project (x, y) onto the gradient direction
            proj = (x * x_dir + y * y_dir) / (width * abs(x_dir) + height * abs(y_dir))
            proj = max(0, min(1, proj))
            if len(colors) == 2:
                c0, c1 = colors
                color = tuple(int(c0[i] + (c1[i] - c0[i]) * proj) for i in range(3))
            else:
                if proj < 0.5:
                    c0, c1 = colors[0], colors[1]
                    t = proj / 0.5
                else:
                    c0, c1 = colors[1], colors[2]
                    t = (proj - 0.5) / 0.5
                color = tuple(int(c0[i] + (c1[i] - c0[i]) * t) for i in range(3))
            base.putpixel((x, y), color)
    return base

def main():
    parser = argparse.ArgumentParser(description="Generate OG images for blogs.")
    parser.add_argument('--title', help='Title for the OG image (overrides BLOG.md)')
    parser.add_argument('--blog-md', help='Path to BLOG.md to extract title from H1')
    parser.add_argument('--logo', required=True)
    parser.add_argument('--bg-color', default="#0a0a0a")
    parser.add_argument('--author', required=True)
    parser.add_argument('--avatar', required=True)
    parser.add_argument('--code-block', help='Path to file to use as code block', required=True)
    parser.add_argument('--output', default="test.png")
    parser.add_argument('--bg-gradient-colors', help='Comma-separated list of 2 or 3 hex colors for a gradient background')
    parser.add_argument('--bg-gradient-angle', type=float, default=0, help='Gradient direction in degrees (0=top to bottom, 90=left to right, etc.)')
    parser.add_argument('--template', help='Name of template JSON in og/og-templates/ (without .json)')
    args = parser.parse_args()

    # Load template if provided
    template = DEFAULT_TEMPLATE.copy()
    if args.template:
        template_path = os.path.join(os.path.dirname(__file__), 'og-templates', args.template + '.json')
        if os.path.exists(template_path):
            with open(template_path, 'r') as f:
                user_template = json.load(f)
            template.update({k: v for k, v in user_template.items() if v is not None})
        else:
            print(f"Warning: Template {args.template} not found. Using default template.")

    # Use template values
    bg_color = template["bg_color"]
    bg_gradient_colors = template["bg_gradient_colors"]
    bg_gradient_angle = template["bg_gradient_angle"]
    title_font_color = template["title_font_color"]
    title_font = template["title_font"]
    outline_color = hex_to_rgb(template["outline_color"]) if isinstance(template["outline_color"], str) else tuple(template["outline_color"])
    code_font = template["code_font"]
    code_font_color = hex_to_rgb(template["code_font_color"]) if isinstance(template["code_font_color"], str) else tuple(template["code_font_color"])
    code_bg = hex_to_rgb(template["code_bg"]) if isinstance(template["code_bg"], str) else tuple(template["code_bg"])
    code_browser_bar_color = hex_to_rgb(template["code_browser_bar_color"]) if isinstance(template["code_browser_bar_color"], str) else tuple(template["code_browser_bar_color"])

    # Title logic
    title = args.title
    if not title and args.blog_md:
        title = extract_title_from_blog(args.blog_md)
    if not title:
        title = 'Untitled Blog Post'

    # Code block logic
    code = read_code_block(args.code_block)

    # Image size
    width, height = 1200, 630
    if args.bg_gradient_colors:
        color_list = [hex_to_rgb(c) for c in args.bg_gradient_colors.split(',')]
        img = create_linear_gradient((width, height), color_list, args.bg_gradient_angle)
    elif bg_gradient_colors:
        color_list = [hex_to_rgb(c) for c in bg_gradient_colors]
        img = create_linear_gradient((width, height), color_list, bg_gradient_angle)
    else:
        img = Image.new('RGB', (width, height), hex_to_rgb(bg_color))
    draw = ImageDraw.Draw(img)

    # Fonts
    font_title = load_font(FONT_PATH, FONT_SIZE_TITLE)
    font_author = load_font(FONT_PATH, FONT_SIZE_AUTHOR)
    font_code = load_font(MONO_FONT_PATH, FONT_SIZE_CODE)

    # Logo (left, top, keep aspect ratio, width=150px)
    logo = Image.open(args.logo).convert("RGBA")
    w_percent = LOGO_WIDTH / float(logo.size[0])
    h_size = int((float(logo.size[1]) * float(w_percent)))
    logo = logo.resize((LOGO_WIDTH, h_size), Image.LANCZOS)
    img.paste(logo, (PADDING, PADDING), logo)
    y_offset = PADDING + h_size + 32

    # Title (wrap to max width, left-aligned, increased line-height)
    title_lines = wrap_text(title, font_title, TITLE_MAX_WIDTH)
    title_line_height_extra = 24  # extra space between lines
    title_top_y = y_offset  # Store the top y position of the title
    for i, line in enumerate(title_lines):
        draw.text((PADDING, y_offset), line, font=font_title, fill=(255,255,255))
        bbox = font_title.getbbox(line)
        line_height = bbox[3] - bbox[1]
        if i < len(title_lines) - 1:
            y_offset += line_height + title_line_height_extra
        else:
            y_offset += line_height
    # Optionally, adjust or remove the following line for spacing before the next element
    y_offset += 8

    # Avatar (circle) and author (left-aligned, stacked)
    avatar = Image.open(args.avatar).convert("RGBA")
    avatar_circ = mask_circle(avatar, AVATAR_SIZE, outline_width=AVATAR_OUTLINE_WIDTH, gap=AVATAR_OUTLINE_GAP)
    avatar_total = AVATAR_SIZE + 2*(AVATAR_OUTLINE_WIDTH + AVATAR_OUTLINE_GAP)
    avatar_y = height - PADDING - avatar_total
    img.paste(avatar_circ, (PADDING, avatar_y), avatar_circ)
    draw.text((PADDING + avatar_total + 20, avatar_y + avatar_total//4), args.author, font=font_author, fill=(255,255,255))

    # Code block (right side, bleed to right and bottom, increased padding)
    code_x = width//2 + 40
    code_y = title_top_y  # Align code block top with title top
    code_w = width - code_x
    code_h = height - code_y
    code_block_left_pad = 48
    code_block_top_pad = 84
    draw_code_block(img, draw, code, code_x, code_y, code_w, code_h, font_code, code_block_left_pad, code_block_top_pad, outline_width=CODE_OUTLINE_WIDTH, gap=CODE_OUTLINE_GAP)

    img.save(args.output)
    print(f"OG image saved to {args.output}")

if __name__ == "__main__":
    main() 