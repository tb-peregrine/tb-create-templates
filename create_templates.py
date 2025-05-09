import os
import subprocess
import time
import re
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

# Tinybird directory path
TINYBIRD_DIR = Path('tinybird')

def summarize_prompt(prompt):
    """
    Use OpenAI to summarize the prompt into 3-4 words with underscores.
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
    """
    # Fallback to a simple summary if OpenAI fails
    return prompt[:30].replace(' ', '_').lower()

def validate_build(directory, prompt, max_attempts=3):
    """
    Run 'tb build' in the directory and check for errors.
    If errors are found, retry tb create with a prompt to fix the error.
    Returns True if build is valid, False otherwise.
    """
    original_dir = os.getcwd()
    os.chdir(directory)
    
    for attempt in range(1, max_attempts + 1):
        try:
            print(f"Attempt {attempt}/{max_attempts}: Running tb build...")
            result = subprocess.run(['tb', 'build'], 
                                    check=False, 
                                    capture_output=True, 
                                    text=True)
            
            # Check if build was successful
            if result.returncode == 0:
                print("Build successful!")
                os.chdir(original_dir)
                return True
            
            # If we reach here, there was an error
            error_msg = result.stderr or result.stdout
            print(f"Build failed with error:\n{error_msg}")
            
            # Clean up for retry
            cleanup_current_dir()
            
            # Don't retry if this is the last attempt
            if attempt == max_attempts:
                break
                
            # Create a new prompt that includes the error
            fix_prompt = f"Fix the error in the Tinybird project: {error_msg}\n\nOriginal prompt: {prompt}"
            print(f"Retrying with error-fixing prompt...")
            
            # Run tb create with the new prompt
            subprocess.run(['tb', 'create', '--prompt', fix_prompt], check=False)
            
        except Exception as e:
            print(f"Error during build validation: {e}")
            
    # If we reach here, all attempts failed
    print(f"Failed to build after {max_attempts} attempts.")
    os.chdir(original_dir)
    return False

def cleanup_current_dir():
    """Clean up Tinybird-created directories in the current directory."""
    dirs_to_keep = ['.venv', '.git']
    files_to_keep = ['.tinyb', '.gitignore', 'requirements.txt']
    
    for item in Path('.').iterdir():
        if item.name not in dirs_to_keep and item.name not in files_to_keep:
            if item.is_dir():
                shutil.rmtree(item)
            elif item.is_file():
                os.remove(item)

def ensure_tinybird_dir():
    """Ensure the Tinybird directory exists."""
    if not TINYBIRD_DIR.exists():
        TINYBIRD_DIR.mkdir(parents=True)
    return TINYBIRD_DIR

def create_template(prompt, output_dir):
    """Create a template using tb create and move it to the output directory."""
    try:
        # Ensure tinybird directory exists
        tinybird_dir = ensure_tinybird_dir()
        
        # Save original directory
        original_dir = os.getcwd()
        
        # Change to tinybird directory for all operations
        os.chdir(tinybird_dir)
        
        # Create the template
        print(f"Creating template for: {prompt}")
        subprocess.run(['tb', 'create', '--prompt', prompt], check=True)
        
        # Get the summary for the new directory name
        summary = summarize_prompt(prompt)
        target_dir = Path(original_dir) / output_dir / summary
        
        # Create the target directory and required subdirectories
        os.makedirs(target_dir, exist_ok=True)
        required_dirs = ['datasources', 'pipes', 'materializations', 'fixtures', 'endpoints']
        for dir_name in required_dirs:
            os.makedirs(target_dir / dir_name, exist_ok=True)
        
        # Validate the build
        if not validate_build(os.getcwd(), prompt):
            print(f"Skipping template due to build validation failure: {prompt}")
            cleanup_current_dir()
            os.chdir(original_dir)
            return False
            
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
        
        # Return to original directory
        os.chdir(original_dir)
        
        print(f"Template created at: {target_dir}")
        return True
            
    except subprocess.SubprocessError as e:
        print(f"Error creating template: {e}")
        # Return to original directory in case of error
        if 'original_dir' in locals():
            os.chdir(original_dir)
        return False
    except Exception as e:
        print(f"Error processing template: {e}")
        # Return to original directory in case of error
        if 'original_dir' in locals():
            os.chdir(original_dir)
        return False

def cleanup_tinybird_dir():
    """Clean up Tinybird-created directories from the tinybird directory."""
    if not TINYBIRD_DIR.exists():
        return
        
    original_dir = os.getcwd()
    os.chdir(TINYBIRD_DIR)
    
    system_dirs = ['.venv', '.git']
    system_files = ['.tinyb', '.gitignore', 'requirements.txt']
    
    for item in Path('.').iterdir():
        if item.is_dir() and item.name not in system_dirs:
            shutil.rmtree(item)
        elif item.is_file() and item.name not in system_files:
            os.remove(item)
            
    os.chdir(original_dir)

def main():
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Create Tinybird templates from prompts.')
    parser.add_argument('--start', type=int, default=1, help='1-based index of the prompt to start from')
    parser.add_argument('--num_prompts', type=int, help='How many prompts to process before exiting')
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
    
    # Ensure tinybird directory exists
    ensure_tinybird_dir()
    
    # Process each prompt starting from the specified index
    prompts_to_process = prompts[args.start-1:args.start-1 + args.num_prompts] if args.num_prompts else prompts[args.start-1:]
    for i, prompt in enumerate(prompts_to_process, args.start):
        print(f"\nProcessing prompt {i}/{len(prompts)}")
        success = create_template(prompt, output_dir)
        if success:
            print(f"Successfully processed prompt {i}")
        else:
            print(f"Failed to process prompt {i}")
        time.sleep(2)  # Small delay between prompts
    
    # Clean up tinybird directory after all prompts are processed
    print("\nCleaning up tinybird directory...")
    cleanup_tinybird_dir()

if __name__ == "__main__":
    main() 