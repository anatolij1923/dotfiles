function gdo
    if not set -q GEMINI_API_KEY
        echo "API Key not found!"
        return 1
    end

    if test -z "$argv"
        echo "Usage: gdo <request>"
        return 1
    end


    echo -n "Thinking..."
    
    set -x CMD_REQ "$argv"
    
    # --- 1. System Context ---
    set -l DISTRO_NAME "Linux"
    if test -f /etc/os-release
        set DISTRO_NAME (grep "^NAME=" /etc/os-release | cut -d= -f2 | tr -d '"')
    end

    # --- 2. Modern Tools Detection ---
    # Check for modern alternatives to prioritize them in generation
    set -l MODERN_TOOLS_CHECKLIST \
        bat eza exa lsd rg fd fzf zoxide delta \
        jq yq gh lazygit btop htop ncdu tldr \
        yay paru pnpm bun deno docker podman \
        kubectl terraform nvim helix code fastfetch \
        wl-copy xclip

    set -l INSTALLED_MODERN_TOOLS
    for tool in $MODERN_TOOLS_CHECKLIST
        if type -q $tool
            set -a INSTALLED_MODERN_TOOLS $tool
        end
    end

    # --- 3. User Scripts Detection ---
    # Scan user bin directories for custom scripts
    set -l USER_BIN_PATHS $HOME/.local/bin $HOME/.npm-global/bin $HOME/.cargo/bin
    set -l USER_SCRIPTS
    for bin_path in $USER_BIN_PATHS
        if test -d $bin_path
            set -a USER_SCRIPTS (find $bin_path -maxdepth 1 -type f -executable -printf "%f\n" 2>/dev/null)
        end
    end

    set -l TOOLS_LIST (string join ", " $INSTALLED_MODERN_TOOLS $USER_SCRIPTS)
    
    # Export for Python environment
    set -x CTX_OS "$DISTRO_NAME"
    set -x CTX_TOOLS "$TOOLS_LIST"

    # --- Generation ---

    set -l SUGGESTED_CMD (python3 -c '
import sys, json, os

req = os.environ.get("CMD_REQ", "")
ctx_os = os.environ.get("CTX_OS", "Linux")
ctx_tools = os.environ.get("CTX_TOOLS", "")

prompt = f"""You are a Linux Command Generator.
Target System: {ctx_os}
User specific tools: [{ctx_tools}]

User Request: "{req}"

Return ONLY the shell command string.
Rules:
1. PRIORITY: Use installed modern tools (e.g. "bat" > "cat", "yay" > "pacman") if available.
2. Context: If user asks to run a script found in the list, use it.
3. Syntax: Use valid Fish shell syntax.
4. Output: Raw command string only. No markdown."""

payload = {
    "contents": [{"parts": [{"text": prompt}]}],
    "generationConfig": {"temperature": 0.1}
}
print(json.dumps(payload))
' | \
    curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$GEMINI_API_KEY" \
    -H "Content-Type: application/json" \
    -d @- | \
    python3 -c '
import sys, json
try:
    resp = json.load(sys.stdin)
    print(resp["candidates"][0]["content"]["parts"][0]["text"].strip())
except:
    pass
')

    # Clear "Thinking..." line
    echo -ne "\r\033[K"

    if test -z "$SUGGESTED_CMD"
        echo "Failed to generate command."
        return 1
    end

    # --- Execution / Confirmation ---
    echo -n "Execute: "
    set_color -o green
    echo -n "$SUGGESTED_CMD"
    set_color normal
    
    # Added 'c' option for Copy
    echo -n " ? [y/N/c] "
    
    read -l confirm
    if string match -qi 'y' -- $confirm
        echo ""
        eval $SUGGESTED_CMD
    else if string match -qi 'c' -- $confirm
        echo ""
        # Try to detect clipboard tool (Wayland/X11/Mac)
        if type -q wl-copy
            echo -n "$SUGGESTED_CMD" | wl-copy
            echo "Copied to clipboard (wl-copy)."
        else if type -q xclip
            echo -n "$SUGGESTED_CMD" | xclip -selection clipboard
            echo "Copied to clipboard (xclip)."
        else if type -q pbcopy
            echo -n "$SUGGESTED_CMD" | pbcopy
            echo "Copied to clipboard."
        else
            echo "No clipboard utility found (install wl-copy or xclip)."
        end
    else
        echo "Cancelled."
    end
end
