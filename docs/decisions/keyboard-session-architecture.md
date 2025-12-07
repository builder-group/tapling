# KeyboardSession Architecture

## Decision

Use a session-based `KeyboardSession` model to track keystrokes from the keyboard extension, instead of directly mutating the `Player` model or using a `KeyboardGameState` singleton.

## Rationale

### Session-Based Tracking Aligns with Game Mechanics

Several jobs require session-aware logic:

- **Chatter job**: First 15 keystrokes per session earn 2x keycaps
- **Writer job**: Builds combo multiplier over 80 keystrokes per session
- **Future jobs**: May require session-based patterns (rapid-fire, time-based bonuses)

A session model naturally captures these patterns with `startDate`, `endDate`, and `keystrokeCount`.

### Privacy-Friendly Data Storage

`KeyboardSession` stores only aggregated counts, never the actual text typed:

```swift
var keystrokeCount: Int
// Future: Can add combo counts (bracketComboCount, symbolComboCount) when needed
```

This protects user privacy. For MVP, we only track `keystrokeCount`. Future jobs (Coder, Gamer) can add combo pattern counts when implemented.

### Separation of Concerns

**Keyboard Extension (lean):**
- Tracks keystrokes in-memory during session
- Writes session data to SwiftData on keyboard close
- No game logic, no keycap calculation

**Main App (game logic):**
- Reads sessions from SwiftData
- Applies job bonuses and multipliers
- Calculates keycaps earned
- Aggregates to `Player` totals

This keeps the keyboard extension lightweight and maintainable.

### Supports Future Combo Tracking

The session model can easily extend to track combo patterns without storing text:

```swift
var bracketComboCount: Int    // () [] {} patterns
var symbolComboCount: Int      // Coding symbols
var rapidFireComboCount: Int   // Rapid typing patterns
```

Main app processes these counts to calculate job-specific bonuses.

### Batch Processing and Cleanup

Sessions enable efficient batch operations:

- Process multiple sessions at once when app launches
- Clean up old sessions (>1 day) to prevent unbounded growth
- Recalculate keycaps if job mechanics change

Direct `Player` mutation would require tracking every keystroke individually, making cleanup and recalculation difficult.

### Decouples Keyboard from Main App Models

The keyboard extension doesn't need access to the main app's `Player` model, which contains:
- `currentKeycaps`, `totalKeycapsEarned`
- `totalKeystrokes`
- `firstActiveDate`, `lastActiveDate`
- Future: collectibles, achievements, etc.

Keeping `KeyboardSession` in the keyboard's data container (`KeyboardDataContainer`) maintains clear boundaries. The main app reads sessions and updates `Player` as needed.

## Alternatives Considered

### Direct Player Mutation

**Approach:** Keyboard extension directly increments `Player.totalKeystrokes` and `Player.currentKeycaps` on each keystroke.

**Rejected because:**
- Keyboard needs access to main app's `Player` model (tight coupling)
- No session awareness (can't support Chatter/Writer job mechanics)
- Harder to debug (no session history)
- Can't recalculate keycaps if job mechanics change
- Privacy concern if storing individual keystroke records

### KeyboardGameState Singleton

**Approach:** Create a `KeyboardGameState` singleton model in the keyboard's data container that mirrors `Player` fields.

**Rejected because:**
- Duplicates `Player` state (two sources of truth)
- Requires complex sync logic between `KeyboardGameState` and `Player`
- Still doesn't support session-based mechanics
- More complex than needed for the use case

### Individual Keystroke Records

**Approach:** Store each keystroke as a separate record with timestamp.

**Rejected because:**
- Privacy concern (stores every keystroke individually)
- Unbounded data growth (millions of records)
- Performance overhead (queries, storage)
- Overkill for current game mechanics

## Trade-offs

### Additional Processing Step

Main app must process sessions to calculate keycaps and update `Player`. This adds a processing step but enables:
- Flexible job mechanics
- Batch operations
- Easy recalculation if needed

### Session Cleanup Required

Sessions accumulate over time. Main app should clean up old sessions (>1 day) to prevent unbounded growth. This is a small maintenance task but necessary for long-term operation.

### Full Access Required

Sessions require Full Access to write from the keyboard extension. This is a user permission requirement, but necessary for any data persistence from keyboard extensions.

## Implementation

- **Model:** `KeyboardSession` in `KeyboardDataContainer` schema
- **Tracker:** `KeyboardSessionTracker` manages in-memory session state
- **Lifecycle:** Session starts on `viewWillAppear`, saves on `viewWillDisappear`
- **Processing:** Main app processes sessions on startup (future: calculate keycaps, update Player)

---

See: [Keyboard Extension Permissions](../research/keyboard-permissions.md)

