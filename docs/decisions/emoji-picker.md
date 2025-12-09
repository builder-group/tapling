# Emoji Picker Implementation

## Decision

Use MCEmojiPicker library as a temporary solution. Disabled by default until a custom implementation is built.

## Rationale

### Current State

MCEmojiPicker provides a working emoji picker implementation, but it's designed for popover presentation, not embedded keyboard views. When embedded in the keyboard extension, it lacks key features and doesn't match the native iOS emoji keyboard experience. However, it's the best free prebuilt solution available.

### Future Requirements

A custom emoji picker should include:

- Horizontal scrolling between categories (like native iOS)
- Transparent/adaptive background (matches keyboard appearance)
- Back button to return to text keyboard
- Delete button (like native emoji keyboard)
- Native iOS emoji picker feel and behavior

## Trade-offs

### Temporary Solution

MCEmojiPicker serves as a barebones working implementation, allowing development to continue while a proper solution is designed. The feature is disabled by default in settings to avoid a subpar user experience.

### Popover Design Mismatch

The library is designed for popover presentation, not embedded keyboard views. This creates a fundamental mismatch with keyboard extension requirements, requiring workarounds to embed it directly.

### KeyboardKit Pro Alternative

[KeyboardKit Pro](https://keyboardkit.com/pro) offers a built-in emoji keyboard feature, but requires the Gold tier subscription ($500/month or $5000/year). This is cost-prohibitive for the current project stage.

### Custom Implementation Needed

The library doesn't support horizontal scrolling or provide the native iOS feel. A custom implementation will be required to match user expectations.

## Resources & References

- [MCEmojiPicker GitHub](https://github.com/izyumkin/MCEmojiPicker)
- [MCEmojiPicker Development Article](https://medium.com/better-programming/an-emoji-selection-element-aka-emojipicker-for-ios-like-in-macos-e2fa022b80af)
- [KeyboardKit Pro Pricing](https://keyboardkit.com/pro)
