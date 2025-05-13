import os
import subprocess

TEMPLATES_DIR = 'templates'
OG_SCRIPT = 'og/generate_og_images.py'
DEFAULT_TEMPLATE = 'default'
LOGO = 'og/logotype_white.png'  # Change to your logo path
AVATAR = 'og/peregrine.jpeg'   # Change to your avatar path
AUTHOR = 'Cameron Archer'           # Change to your author name
CODE_BLOCK = None              # Will try to find a .pipe file in the template, else use placeholder

def find_code_block_file(root):
    # 1. Check endpoints/ for .pipe
    endpoints_dir = os.path.join(root, 'endpoints')
    if os.path.isdir(endpoints_dir):
        for f in os.listdir(endpoints_dir):
            if f.endswith('.pipe'):
                return os.path.join(endpoints_dir, f)
    # 2. Check datasources/ for .datasource
    datasources_dir = os.path.join(root, 'datasources')
    if os.path.isdir(datasources_dir):
        for f in os.listdir(datasources_dir):
            if f.endswith('.datasource'):
                return os.path.join(datasources_dir, f)
    # 3. Check root for .pipe or .datasource
    for f in os.listdir(root):
        if f.endswith('.pipe'):
            return os.path.join(root, f)
        if f.endswith('.datasource'):
            return os.path.join(root, f)
    # 4. Fallback: use BLOG.md
    return os.path.join(root, 'BLOG.md')

for root, dirs, files in os.walk(TEMPLATES_DIR):
    if 'BLOG.md' in files:
        blog_md_path = os.path.join(root, 'BLOG.md')
        og_path = os.path.join(root, 'og.png')
        code_block_path = find_code_block_file(root)
        cmd = [
            'python', OG_SCRIPT,
            '--blog-md', blog_md_path,
            '--logo', LOGO,
            '--author', AUTHOR,
            '--avatar', AVATAR,
            '--code-block', code_block_path,
            '--output', og_path,
            '--template', DEFAULT_TEMPLATE
        ]
        print(f"Generating OG image for {blog_md_path} ...")
        subprocess.run(cmd)
print("Batch OG image generation complete.")

# To customize logo/avatar/author/code-block, edit the variables at the top of this script. 