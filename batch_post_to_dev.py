import time
import subprocess
from pathlib import Path

TEMPLATES_DIR = 'templates'
POST_SCRIPT = 'post_to_dev.py'
SLEEP_SECONDS = 2

def main():
    blog_files = list(Path(TEMPLATES_DIR).glob('*/BLOG.md'))
    total = len(blog_files)
    print(f"Found {total} BLOG.md files to post.")
    for i, blog_path in enumerate(blog_files, 1):
        print(f"[{i}/{total}] Posting {blog_path} ...")
        try:
            result = subprocess.run([
                'python', POST_SCRIPT, str(blog_path)
            ], capture_output=True, text=True)
            print(result.stdout)
            if result.returncode != 0:
                print(f"Error posting {blog_path}:")
                print(result.stderr)
        except Exception as e:
            print(f"Exception posting {blog_path}: {e}")
        time.sleep(SLEEP_SECONDS)
    print("\nBatch posting complete.")

if __name__ == "__main__":
    main() 