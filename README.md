# ✨ insta-assist

A beautiful, fast TUI (Terminal User Interface) for getting instant AI-powered command suggestions. Designed for quick popup usage with keyboard shortcuts.

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Go](https://img.shields.io/badge/Go-1.24+-00ADD8?logo=go)
![License](https://img.shields.io/badge/license-MIT-green)

## Install First

### One-liner (curl)

```bash
# Per-user installation
curl -fsSL https://raw.githubusercontent.com/dvroom-dev/instassist/master/install.sh | bash

# For a system-wide install with a proper /opt layout, prefer:
#   make install
# (builds as your user, then uses sudo only for the copy/link steps;
#  binary to /opt/instassist/inst with a symlink at /usr/local/bin/inst)
# If you still want a single-line install under /usr/local/bin:
curl -fsSL https://raw.githubusercontent.com/dvroom-dev/instassist/master/install.sh | PREFIX=/usr/local sudo bash
```

### Make targets

```bash
make install      # /opt/instassist + symlink at /usr/local/bin; schema beside binary + /usr/local/share/insta-assist (prompts for sudo when needed)
make user-install # ~/.local/bin (no sudo)
make go-install   # go install ./cmd/inst (GOBIN or GOPATH/bin)
```

### Manual build

```bash
make build
# or
go build -o inst ./cmd/inst
```

## Features

- **Fast & Lightweight**: Minimal TUI optimized for quick interactions
- **AI-Powered**: Get command suggestions from `codex`, or `claude` CLIs
- **Dual Modes**: Query mode for command options, Action mode for direct AI execution
- **Beautiful UI**: Color-coded interface with intuitive navigation
- **Flexible Output**: Copy to clipboard, execute directly, or output to stdout
- **Keyboard-Driven**: Fully keyboard navigable for maximum efficiency
- **Non-Interactive Mode**: Use via CLI for scripting and automation
- **Popup-Friendly**: Perfect for launching with desktop keyboard shortcuts

## Prerequisites

### Required

You need at least one of these AI CLIs installed:
- [codex](https://github.com/anthropics/anthropic-tools) - Anthropic's codex CLI
- [claude](https://github.com/anthropics/claude-cli) - Claude CLI

### Clipboard Support

For clipboard functionality, you need:
- **Linux**: Install `xclip` or `xsel`
  ```bash
  # Arch Linux
  sudo pacman -S xclip
  # or
  sudo pacman -S xsel

  # Debian/Ubuntu
  sudo apt install xclip
  # or
  sudo apt install xsel
  ```
- **macOS**: Works out of the box (uses built-in `pbcopy`)
- **Windows**: Works out of the box

## Usage

### Interactive TUI Mode

Launch the interactive interface:

```bash
inst
```

Or specify a default CLI:

```bash
inst -cli claude
```

### Keyboard Shortcuts

#### Input Mode
- `Enter` - Send prompt to AI (in Action mode: run immediately)
- `Ctrl+R` - Send prompt and auto-execute first result (Query mode only)
- `Ctrl+A` - Toggle between Query/Action mode
- `Ctrl+Y` - Toggle YOLO/auto-approve mode
- `Ctrl+N` / `Ctrl+P` - Switch CLI
- `Alt+Enter` or `Ctrl+J` - Insert newline
- `Ctrl+C` or `Esc` - Quit

#### Viewing Mode (Results)
- `Up/Down` or `j/k` - Navigate options (Query mode)
- `Enter` - Copy selected option and exit (Query) / New prompt (Action)
- `Ctrl+R` - Execute selected option and exit (Query mode only)
- `a` - Refine/append prompt in the same session (Query mode only)
- `n` - Start a new prompt
- `Ctrl+A` - Toggle between Query/Action mode
- `Ctrl+Y` - Toggle YOLO/auto-approve mode
- `Ctrl+N` / `Ctrl+P` - Switch CLI
- `Ctrl+C`, `Esc`, or `q` - Quit without action

### Refining Results (Session Resume)

- Press `a` in results to append a follow-up prompt; the existing options and prompt history stay visible.
- The app resumes the underlying session for each CLI:
  - codex: `codex exec resume <session-id> -`
  - claude: `--resume <session-id>`
- Press `n` to start a fresh session at any time.

### Query vs Action Mode

Toggle between modes with `Ctrl+A` or click the `query/action` toggle in the header.

#### Query Mode (default)
- Prompts the AI to return structured command options as JSON
- You select an option, then copy or execute it
- Supports refining results with `a` to continue the session

#### Action Mode
- Sends your prompt directly to the AI CLI without JSON constraints
- The AI performs the requested action immediately
- Output is displayed in the TUI when complete
- Press `Enter` or `n` to start a new prompt

**When to use each:**
- **Query**: "show me git commands for undoing commits" → get options to choose from
- **Action**: "create a README.md file for this project" → AI creates it directly

### YOLO / Auto-Approve

- Toggle via `Ctrl+Y` or click the `yolo:on/off` pill in the header.
- Flags applied when enabled:
  - codex: `--yolo`
  - claude: `--dangerously-skip-permissions`

### Mouse/Clicks

- CLI tabs, the query/action mode toggle, the YOLO toggle, and result options are all clickable in the TUI.
### CLI Mode (Non-Interactive)

Perfect for scripting and automation:

```bash
# Send prompt and copy first option to clipboard
inst -prompt "list files in current directory"

# Send prompt and output to stdout
inst -prompt "list files" -output stdout

# Execute the first option directly
inst -prompt "create a backup directory" -output exec

# Select specific option (0-based index)
inst -prompt "git commands" -select 0 -output stdout

# Read from stdin
echo "show disk usage" | inst -output stdout

# Use with specific CLI
inst -cli codex -prompt "docker commands"
inst -cli gemini -prompt "use rsync"
inst -cli opencode -prompt "write a kubectl one-liner"
```

### CLI Flags

| Flag | Default | Description |
|------|---------|-------------|
| `-cli` | `codex` | Choose AI CLI: `codex`, `claude`, `gemini`, or `opencode` |
| `-prompt` | - | Prompt for non-interactive mode |
| `-select` | `-1` | Auto-select option by index (0-based, -1 = first) |
| `-output` | `clipboard` | Output mode: `clipboard`, `stdout`, or `exec` |
| `-stay-open-exec` | `false` | Keep TUI open after Ctrl+R, show command stdout/stderr |
| `-version` | - | Print version and exit |

## Desktop Integration

### Linux (GNOME/KDE)

Create a keyboard shortcut that runs:

```bash
# For terminal emulator popup
gnome-terminal --geometry=100x30 -- inst

# Or with kitty
kitty --title "insta-assist" --override initial_window_width=1000 --override initial_window_height=600 inst

# Or with alacritty
alacritty --title "insta-assist" -e inst
```

Bind to a key like `Super+Space` or `Ctrl+Alt+A`.

### macOS

Create an automator Quick Action or use Hammerspoon:

```lua
-- Hammerspoon config
hs.hotkey.bind({"cmd", "ctrl"}, "space", function()
    hs.execute("/usr/local/bin/alacritty -e inst")
end)
```

### i3/sway

Add to your config:

```
# i3 config
bindsym $mod+space exec alacritty --class floating -e inst
for_window [class="floating"] floating enable

# sway config
bindsym $mod+space exec alacritty --class floating -e inst
for_window [app_id="floating"] floating enable
```

## How It Works

### Query Mode (default)
1. You enter a prompt describing what you want to do
2. insta-assist sends it to your chosen AI CLI (codex, claude) with a JSON schema
3. The AI returns structured options with descriptions
4. You select an option and choose to copy it or run it directly
5. The app exits, ready for your next quick query

### Action Mode
1. You enter a prompt describing an action you want performed
2. insta-assist sends the raw prompt to the AI CLI
3. The AI executes the action directly (e.g., creates files, modifies code)
4. Output is displayed in the TUI
5. Press Enter or `n` to start a new prompt

## Examples

**Prompt:** "git commit with message"
```
Options:
▶ git commit -m "message"
  Create a commit with inline message

  git commit
  Open editor for commit message
```

**Prompt:** "compress images in current dir"
```
Options:
▶ find . -name "*.jpg" -exec convert {} -quality 85 {} \;
  Compress all JPG files to 85% quality

  mogrify -quality 85 *.jpg
  Compress using ImageMagick mogrify
```

## Development

### Build & Test

```bash
# Show all make targets
make help

# Build
make build

# Test
make test

# Run
make run

# Clean
make clean
```

### Project Structure

```
insta-assist/
├── main.go             # Flags and entrypoint routing
├── ui.go               # Bubble Tea model, rendering, key handling
├── noninteractive.go   # CLI-only execution flow
├── prompt.go           # Prompt building, schema resolution, JSON parsing
├── options.schema.json # JSON schema for AI responses
├── Makefile            # Build and installation
├── README.md           # Documentation
├── go.mod              # Go dependencies (Go 1.24.x)
└── go.sum              # Dependency checksums
```

## Configuration

The app looks for `options.schema.json` in these locations (in order):
1. Same directory as the binary (e.g., `/opt/instassist/` when using `make install`)
2. Current working directory
3. `/usr/local/share/insta-assist/`

## Troubleshooting

**"schema not found" error**
- The binary embeds the schema and will write a temp copy if none is found. If it still fails, ensure the temp directory is writable.
- Alternatively place `options.schema.json` in the same directory as the binary (e.g., `/opt/instassist/`) or install with `make install` to copy to both the binary directory and `/usr/local/share/insta-assist/`.

**AI CLI not found**
- Make sure one of the supported AI CLIs is installed and in your PATH: `codex`, or `claude`
- Test with `codex --version`, or `claude --version`

**Clipboard not working**
- **Linux**: Make sure `xclip` or `xsel` is installed
  ```bash
  # Test if xclip is available
  which xclip
  # or
  which xsel
  ```
- If clipboard fails, you can use CLI mode with `-output stdout` instead:
  ```bash
  inst -prompt "your prompt" -output stdout
  ```

**Colors not showing**
- Ensure your terminal supports 256 colors
- Try `echo $TERM` - should be `xterm-256color` or similar

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - see LICENSE file for details

## Credits

Built with:
- [Bubble Tea](https://github.com/charmbracelet/bubbletea) - TUI framework
- [Lipgloss](https://github.com/charmbracelet/lipgloss) - Styling
- [Bubbles](https://github.com/charmbracelet/bubbles) - TUI components

## Roadmap

- [ ] Custom keybindings configuration
- [ ] History of previous prompts
- [ ] Multiple AI provider support
- [ ] Custom prompt templates
- [ ] Configuration file support
- [ ] Shell completion scripts

---

**Made with ❤️ for terminal enthusiasts**
