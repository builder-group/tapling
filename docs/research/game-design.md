# Tapling - Game Design Document

## Core Concept

Tapling is an iOS keyboard companion that rewards typing. Your Tapling sits on your keyboard and taps along as you type anywhere. Earn keycaps to unlock cosmetics and upgrade jobs.

## Core Loop

```
Type anywhere → Tapling taps → Earn keycaps → Buy chests/upgrades → Customize + Progress → Repeat
```

## Currency: Keycaps

- **1 keycap = 1 keystroke** (ALL keys count: letters, shift, delete, everything)
- Accumulates passively while typing anywhere
- Used for chests and job upgrades

**Why all keys count:** Typing includes corrections, modifiers, and navigation. Tapling celebrates ALL keyboard interactions.

**Average Daily Earnings:**

- Light: 2,000-5,000 keycaps/day
- Average: 5,000-15,000 keycaps/day
- Heavy: 15,000-40,000 keycaps/day
- Power: 40,000-100,000+ keycaps/day

## Jobs System

### Philosophy

All jobs earn equal keycaps over time (100 keycaps per 100 keystrokes average) but optimize for different typing patterns.

### Launch Jobs (All Free)

**Bongo Player** 🥁 - Default

- Balanced 1.0 keycap per keystroke
- No special mechanics
- _"Steady and reliable. Perfect for any typing!"_

**Chatter** 💬

- Optimized for: Messaging apps, social media, short bursts
- Front-loaded rewards: first 15 keystrokes per session earn 2x
- Reduced earnings after initial burst
- _"Quick bursts shine. Perfect for messages and Discord!"_

**Writer** ✍️

- Optimized for: Notes, emails, long-form content
- Builds combo multiplier: 0.8x → 1.2x over 80 keystrokes
- Rewards continuous sessions
- _"Builds momentum. Ideal for long writing!"_

### Future Jobs

**Coder** 💻 - Bonuses for brackets/symbols, coding patterns  
**Gamer** 🎮 - Rewards rapid-fire typing patterns  
**Student** 📚 - Time-based bonuses during study hours

### Job Upgrades (5 Levels Each)

**Costs:** 10k → 50k → 200k → 750k → 2.5M keycaps  
**Bonuses:** +10% → +25% → +50% → +85% → +130%

**Career Names Per Job:**

- **Bongo:** Rhythm Learner → Beat Maker → Groove Master → Rhythm Virtuoso → Percussion Legend
- **Chatter:** Lurker → Active Member → Community Regular → Server Moderator → Discord Legend
- **Writer:** Aspiring Writer → Freelance Writer → Published Author → Bestselling Author → Literary Master
- **Coder:** Junior Developer → Mid-Level Developer → Senior Developer → Tech Lead → Principal Engineer
- **Gamer:** Casual Gamer → Competitive Player → Pro Gamer → Esports Champion → Gaming Legend
- **Student:** Freshman → Sophomore → Junior → Senior → Valedictorian

**Upgrade Timeline:**

- Level 1: 1-2 days (10k)
- Level 2: 3-7 days (50k)
- Level 3: 2-3 weeks (200k)
- Level 4: Monthly goal (750k)
- Level 5: Long-term, 6+ months (2.5M)

### Job Switching

Daily limit - pick once per day at midnight. "Your Tapling focuses on one job per day." Encourages commitment and reduces decision fatigue.

## Cosmetics System

### Design Principle

**Cosmetics = pure visual customization. Zero gameplay impact.** Players customize to express personality, not optimize earnings.

### Categories

- **Fur** (2 at launch): Base colors, patterns, textures
- **Hat** (7 at launch): Accessories worn on head
- **Face** (7 at launch): Eyes, expressions, glasses, etc.

**Total: 16 items at launch**

### Starting Items

New players get 1 random item from each category (fur, hat, face). Ensures unique Taplings from start and teaches customization.

### Rarity System

| Rarity    | Drop Rate | Sell Value |
| --------- | --------- | ---------- |
| Common    | 60%       | 2,000      |
| Rare      | 25%       | 5,000      |
| Epic      | 12%       | 15,000     |
| Legendary | 3%        | 50,000     |

### Duplicates

Can receive duplicates. Sell them for keycaps based on rarity. Can't sell your last copy of an item. Creates longer progression and makes completing the collection meaningful.

## Chest System

### Cost: 5,000 Keycaps

Achievable in 1 day for casual users, few hours for active users.

### Opening: "Lucky Upgrade" Mechanic

Interactive chest opening (inspired by Clash Royale):

1. Player buys chest for 5,000 keycaps
2. Chest has 5 tap stages
3. Each tap has chance to upgrade rarity
4. Visual feedback: chest glows brighter with each upgrade
5. Final tap reveals cosmetic at final rarity

**Example Flow:**

- Tap 1: Common (stays common)
- Tap 2: Common (stays common)
- Tap 3: ✨ Upgrades to Rare!
- Tap 4: Rare (stays rare)
- Tap 5: Rare (no change)
- Result: Receive Rare cosmetic

**Upgrade Chances Per Tap:**

- Common → Rare: 20% chance per tap
- Rare → Epic: 5% chance per tap

Makes opening fun and interactive, not just "click, receive item."

### Cosmetic Rules

- All cosmetics are purely visual
- Mix and match freely across all categories
- No stat bonuses or earning modifiers
- Once unlocked, permanently owned (can't lose items)
- Can sell duplicates, but can't sell your last copy

## Progression Timeline

**Day 1:** Tutorial, receive 3 starter cosmetics, choose job, earn 5k keycaps, open first chest

**Week 1 (0-50k):** First job upgrade, 8-10 chests, collect initial cosmetics, sell duplicates, experiment with jobs

**Month 1 (50k-300k):** Level 2 upgrade, 50+ chests, build collection, experience Epic drops, find preferred job

**Months 2-3 (300k-1M):** Level 3 upgrade, nearly complete common collection, multiple Epics, unlock future jobs

**Months 4-12 (1M+):** Level 4-5 upgrades, complete collection, max out favorite job(s), long-term achievements

## UI/UX Principles

### Minimal Interruption

- Tapling appears on keyboard, doesn't block typing
- Keycaps accumulate passively
- Check app when convenient, not required

### Clear Feedback

- Visual indicator when earning keycaps
- Satisfying tap animation on keyboard
- Clear keycap counter in app
- Celebration animations for milestones

### No Forced Choices

- All cosmetics remain unlocked once obtained
- Can change appearance anytime
- No pressure to play "optimally"
- Job choices affect playstyle, not power

## Onboarding (60 seconds)

1. Show Tapling on keyboard overlay
2. "Hi! I'm your Tapling. Type anything and watch me tap!"
3. User types → earns keycaps
4. "You earned keycaps! Let's open your first chest"
5. Give first chest free, walk through tap-to-upgrade
6. "Customize me! Mix and match your style"
7. Show customization screen
8. "Pick a job that matches your typing style"
9. Brief job descriptions
10. "Now go type! I'll be here earning keycaps"

**Goals:** Under 60 seconds, hands-on, immediate reward, clear value proposition.

## Statistics & Achievements

**Player Stats Displayed:**

- Total keycaps earned all-time
- Total keystrokes typed
- Days active
- Current streak
- Job levels achieved
- Cosmetics collected
- Fun comparisons: "You've typed the equivalent of 3 novels!"

Vanity stats feel good and encourage continued engagement.

## Success Metrics

- Daily active typing sessions
- Job distribution (should be relatively even, ~33% each for launch jobs)
- Cosmetic engagement (chest opening rate)
- Duplicate selling rate
- No single "meta" job emerging (indicates good balance)
- Player customization variety (are people mixing and matching?)
- Average time to each upgrade tier
- Retention: Day 1, Day 7, Day 30
- App Store rating and reviews

## MVP Scope

**Launch:**

- 1 job (Bongo Player)
- 3 cosmetic categories (Fur, Hat, Face)
- 16 total cosmetic items (2 furs, 7 hats, 7 faces)
- 3 starter items given to every player
- 1 chest type (5,000 keycaps)
- Interactive tap-to-upgrade chest opening
- Rarity system (Common/Rare/Epic/Legendary)
- Basic stats tracking
- Onboarding tutorial
- Privacy/permissions screen

**Post-Launch:**

- Additional jobs (Coder, Gamer, Student) - may add unlock cost
- More cosmetic items per category
- Special event cosmetics
- Social features (view friends' Taplings)
- Achievements system
- Leaderboards (most keycaps, fastest typer, etc.)
- Seasonal content

## Key Design Pillars

1. **Companion, Not Game:** Tapling enhances your existing typing, doesn't demand dedicated play time
2. **Expression Over Optimization:** Cosmetics let players express themselves without gameplay pressure
3. **Celebrate All Typing:** Every keystroke counts, typos and all
4. **Long-Term Progression:** Meaningful goals from days to months
5. **Respect Privacy:** Local processing, transparent about permissions
6. **KISS Principle:** Keep systems simple and intuitive
