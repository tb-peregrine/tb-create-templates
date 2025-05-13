import os
import sys
import requests
import json
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

DEV_API_KEY = os.getenv('DEV_API_KEY')
IMGUR_CLIENT_ID = os.getenv('IMGUR_CLIENT_ID')
if not DEV_API_KEY:
    print('Error: DEV_API_KEY not set in environment.')
    sys.exit(1)

if len(sys.argv) < 2:
    print('Usage: python post_to_dev.py <markdown_file> [--dry-run]')
    sys.exit(1)

MARKDOWN_FILE = sys.argv[1]
DRY_RUN = '--dry-run' in sys.argv

with open(MARKDOWN_FILE, 'r', encoding='utf-8') as f:
    body_markdown = f.read()

# Use the first line as the title if it starts with '# ', else use the filename
lines = body_markdown.splitlines()
title = os.path.splitext(os.path.basename(MARKDOWN_FILE))[0].replace('_', ' ').title()
if lines and lines[0].startswith('# '):
    title = lines[0][2:].strip()
    body_markdown = '\n'.join(lines[1:]).lstrip()

# Always use these tags
TAGS = ['analytics', 'database', 'api', 'tutorial']

# Try to find og.png in the same directory as the markdown file and upload to Imgur
og_image_path = os.path.join(os.path.dirname(MARKDOWN_FILE), 'og.png')
cover_image_url = None
if os.path.isfile(og_image_path) and IMGUR_CLIENT_ID:
    print(f"Uploading og.png to Imgur...")
    with open(og_image_path, 'rb') as img_file:
        imgur_headers = {'Authorization': f'Client-ID {IMGUR_CLIENT_ID}'}
        imgur_data = {'type': 'file'}
        imgur_files = {'image': img_file}
        imgur_response = requests.post('https://api.imgur.com/3/image', headers=imgur_headers, files=imgur_files, data=imgur_data)
        if imgur_response.status_code == 200:
            cover_image_url = imgur_response.json()['data']['link']
            print(f"og.png uploaded to Imgur: {cover_image_url}")
        else:
            print(f"Failed to upload og.png to Imgur. Status: {imgur_response.status_code}")
            print(imgur_response.text)
elif os.path.isfile(og_image_path):
    print("og.png found, but IMGUR_CLIENT_ID is not set. Skipping cover image upload.")

article_data = {
    "title": title,
    "published": True,
    "body_markdown": body_markdown,
    "tags": TAGS,
    "organization_id": 6115
}
if cover_image_url:
    article_data["main_image"] = cover_image_url

data = {"article": article_data}

if DRY_RUN:
    print('DRY RUN: Would post the following data to DEV:')
    print(json.dumps(data, indent=2))
    sys.exit(0)

headers = {
    'api-key': DEV_API_KEY,
    'Content-Type': 'application/json',
    'User-Agent': 'tb-create-templates-script'
}

response = requests.post('https://dev.to/api/articles', headers=headers, json=data)

if response.status_code == 201:
    print('Article posted successfully!')
    print('DEV URL:', response.json().get('url'))
else:
    print('Failed to post article.')
    print('Status code:', response.status_code)
    print('Response:', response.text) 