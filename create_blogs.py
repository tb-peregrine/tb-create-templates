import os
import re
import json
from pathlib import Path
from dotenv import load_dotenv
from openai import OpenAI
import glob
import argparse
import time
from tqdm import tqdm

# Load environment variables from .env file
load_dotenv()

# Configure OpenAI client
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
if not OPENAI_API_KEY:
    raise ValueError("OPENAI_API_KEY not found in .env file")

client = OpenAI(api_key=OPENAI_API_KEY)

def read_file(file_path):
    """Read content from a file"""
    with open(file_path, 'r') as f:
        return f.read()

def write_file(file_path, content):
    """Write content to a file"""
    with open(file_path, 'w') as f:
        f.write(content)

def get_system_prompt():
    """Get the system prompt for blog post generation"""
    try:
        return read_file('blog-system-prompt.txt')
    except FileNotFoundError:
        raise ValueError("blog-system-prompt.txt not found. Please create this file first.")

def get_fixtures_content(template_dir):
    """Get content from all fixtures files in the template"""
    fixtures_dir = Path(template_dir) / 'fixtures'
    fixtures_content = ""
    
    if fixtures_dir.exists():
        fixture_files = list(fixtures_dir.glob('*'))
        for file in fixture_files:
            if file.is_file():
                fixtures_content += f"\n### Fixture: {file.name}\n```json\n{read_file(file)}\n```\n"
    
    return fixtures_content

def get_datasource_content(template_dir):
    """Get content from all datasource files in the template"""
    datasources_dir = Path(template_dir) / 'datasources'
    datasource_content = ""
    
    if datasources_dir.exists():
        datasource_files = list(datasources_dir.glob('*'))
        for file in datasource_files:
            if file.is_file():
                datasource_content += f"\n### Datasource: {file.name}\n```\n{read_file(file)}\n```\n"
    
    return datasource_content

def get_pipes_content(template_dir):
    """Get content from all pipes in the template"""
    pipes_dir = Path(template_dir) / 'pipes'
    endpoints_dir = Path(template_dir) / 'endpoints'
    materializations_dir = Path(template_dir) / 'materializations'
    
    pipes_content = ""
    
    # Process materializations
    if materializations_dir.exists():
        materialization_files = list(materializations_dir.glob('*'))
        if materialization_files:
            pipes_content += "\n### Materialized Views:\n"
            for file in materialization_files:
                if file.is_file():
                    pipes_content += f"\n#### {file.name}\n```\n{read_file(file)}\n```\n"
    
    # Process endpoints
    if endpoints_dir.exists():
        endpoint_files = list(endpoints_dir.glob('*'))
        if endpoint_files:
            pipes_content += "\n### Endpoints:\n"
            for file in endpoint_files:
                if file.is_file():
                    pipes_content += f"\n#### {file.name}\n```\n{read_file(file)}\n```\n"
    
    # Process other pipes
    if pipes_dir.exists():
        pipe_files = list(pipes_dir.glob('*'))
        if pipe_files:
            pipes_content += "\n### Other Pipes:\n"
            for file in pipe_files:
                if file.is_file():
                    pipes_content += f"\n#### {file.name}\n```\n{read_file(file)}\n```\n"
    
    return pipes_content

def generate_blog_post(readme_content, template_dir):
    """Generate a blog post from README.md content using OpenAI"""
    system_prompt = get_system_prompt()
    
    # Get additional content to help the model
    fixtures_content = get_fixtures_content(template_dir)
    datasource_content = get_datasource_content(template_dir)
    pipes_content = get_pipes_content(template_dir)
    
    # Construct the user message with all relevant information
    user_message = f"""
# Original README.md
{readme_content}

# Additional Template Files
## Fixtures
{fixtures_content if fixtures_content else "No fixtures found."}

## Datasources
{datasource_content if datasource_content else "No datasources found."}

## Pipes
{pipes_content if pipes_content else "No pipes found."}

Please transform this README.md into a tutorial-style blog post according to the guidelines provided.
"""

    try:
        # Use GPT-4 for high-quality technical writing
        response = client.chat.completions.create(
            model="gpt-4-turbo-preview",  # Best model for technical content generation
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_message}
            ],
            temperature=0.7,  # Slightly creative but still factual
            max_tokens=4000,  # Generous token limit for comprehensive blog posts
        )
        
        blog_content = response.choices[0].message.content
        return blog_content
    except Exception as e:
        print(f"Error generating blog post: {e}")
        return None

def process_template(template_dir, force=False, rewrite=False):
    """Process a single template directory to create a BLOG.md file"""
    readme_path = Path(template_dir) / 'README.md'
    blog_path = Path(template_dir) / 'BLOG.md'
    
    # Skip if README.md doesn't exist
    if not readme_path.exists():
        print(f"Warning: No README.md found in {template_dir}. Skipping.")
        return False
    
    # Check if BLOG.md already exists
    blog_exists = blog_path.exists()
    
    # Skip if BLOG.md already exists and neither force nor rewrite flags are set
    if blog_exists and not (force or rewrite):
        print(f"BLOG.md already exists in {template_dir}. Use --force or --rewrite to regenerate.")
        return False
    
    # Read README.md content
    readme_content = read_file(readme_path)
    
    # Generate blog post
    print(f"{'Regenerating' if blog_exists else 'Generating'} blog post for {template_dir}...")
    blog_content = generate_blog_post(readme_content, template_dir)
    
    if blog_content:
        # Write BLOG.md file
        write_file(blog_path, blog_content)
        print(f"Successfully {'rewrote' if blog_exists else 'created'} BLOG.md in {template_dir}")
        return True
    else:
        print(f"Failed to {'rewrite' if blog_exists else 'create'} BLOG.md in {template_dir}")
        return False

def main():
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Generate blog posts from template READMEs.')
    parser.add_argument('--force', action='store_true', help='Overwrite existing BLOG.md files for specific templates')
    parser.add_argument('--rewrite', action='store_true', help='Rewrite all BLOG.md files for all templates')
    parser.add_argument('--template', type=str, help='Process a specific template directory')
    parser.add_argument('--limit', type=int, help='Limit the number of templates to process')
    args = parser.parse_args()
    
    # Find all template directories
    base_dir = Path('templates')
    if not base_dir.exists():
        raise ValueError("Templates directory not found. Make sure you're running this script from the project root.")
    
    if args.template:
        # Process a specific template
        template_path = base_dir / args.template
        if not template_path.exists():
            raise ValueError(f"Template directory {args.template} not found.")
        template_dirs = [template_path]
    else:
        # Get all subdirectories in templates/
        template_dirs = [d for d in base_dir.iterdir() if d.is_dir()]
        
        # Apply limit if specified
        if args.limit and args.limit > 0:
            template_dirs = template_dirs[:args.limit]
    
    # Process each template directory
    success_count = 0
    skipped_count = 0
    total_count = len(template_dirs)
    
    # Use tqdm for a progress bar
    for template_dir in tqdm(template_dirs, desc="Processing templates"):
        if process_template(template_dir, args.force, args.rewrite):
            success_count += 1
        elif (Path(template_dir) / 'BLOG.md').exists():
            skipped_count += 1
        # Add a small delay to avoid rate limiting
        time.sleep(1)
    
    print(f"\nCompleted: {success_count}/{total_count} blog posts generated successfully.")
    if skipped_count > 0:
        print(f"Skipped: {skipped_count} templates that already had BLOG.md files.")
        print(f"Use --rewrite to regenerate all blog posts or --force with --template to regenerate specific ones.")

if __name__ == "__main__":
    main() 