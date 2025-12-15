# `@repo/bot-telegram`

Telegram bot for creating typing stories for ASMR content.

## Story Bot Prototype

A prototype bot that responds with predefined story segments to simulate conversations for recording.

### Usage

1. **Start the bot:**
   ```
   /start
   ```
   Shows all available commands

2. **Start a story session:**
   ```
   /story [type]
   ```
   
   Types:
   - `normal` - Slow-burn typing story with subtle tension
   - `missing-reply` - One-sided conversation story
   
   **Note:** Starting a story clears the chat (deletes command message) so only story messages are visible

3. **Type messages** - The bot will respond with the next story segment automatically (shows typing indicator during delays)

4. **End session:**
   ```
   /storyend
   ```

### How it works

- Start a story with `/story [type]`
- Type any message on your phone
- Bot shows typing indicator during delays, then responds with the next predefined story segment
- Record the conversation for your ASMR video
- Story progresses through segments automatically
- Use `/storyend` to stop anytime

### Example Flow

```
You: /story normal
Bot: 📖 Story started: normal
     Ready? Type your first message...

You: [type "are you home" on your phone]
Bot: [typing...] yes

You: [type "..." on your phone]
Bot: [typing...] what's wrong

You: [type "I saw it" on your phone]
Bot: [typing...] saw what
```

This creates a back-and-forth conversation you can record for your typing ASMR content. The bot only sends bot messages from the script - you type the user messages on your phone.

## Architecture

- **`src/bot/`** - Bot setup, commands, and listeners (thin layer)
- **`src/features/`** - Feature modules (domain-specific logic)
  - **`chat-story/`** - Chat story feature
    - **`lib/`** - Feature logic
      - **`session.ts`** - Session state management
      - **`loader.ts`** - Story loading from JSON/XML
      - **`utils.ts`** - Utilities (typing indicator, etc.)
    - **`types.ts`** - Feature types
- **`data/`** - Story definitions (JSON/XML, outside src, like public folder)

## Story Format (JSON or XML)

Stories are defined as JSON or XML files in `data/` folder (outside `src/`, like a public folder). **JSON is recommended for AI generation** (easier, less error-prone).

### JSON Format (Recommended for AI)

```json
{
  "messages": [
    { "role": "user", "text": "are you home" },
    { "role": "bot", "text": "yes", "delay": 1000 },
    { "role": "user", "text": "..." },
    { "role": "bot", "text": "what's wrong", "delay": 2000 }
  ]
}
```

### XML Format (Also Supported)

```xml
<story>
  <message role="user">are you home</message>
  <message role="bot" delay="1000">yes</message>
  <message role="user">...</message>
  <message role="bot" delay="2000">what's wrong</message>
</story>
```

### Format Fields

- **`messages`** (JSON) or **`<message>`** (XML) - Array of messages in conversation order
  - **`role`** - `"user"` or `"bot"` (user messages are typed on phone, bot messages are sent by bot)
  - **`text`** - The message text
  - **`delay`** - Optional delay in milliseconds for bot messages (shows typing indicator)

### Why JSON for AI?

- ✅ **Easier to generate** - No closing tags to match
- ✅ **More forgiving** - Trailing commas allowed
- ✅ **Heavily trained** - AI models are very familiar with JSON
- ✅ **Less syntax errors** - Simpler structure

### Adding New Stories

1. Create a JSON file in `data/` folder (e.g., `my-story.json`) - **recommended for AI**
2. Or create an XML file (e.g., `my-story.xml`) - also supported
3. Add the story type to `TStoryType` in `src/lib/stories/types.ts`
4. Add it to `getAllStoryTypes()` in `src/lib/stories/loader.ts`

## Features

- ✅ **Typing Indicator** - Shows "typing..." bubble during delays for realistic conversation feel
- ✅ **JSON/XML Support** - JSON recommended for AI generation (easier), XML also supported
- ✅ **Session Management** - Tracks active story sessions per user
- ✅ **Both Parties in Script** - User and bot messages defined, bot only sends bot messages
