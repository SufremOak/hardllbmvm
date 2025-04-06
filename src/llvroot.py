import sys
import subprocess
import os
import argparse

def run_command(command):
    """Run a command in the shell and return the output."""
    try:
        result = subprocess.run(command, shell=True, check=True, text=True, capture_output=True)
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Command '{command}' failed with error: {e.stderr}")
        sys.exit(1)

def get_llvm_root():
    """Get the LLVM root directory."""
    # Check if LLVM_ROOT is set
    llvm_root = os.environ.get('LLVM_ROOT')
    if llvm_root:
        return llvm_root

    # Check if llvm-config is available
    try:
        llvm_config_path = run_command("which llvm-config").strip()
        if not llvm_config_path:
            raise FileNotFoundError("llvm-config not found in PATH.")
        
        # Get the LLVM installation directory
        llvm_root = run_command(f"{llvm_config_path} --prefix").strip()
        return llvm_root
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
    return None

def main():
    parser = argparse.ArgumentParser(description="Get the LLVM root directory.")
    args = parser.parse_args()

    llvm_root = get_llvm_root()
    print(f"LLVM root directory: {llvm_root}")
    # Optionally, you can set the LLVM_ROOT environment variable
    os.environ['LLVM_ROOT'] = llvm_root
    # You can also print the LLVM_ROOT variable to verify
    print(f"LLVM_ROOT environment variable set to: {os.environ['LLVM_ROOT']}")
    # Optionally, you can return the LLVM root directory
    return llvm_root
if __name__ == "__main__":
    main()