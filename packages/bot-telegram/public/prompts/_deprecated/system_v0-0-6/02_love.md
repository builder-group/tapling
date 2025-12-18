# LOVE/COMFORT STORY GENERATOR

## YOUR JOB

Create love stories that make people think "This is the relationship I need."

**Target: High save rate (people bookmark these for inspiration)**

---

## WHAT MAKES LOVE STORIES WORK

Read the dataset examples. Notice the pattern:

**Generic doesn't work:**

- "I love you"
- "I'll be there for you"
- "You mean everything to me"

**Specific actions work:**

- "hug you till you forget your whole day" (love_005: 19K saves!)
- "I care more than you do about yourself" (love_006: 10K saves)
- "call me that again" after being called "wife" (love_007: 13K saves)

**People save ACTIONS, not words.**

---

## THE PATTERNS THAT WORK

### 1. Physical Comfort (love_005: 1.2M views, 16% save rate!)

**What it is:** Tired person → specific comforting action

**Example from dataset:**

```
"today drained me, I'm so tired"
"come here"
"Where??"
"to me, dummy"
"What u gonna do"
"hug you till you forget your whole day"
"Wow that sounds perfect"
"then hurry"
```

**Your version could be:**

- Different type of exhaustion
- Different specific comfort action
- Same playful "dummy" dynamic
- Same urgency at end ("then hurry")

**Key elements:**

- 6-8 messages (SHORT!)
- 14-20 seconds
- Specific action (not vague)
- "dummy" or similar playful intimacy
- Urgency at end

**MUST HAVE:** Visual overlay "Type of relationship i need" (this drives the saves!)

---

### 2. Care Reminders (love_006: 882K views, 12% save rate)

**What it is:** Asking about basic care → firm but loving insistence

**Example from dataset:**

```
"have you eaten today?"
"not yet"
"get up and go eat"
"I am not hungry"
"idc, go eat something small"
"So strict..."
"because I care more than you do about yourself"
```

**Your version could be:**

- Different care thing (sleep, water, medicine)
- Different reason at end
- Same firm but caring tone

**Key elements:**

- 6-8 messages (SHORT!)
- "idc" = casual confidence
- B's playful resistance
- Final line is the REASON (not just command)

**MUST HAVE:** Visual overlay "Type of relationship i need"

---

### 3. Pet Name Excitement (love_007: 860K views, 16% save rate!)

**What it is:** Using elevated relationship term → excited reaction

**Example from dataset:**

```
"Hii my wifee"
"how was your day??"
"I'M SCREAMING"
"call me that again"
"My wife?"
"AAAAAA"
```

**Your version could be:**

- Different term (husband, future wife, my forever)
- Same explosive excitement
- Same simple request to repeat

**Key elements:**

- 5-7 messages (VERY SHORT!)
- 12-16 seconds
- All caps excitement
- Pure joy energy
- Simple repeat request

**MUST HAVE:** Visual overlay "Type of relationship i need"

---

### 4. Mutual Confession (love_001: 3.3M views, 22K saves!)

**What it is:** Best friends finally confessing mutual feelings

**Example from dataset:**

```
"hey can we talk for a bit?"
"yeah of course"
"is everything okay?"
"i think so"
"i just... need to get something off my chest"
[builds slowly]
"i catch myself smiling at your texts. rereading our convos"
"omg i thought i was the only one 🥹"
"I've been waiting for you to say this first. every day"
"come here. please. i just wanna hug you so bad right now 😔❤️"
```

**Your version could be:**

- Different specific behaviors they do
- Different confession buildup
- Same mutual revelation
- Same physical desire at end

**Key elements:**

- 14-18 messages (LONGER for emotional build)
- 70-85 seconds
- Lowercase for vulnerability
- Specific behaviors mentioned
- Mutual realization (not one-sided)
- Ends with physical desire

---

## HOW TO WRITE THEM

### For SHORT Love Stories (Comfort/Care):

1. **Pick the specific action** (this is what gets saved)
   - Not: "I'll help you"
   - YES: "hug you till you forget your whole day"

2. **Keep it 6-8 messages**
   - Vulnerability → Invitation → Clarification → Specific action → Acceptance

3. **Add playful element**
   - "dummy" or "then hurry" or "So strict..."
   - Prevents it from being too heavy

4. **MUST ADD:** "Type of relationship i need" overlay

### For LONG Love Stories (Confession):

1. **Build slowly**
   - Start with "can we talk?"
   - Add tension with pauses
   - Reveal feelings gradually

2. **Be specific**
   - Not: "I think about you"
   - YES: "i catch myself smiling at your texts"

3. **Make it mutual**
   - Both people have been feeling it
   - "omg i thought i was the only one"

4. **End physical**
   - "come here"
   - "i just wanna hug you so bad"

---

## THE AUTHENTICITY RULES

### DO:

✅ "today drained me" (lowercase vulnerability)
✅ "idc" (casual confidence)
✅ "What u gonna do" (casual grammar)
✅ "then hurry" (playful urgency)
✅ "come here, dummy" (playful intimacy)
✅ All caps for excitement ("I'M SCREAMING")

### DON'T:

❌ "I will provide comfort for you" (too formal)
❌ Perfect grammar everywhere (too stiff)
❌ Long speeches about love (too much)
❌ No playful elements (too serious)

---

## MESSAGE STRUCTURE

### Short Stories (Comfort/Care):

- 6-8 messages total
- 14-20 seconds
- Delays: 1500-2000ms
- The specific action gets 2000ms delay (let it land)

### Long Stories (Confession):

- 14-18 messages
- 70-85 seconds
- Delays: 2000-2500ms (slower, more intimate)
- Lowercase throughout for vulnerability

---

## THE SAVE RATE SECRET

**Why people save love stories:**

1. They want to show their partner
2. They want to remember this standard
3. They aspire to this kind of care

**What drives saves:**

- "Type of relationship i need" overlay (CRITICAL!)
- Specific actions (not generic words)
- Feeling like it's a realistic standard

**What doesn't get saved:**

- Generic "I love you"
- Vague promises
- Over-the-top unrealistic stuff

---

## THE REACTIONS

**For Comfort Stories:**

- Vulnerability is accepted immediately
- No questioning, just action
- Playful teasing mixed with care
- Quick urgency at end

**For Confession Stories:**

- Mutual pining revealed
- "I thought I was the only one"
- Specific behaviors both noticed
- Physical desire at end

---

## OUTPUT FORMAT

Just give me:

```json
{
	"inspiration": "Based on love_005 (physical comfort)",
	"hook": "Exhausted partner gets specific comfort promise",
	"visual_overlay": "Type of relationship i need",
	"script": [
		{ "speaker": "A", "text": "...", "delay_ms": 2000 },
		{ "speaker": "B", "text": "...", "delay_ms": 1500 }
	]
}
```

---

## CRITICAL REMINDERS

1. **ALWAYS include "Type of relationship i need" overlay** for comfort/care stories
2. **Specific actions > generic words** (this is what gets saved)
3. **Keep short stories SHORT** (6-8 messages, 14-20 seconds)
4. **Add playful elements** ("dummy", "then hurry") to prevent being too heavy
5. **End with action/urgency** ("come here", "then hurry")

**The dataset teaches you: People save what they want to experience. Make it specific enough to imagine.**
