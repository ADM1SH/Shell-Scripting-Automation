#!/bin/bash
# === Gemini CLI Auto API Key Rotator ===

# List your keys here
KEYS=(
  "YOUR_API_KEY_HERE"
  "YOUR_API_KEY_HERE"
  "YOUR_API_KEY_HERE"
)

CURRENT_INDEX=0
MAX_INDEX=$(( ${#KEYS[@]} - 1 ))

run_gemini() {
  export GEMINI_API_KEY="${KEYS[$CURRENT_INDEX]}"
  echo "🔑 Using Gemini key $((CURRENT_INDEX + 1))..."
  
  # Run the command and capture output
  OUTPUT=$(gemini "$@" 2>&1)
  STATUS=$?

  # If quota exceeded (error 429), switch keys
  if echo "$OUTPUT" | grep -q "429"; then
    echo "⚠️ Quota exceeded on key $((CURRENT_INDEX + 1))."
    if [ $CURRENT_INDEX -lt $MAX_INDEX ]; then
      ((CURRENT_INDEX++))
      echo "🔄 Switching to key $((CURRENT_INDEX + 1))..."
      run_gemini "$@"
    else
      echo "❌ All keys exhausted for today."
      exit 1
    fi
  else
    echo "$OUTPUT"
    return $STATUS
  fi
}

run_gemini "$@"
