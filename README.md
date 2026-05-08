# Terminal Banner Setup

This repository contains a simple, interactive, single-line terminal banner setup script. It uses `figlet` to generate a customized block-letter banner (inspired by professional terminal styles) with a dual-color text split, custom borders, and your own slogan and website.

## Features
- **Interactive Setup**: Automatically prompts you for your Name, Slogan, and Website right from the terminal.
- **Dual-Color Output**: Dynamically splits your text into a blue left half and a red right half.
- **Auto-Configures Shell**: Automatically adds the banner to your `~/.bashrc` and `~/.zshrc` files.
- **No Manual Edits Needed**: Uses `</dev/tty` so it safely works even when run via curl-to-bash!

## One-Line Installation

You can install this directly from the terminal without downloading the code manually. Just run the following command:

```bash
curl -sL https://raw.githubusercontent.com/rubeltechcom/Termenal/main/banner.sh | bash
```

*(Note: If you are cloning or forking this repository, make sure to replace `YOUR_GITHUB_USERNAME` and `YOUR_REPO_NAME` in the link above with your actual GitHub details).*

## How It Works
1. When you run the command, the script downloads required dependencies (`figlet`, `wget`).
2. It fetches the "ANSI Shadow" font for the specific blocky look.
3. It asks you what you want your terminal to say.
4. It compiles a lightweight bash script `~/.custom_banner.sh` and saves your ASCII art inside `~/.custom_banner_text.txt`.
5. Finally, it links the script to your terminal startup profile so it launches every time you open a new terminal tab.

Enjoy your customized terminal experience!
