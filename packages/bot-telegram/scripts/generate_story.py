import os
import sys
import json
import time
from datetime import datetime
from openai import OpenAI

# ==========================================
# CONFIGURATION
# ==========================================
# Replace 'YOUR_API_KEY_HERE' with your actual key, 
# or set it as an environment variable: export OPENAI_API_KEY="sk-..."
API_KEY = os.getenv("OPENAI_API_KEY", "YOUR_API_KEY_HERE")

# Model choice: gpt-4o is best for nuance, gpt-4o-mini is cheaper/faster
MODEL = "gpt-4o" 

# ==========================================
# THE VIRAL BRAIN (System Prompt)
# ==========================================
SYSTEM_PROMPT = """
You are an expert viral content screenwriter for TikTok and Reels, specializing in "Text Message Stories." 
Your goal is to generate scripts that maximize watch time, shares, and saves based on high-performing viral datasets.

THE VIRAL FORMULA:
1. **The Hook (0-3s):** Start immediately with high stakes, a weird question, or a "game."
2. **The Dynamic:** - Speaker A: The Rizzler/Prankster (Drives the convo).
   - Speaker B: The Victim/Crush (Reacts emotionally, blushes, gets annoyed).
3. **The Tone:** Short texts. Rapid fire. Gen Z slang (rizz, green flag, rn, omgg). Heavy emoji use.

OUTPUT FORMAT:
Return a SINGLE JSON object. Do not include markdown formatting like ```json.
The JSON must follow this exact structure:
{
  "viral_mechanics": {
    "genre": "String (e.g., Flirt, Prank, Sad)",
    "hook_strategy": "String (Brief explanation of the hook)",
    "visual_context_suggestion": "String (Background vibe/image)"
  },
  "script_content": [
    { "speaker": "A", "text": "..." },
    { "speaker": "B", "text": "..." }
  ]
}
"""

def generate_viral_story(user_direction):
    client = OpenAI(api_key=API_KEY)

    print(f"🧠 Brainstorming story for: '{user_direction}'...")

    try:
        response = client.chat.completions.create(
            model=MODEL,
            response_format={"type": "json_object"}, # Enforces valid JSON
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": f"Create a viral chat story based on this direction: '{user_direction}'. Make it roughly 10-20 lines long. Ensure Speaker B has a strong emotional reaction at the end."}
            ],
            temperature=0.8 # Slightly creative but consistent
        )

        content = response.choices[0].message.content
        return json.loads(content)

    except Exception as e:
        print(f"❌ Error generating story: {e}")
        return None

def save_to_file(data, prompt):
    # Create a safe filename from the prompt
    safe_prompt = "".join([c for c in prompt if c.isalnum() or c in (' ', '_')]).rstrip().replace(" ", "_")[:20]
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = f"story_{safe_prompt}_{timestamp}.json"
    
    with open(filename, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4, ensure_ascii=False)
    
    return filename

# ==========================================
# MAIN EXECUTION
# ==========================================
if __name__ == "__main__":
    # check if user provided an argument
    if len(sys.argv) < 2:
        print("Usage: python generate_story.py \"Your story idea here\"")
        print("Example: python generate_story.py \"Calculator trick\"")
        sys.exit(1)

    user_input = sys.argv[1]
    
    # Generate
    story_json = generate_viral_story(user_input)
    
    if story_json:
        # Save
        saved_file = save_to_file(story_json, user_input)
        
        # Display Preview
        print("\n✨ GENERATION SUCCESS! ✨")
        print("-" * 30)
        print(f"📂 Saved to: {saved_file}")
        print("-" * 30)
        print(f"🎭 Genre: {story_json['viral_mechanics']['genre']}")
        print(f"🎣 Hook: {story_json['viral_mechanics']['hook_strategy']}")
        print("-" * 30)
        for line in story_json['script_content']:
            print(f"{line['speaker']}: {line['text']}")
        print("-" * 30)