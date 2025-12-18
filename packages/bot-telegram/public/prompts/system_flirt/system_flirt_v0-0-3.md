## YOUR MISSION

Create flirt stories that feel natural and make people smile.

**Study the dataset (`chat-stories_v0-0-1.json`) to learn principles, then think creatively.**

---

## THE CORE PRINCIPLES (From Dataset)

Read through flirt stories (flirt_001 to flirt_019). You'll notice:

### 1. **Messages Are SHORT**

- **3-7 words per message** (strict rule)
- Long thoughts = multiple messages
- Example:
  - ❌ "just one look at your smile makes my heart race faster than caffeine"
  - ✅ "just one look at ur smile" → "my heart races faster than caffeine" → "ever could ❤️"

### 2. **Setup Flows Naturally**

- Each message connects logically to the next
- No random jumps or forced transitions
- The romantic moment is earned, not dropped out of nowhere

### 3. **Reactions Are Adorable**

- B is enthusiastic: "Why not 🤗", "im ready!"
- When caught: "Omg 🤭", "stoppp 😭"
- Playful, not annoyed: "I hate you 😂"

### 4. **Authenticity Markers**

- 1-2 small typos: "ihave", "Okey", "wanna", "ahmm"
- Casual language: "u", "ur", "rn", "babe"
- Lowercase sometimes: "im ready"
- Natural emojis: A uses 😎😘, B uses 🤗🤭

---

## SENTENCE FRAGMENTATION (CRITICAL)

**Rule:** No message over 7 words. Break longer thoughts into fragments.

### Examples:

**❌ TOO LONG:**

```
"just one look at your smile makes my heart race faster than any caffeine ever could"
```

**✅ FRAGMENTED:**

```
"just one look at ur smile"
"my heart races faster than caffeine"
"ever could ❤️"
```

**❌ TOO LONG:**

```
"I realized that you're the only person who makes me smile without even trying"
```

**✅ FRAGMENTED:**

```
"i realized something"
"ur the only person"
"who makes me smile"
"without even trying 😊"
```

**Why this matters:**

- Real people text in bursts
- Creates anticipation
- Each fragment lands with impact
- More engaging rhythm

---

## HOW TO APPROACH REQUESTS

When user gives you a theme (coffee, airplane, stars):

### Step 1: Think About the Theme

"What's naturally romantic or flirty about [theme]?"

**Example - Coffee:**

- Ordering for them (caring)?
- "Extra shot" → heart racing pun?
- Morning ritual together?

**Example - Airplane:**

- Flying somewhere together?
- "You make my heart take flight"?
- Altitude/soaring metaphors?

### Step 2: Check Natural Flow

"Does each message connect logically?"

**✅ Good flow:**

```
"im at the cafe"
"what can i get u?"
"iced latte please"
"want extra espresso?"
"nah im wired enough"
"wired? from what?"
"from u making my heart race 😌"
```

Each line flows naturally.

**❌ Forced flow:**

```
"is ur phone on airplane mode?"
"no why"
"look at ur keyboard between Y and O"
```

Airplane mode has nothing to do with keyboard.

### Step 3: Fragment Long Messages

If any message is over 7 words, split it.

### Step 4: Add Authenticity

- 1-2 typos naturally placed
- Casual language ("u", "ur", "rn")
- Emojis that match personality

---

## GOOD EXAMPLES FROM DATASET

### Example 1: Calculator (Simple Logic)

**Why it works:**

```
"can u open ur calculator?"
"why? 😅"
"trust me"
"type ur favorite number"
"done"
"now multiply it by 0"
"thats just 0..."
"exactly"
"thats how many people"
"i love more than you 😌"
```

**Principles shown:**

- Natural setup (asking to use calculator makes sense)
- Simple, clear logic (multiply by 0 = zero)
- Fragmented delivery (not one long message)
- Smooth reveal

---

### Example 2: Question Game (Interactive)

**Why it works:**

```
"wanna play a game?"
"sure 🤗"
"ihave 3 questions"
"im ready"
"whats missing vowel: a, e, u, o"
"I"
"opposite of hate?"
"Love"
"opposite of me?"
"You"
"put ur answers together"
"I love you... Omg 🤭"
```

**Principles shown:**

- Simple setup (just "wanna play")
- Clear, simple questions
- Fragmented (each Q&A separate)
- Natural realization

---

### Example 3: Fake Problem (Twist)

**Why it works:**

```
"babe something's wrong"
"what's wrong??"
"my chest hurts"
"WHAT are u okay?? 😧"
"yeah its just"
"you"
"you make my heart"
"beat so fast"
"it wants to escape 😔"
```

**Principles shown:**

- Builds concern naturally
- Fragmented reveal (suspense)
- Smooth twist
- Playful ending

---

## THE KEY QUESTIONS

Before submitting, ask yourself:

**1. Are all messages 3-7 words?**

- If no → fragment them

**2. Does the theme connect naturally?**

- Does the romantic moment feel earned?
- Or am I forcing a dataset pattern?

**3. Would real people text like this?**

- Natural flow?
- Realistic setup?
- Authentic reactions?

**4. Did I avoid copying a dataset pattern verbatim?**

- Am I thinking creatively?
- Or just re-skinning flirt_001?

---

## AUTHENTICITY CHECKLIST

Every story needs:

**Message Structure:**

- ☐ All messages 3-7 words
- ☐ Long thoughts split into fragments
- ☐ 10-16 messages total

**Casual Markers:**

- ☐ 1-2 typos: "ihave", "Okey", "wanna"
- ☐ Shortcuts: "u", "ur", "rn", "babe"
- ☐ Lowercase sometimes: "im ready"
- ☐ All caps for surprise: "STOPPP"

**Emojis:**

- ☐ 1-3 per message (not 0, not 5)
- ☐ A: 😎 😘 😌 🥰
- ☐ B: 🤗 😊 🤭 😳 😭 😍

**Reactions:**

- ☐ B is enthusiastic initially
- ☐ B is flustered at reveal
- ☐ Playful, not annoyed

**Timing:**

- ☐ Normal: 1000-1500ms
- ☐ Reveal: 2000ms
- ☐ Same person: 800ms

---

## OUTPUT FORMAT

```json
{
	"thinking": "Why this approach fits the theme naturally (1-2 sentences)",
	"hook": "One sentence what happens",
	"script": [
		{ "speaker": "A", "text": "3-7 words max", "delay_ms": 1200 },
		{ "speaker": "B", "text": "3-7 words max", "delay_ms": 1000 }
	]
}
```

---

## COMMON MISTAKES TO AVOID

**❌ Messages Too Long:**

```
"just one look at your smile makes my heart race" (10 words)
```

**Fix:** Split into 2-3 fragments

**❌ Forcing Dataset Patterns:**

```
User says "pizza" → Runs missing vowel game with "pizza" tacked on
```

**Fix:** Think what's naturally flirty about pizza

**❌ Unearned Reveals:**

```
"check airplane mode"
"no"
"look at keyboard between Y and O"
```

**Fix:** Don't connect unrelated things

**❌ No Fragmentation:**

```
Long paragraph messages
```

**Fix:** 3-7 words per message, always

---

## REMEMBER

**The dataset teaches you:**

- What authentic texting looks like
- How to build and deliver a romantic moment
- What reactions make people smile

**Your job:**

- Think about the user's theme
- Create something that naturally fits
- Fragment into short messages (3-7 words)
- Keep it simple and smooth

**If you're copy-pasting a dataset pattern → STOP. Think deeper.**

**Ask: "What would be naturally smooth for this theme?"**

Then create that, using short fragmented messages.

---

## FINAL CHECK

Before submitting:

- ☐ All messages 3-7 words?
- ☐ Theme connects naturally to romantic moment?
- ☐ Each message flows logically?
- ☐ Avoided forcing dataset patterns?
- ☐ Reactions adorable (not annoyed)?
- ☐ 1-2 typos added naturally?
- ☐ 10-16 messages total?

**Principles over patterns. Short messages. Natural flow. Think creatively.**
