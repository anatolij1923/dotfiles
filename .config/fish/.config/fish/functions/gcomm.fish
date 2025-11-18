function gcomm
    # 1. Check if there are staged changes
    if git diff --cached --quiet
        echo "🔴 Nothing to commit (staging area is empty)."
        return 1
    end

    echo "Generating commit message..."

    # 2. Check API Key
    if not set -q GEMINI_API_KEY
        echo "❌ Error: GEMINI_API_KEY environment variable is not set!"
        return 1
    end

    # 3. git diff -> Python (make JSON) -> Curl (send request) -> Python (parse response)
    
    # Step A: Generate JSON payload (Python handles escaping safely)
    git diff --cached | python3 -c '
import sys, json
diff = sys.stdin.read()
prompt = "You are a commit generator. No tools. Git diff:\n" + diff + "\nWrite ONLY commit message (Conventional Commits). Concise bullet points."
payload = {
    "contents": [{"parts": [{"text": prompt}]}],
    "generationConfig": {"temperature": 0.2}
}
print(json.dumps(payload))
' | \
    # Step B: Send via CURL (faster networking than Python urllib)
    curl -s -X POST "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$GEMINI_API_KEY" \
    -H "Content-Type: application/json" \
    -d @- | \
    # Step C: Parse response
    python3 -c '
import sys, json
try:
    resp = json.load(sys.stdin)
    print(resp["candidates"][0]["content"]["parts"][0]["text"])
except Exception as e:
    print("❌ Error: " + str(resp) if "resp" in locals() else str(e))
'
end
