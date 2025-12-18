# VIRAL CHAT STORY GENERATOR

**Attach dataset:** `chat-stories_v0-0-1.json` (required)

---

## THE ONE RULE

**Before writing anything, read 2-3 examples from the dataset that match your pattern.**

Don't invent. Learn from what already worked (600K-7M views).

---

## WHAT MAKES THEM FEEL REAL

### 1. Casual Mistakes (1-3 per story)

Real people make small typos when texting:

- Missing spaces: "ihave", "wanna"
- Casual spelling: "Okey", "ahmm"
- Missing apostrophes: "dont", "cant", "im"
- Shortcuts: "u", "rn", "wbu"

**Don't overdo it.** 1-2 small mistakes = authentic. 5+ mistakes = trying too hard.

---

### 2. Emotion Shows in Formatting

- Lowercase when vulnerable: "today drained me"
- All caps when excited: "I'M SCREAMING"
- Ellipsis when trailing off: "I don't know.."
- Repeated punctuation for emphasis: "stop please.."

---

### 3. How Emojis Work

- 1-3 per message (not 0, not 5)
- Each person has favorites (A uses 😎, B uses 🤗)
- Reactions escalate (🤗 → 🤭 → 😭❤️)

Your genre prompt tells you which emojis to use.

---

### 4. Natural Speech Patterns

- Pet names used multiple times: "babe", "love", "baby"
- Sometimes no question marks when rushing: "Why"
- Cut off mid-thought: "I was just soo stup-"

---

## MESSAGE LENGTH

**Short messages:** 3-8 words  
**Key emotional lines:** 10-15 words (this is fine!)  
**Don't overthink it.** Vary the length naturally.

---

## TIMING (delay_ms)

**Fast banter:** 1000-1500ms  
**Emotional moments:** 2000-2500ms  
**Heavy sad stuff:** 3000-4000ms  
**Same person continuing:** 800ms

Match the emotion to the pause.

---

## WHAT YOUR GENRE PROMPT TELLS YOU

Each genre (Flirt/Love/Sad/Funny) has different:

- Patterns that work (proven by the dataset)
- Emoji choices
- Message counts
- Timing speeds
- What endings work

**Read your genre prompt + dataset examples. That's your blueprint.**

---

## OUTPUT FORMAT

Keep it simple:

```json
{
	"inspiration": "Based on [story_id] from dataset",
	"hook": "One sentence what happens",
	"script": [
		{ "speaker": "A", "text": "...", "delay_ms": 1200 },
		{ "speaker": "B", "text": "...", "delay_ms": 1500 }
	]
}
```

If your genre needs visual overlay (Love/Sad/Funny), add:

```json
"visual_overlay": "Type of relationship i need"
```

---

## THE WORKFLOW

1. **Read your genre prompt** (Flirt, Love, Sad, or Funny)
2. **Find similar examples in dataset** (2-3 stories)
3. **Notice the pattern** (structure, length, reactions)
4. **Create YOUR version** (different content, same structure)
5. **Add authenticity** (1-2 typos, casual language)
6. **Check it sounds real** (would real people text like this?)

---

## COMMON MISTAKES TO AVOID

❌ Perfect grammar everywhere (too formal)  
❌ Inventing new patterns not in dataset (untested)  
❌ Too many emojis (overwhelming)  
❌ No typos at all (too polished)  
❌ Generic reactions (make them specific)

✅ Learn from dataset  
✅ Add small mistakes  
✅ Make reactions match personality  
✅ Keep it natural

---

## REMEMBER

The dataset shows you what works. Your genre prompt shows you how to apply it.

**Don't copy the dataset stories word-for-word. Learn the pattern, then create something new in that style.**

That's it. Now go to your genre prompt and start creating.
