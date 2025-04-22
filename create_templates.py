import os
import subprocess
import time
from openai import OpenAI
from pathlib import Path
from dotenv import load_dotenv
import shutil
import argparse

# Load environment variables from .env file
load_dotenv()

# Configuration
OPENAI_API_KEY = os.getenv('OPENAI_API_KEY')
if not OPENAI_API_KEY:
    raise ValueError("OPENAI_API_KEY not found in .env file")
client = OpenAI(api_key=OPENAI_API_KEY)

def summarize_prompt(prompt):
    """Use OpenAI to summarize the prompt into 3-4 words with underscores."""
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "Summarize the following prompt into 3-4 words, using underscores instead of spaces. Focus on the main purpose or functionality."},
                {"role": "user", "content": prompt}
            ]
        )
        summary = response.choices[0].message.content.strip().replace(' ', '_').lower()
        return summary
    except Exception as e:
        print(f"Error summarizing prompt: {e}")
        # Fallback to a simple summary if OpenAI fails
        return prompt[:30].replace(' ', '_').lower()

def create_template(prompt, output_dir):
    """Create a template using tb create and move it to the output directory."""
    try:
        # Create the template
        print(f"Creating template for: {prompt}")
        subprocess.run(['tb', 'create', '--prompt', prompt], check=True)
        
        # Get the summary for the new directory name
        summary = summarize_prompt(prompt)
        target_dir = Path(output_dir) / summary
        
        # Create the target directory and required subdirectories
        os.makedirs(target_dir, exist_ok=True)
        required_dirs = ['datasources', 'pipes', 'materializations', 'fixtures', 'endpoints']
        for dir_name in required_dirs:
            os.makedirs(target_dir / dir_name, exist_ok=True)
        
        # Move files to their respective directories
        for dir_name in required_dirs:
            src_dir = Path(dir_name)
            if src_dir.exists():
                for file in src_dir.iterdir():
                    if file.is_file():
                        shutil.move(str(file), str(target_dir / dir_name / file.name))
        
        # Move README.md if it exists
        readme_src = Path('README.md')
        if readme_src.exists():
            shutil.move(str(readme_src), str(target_dir / 'README.md'))
        
        print(f"Template created at: {target_dir}")
            
    except subprocess.SubprocessError as e:
        print(f"Error creating template: {e}")
    except Exception as e:
        print(f"Error processing template: {e}")

def cleanup_root():
    """Clean up Tinybird-created directories from the root."""
    system_dirs = ['.venv', '.git']
    system_files = ['.tinyb', '.gitignore', 'prompts.txt', 'requirements.txt', '.env', '.env.example', 'create_templates.py']
    
    for item in Path('.').iterdir():
        if item.is_dir() and item.name not in system_dirs and item.name not in ['templates']:
            shutil.rmtree(item)
        elif item.is_file() and item.name not in system_files:
            os.remove(item)

def main():
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Create Tinybird templates from prompts.')
    parser.add_argument('--start', type=int, default=1, help='1-based index of the prompt to start from')
    args = parser.parse_args()
    
    # Read prompts from file
    with open('prompts.txt', 'r') as f:
        prompts = [line.strip() for line in f if line.strip()]
    
    # Validate start index
    if args.start < 1 or args.start > len(prompts):
        print(f"Error: Start index must be between 1 and {len(prompts)}")
        return
    
    # Create output directory
    output_dir = 'templates'
    os.makedirs(output_dir, exist_ok=True)
    
    # Process each prompt starting from the specified index
    for i, prompt in enumerate(prompts[args.start-1:], args.start):
        print(f"\nProcessing prompt {i}/{len(prompts)}")
        create_template(prompt, output_dir)
        time.sleep(2)  # Small delay between prompts
    
    # Clean up root directory after all prompts are processed
    print("\nCleaning up root directory...")
    cleanup_root()

if __name__ == "__main__":
    main() 