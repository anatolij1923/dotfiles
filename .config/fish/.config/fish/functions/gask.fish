function gask
    if test -z "$argv"
        echo "❌ Usage: gask <question>"
        return 1
    end
    
    echo "🤔 Asking Gemini..."
    
    # Combine arguments into a single string
    set -x QUESTION "$argv"
    
    # Pipeline
    python3 -c '
import sys, json, os
q = os.environ.get("QUESTION", "")
prompt = "You are a Linux CLI expert. User asks: " + q + "\nProvide the command(s) to achieve this. Be concise. No chatter. If explanation is needed, keep it short."
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
    print(resp["candidates"][0]["content"]["parts"][0]["text"])
except:
    print("❌ Error parsing response")
'
end
