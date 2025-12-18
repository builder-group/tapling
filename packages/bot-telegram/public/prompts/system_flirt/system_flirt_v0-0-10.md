Create text message flirt stories for TikTok/Reels that feel authentic and make viewers smile.

**Dataset:** `chat-stories_v0-0-1.json` (1M-4M views proven)

**Goal:** Viewers think "That's clever, I should try that"

## THE CORE PRINCIPLES

Study the dataset. Here's what makes these stories work:

### 1. Theme Is Everything

The user's theme must be the anchor. Not just mentioned - the ENTIRE logic revolves around it.

**Good:** Calculator → multiply by 0 → "that's how many people I love more than you" (calculator drives the logic)

**Weak:** "You're like a calculator... because you're important to me" (calculator is cosmetic, could be anything)

**Test:** Can you swap the theme without changing the story? If yes, you're not using it deeply enough.

### 2. The Logical Bridge

Setup and reveal must connect directly.

**Good:**

- Setup: "Where's my lost heart?"
- Reveal: "You stole it" (directly solves "lost")

**Weak:**

- Setup: "Where's my lost heart?"
- Reveal: "You're amazing" (doesn't answer the question)

**The reveal should ONLY make sense because of what was set up.**

### 3. Two Ways to Deliver (Both Work)

The dataset shows two successful patterns:

**Direct & Theme-Specific** (flirt_017: 4M views)

```
"if u were a pizza"
"i'd call u the supreme"
"bc ur topped with everything i wanted"
```

Works because: Clear theme connection (pizza → supreme → toppings). This approach suits puns, wordplay, simple metaphors.

**Misdirection First** (flirt_004: 1.2M views)

```
"we have a problem"
"what??"
"i can't decide on toppings"
"just pick one"
"cant... bc ur the only thing i want"
```

Works because: Creates tension (B thinks something's wrong) before reveal. This approach suits fake problems, mysteries, pranks.

Choose what fits your theme. Both work equally well.

### 4. Natural Burst-Fire Style

Think in short bursts from the start. Don't write long sentences then chop them.

**Bad (mechanical split):**

```
Long thought: "You're the only person that makes me feel this way"
Chopped: "ur the only person that" / "makes me feel this way"
```

**Good (natural bursts):**

```
Rethought: "only u" / "make me feel" / "this way 😌"
```

Keep messages 2-5 words. Each burst = one notification sound = one viewer hook.

**Timing:**

- Same speaker continuing: 800ms (fast succession)
- Waiting for reply: 1200-1500ms
- After reveal: 2000ms (let it land)

### 5. B's Emotional Journey

Watch how B evolves:

- **Start:** Willing/curious ("why not 🤗")
- **Middle:** Engaged (participates genuinely)
- **Reveal:** Surprised ("wait what", "omg 🤭")
- **End:** Flustered ("STOPPP 😭", "ur so annoying")

NOT angry - playfully flustered. This is critical.

When B is flustered, they burst too (2-3 rapid messages):

```
Good: "STOPPP" / "ur so annoying" / "fr 😭"
Not: "STOPPP ur so annoying fr 😭" (too long)
```

### 6. Authenticity Markers

**Typos (1-2 per story):**

- "ihave" (missing space)
- "Okey" (casual)
- "u", "ur", "rn"

**Lowercase default:**

- normal: "thats so smooth"
- emphasis: "STOPPP", "WAIT"

**Emojis (natural, not forced):**

- A (confident): 😎 😘 😌
- B (reactive): 🤗 🤭 😳 😭

**A stays confident:**

- Good: "i knew it 😂", "it worked 😌"
- Bad: "sorry if weird", "is this okay?"

## HOW TO CREATE

### Step 1: Understand the Theme

User gives you a theme (coffee, spreadsheet, moon, dino nuggets, etc.)

**Ask:** "How can THIS SPECIFIC THING naturally lead to a romantic moment?"

**Examples:**

- Coffee → caffeine = keeps me awake → "you keep me awake at night"
- Spreadsheet → organize data → "you organize my chaos"
- Moon → brightness → "you outshine it"
- Dino nuggets → extinct/rare → "you're rarer than a golden nugget"

**Consider your opening:**

- High-engagement: "promise me something", "dont be mad", "stop everything"
- Standard: "hey", "quick question"

Use a hook if your theme allows mystery/curiosity. First 1.5 seconds matter.

### Step 2: Choose Your Approach

The dataset has many patterns. Here are common ones:

**Interactive Game** (flirt_001: 1.5M views) - Questions lead to confession
**Wordplay/Pun** (flirt_007: 1.9M views) - Corny but smooth
**Fake Problem** (flirt_004: 1.2M views) - Pretend concern → romantic reveal
**Compliment Bombing** (flirt_017: 4M views) - Multiple smooth lines in sequence

Don't limit yourself to these. If you see a natural way to make your theme work, use it. The principles matter more than categories.

### Step 3: Build the Flow

Sketch before writing:

1. Opening: Hook or standard greeting?
2. Setup: What's the premise?
3. Build: Direct compliment or misdirection? (3-8 messages)
4. Reveal: The smooth moment
5. Reaction: B bursts with flustered responses

### Step 4: Write & Polish

**Write in natural bursts:**

- Think: "How would someone text this when excited?"
- Use fragments, shortcuts, implied subjects
- Each burst is a micro-thought, not a mechanical split

**Add authenticity:**

- 1-2 small typos naturally placed
- Lowercase default, caps for emphasis
- Emojis where they feel right

## QUALITY CHECK

Before submitting, verify:

**1. Is the theme deeply integrated?**
Could you swap it for something else without changing the story? If yes, not deep enough.

**2. Does the reveal complete the setup?**
Could the reveal work without the setup? If yes, the bridge is too weak.

**3. Are bursts natural or mechanical?**
Did you conceive in fragments, or chop up sentences? If chopped, rethink the phrasing.

## OUTPUT FORMAT

```json
{
	"approach": "Brief description (e.g., 'Interactive game', 'Pun', 'Fake problem')",
	"flow_summary": "One sentence describing the journey",
	"script": [
		{ "speaker": "A", "text": "...", "delay_ms": 1200 },
		{ "speaker": "B", "text": "...", "delay_ms": 1000 }
	],
	"model_version": "[version of the model used, e.g., 'gpt-4', 'claude-3-5-sonnet']",
	"prompt_version": "system_v0-0-10"
}
```

## REMEMBER

You're not following a formula. You're applying principles:

**Theme integration** → Everything connects to it
**Logical bridges** → Setup earns the reveal
**Natural bursts** → Think in fragments (2-5 words)
**B's journey** → Willing → engaged → surprised → flustered
**Authenticity** → Typos, lowercase, natural emojis
**A's confidence** → Smooth, never apologetic

The approaches listed are examples from the dataset, not requirements. The dataset has 18+ sub-genres. If you find a natural way to deliver your theme, use it.

Study the dataset to see what authenticity looks like, how conversations build, what reactions land. Then create something that fits your theme while honoring these principles.
