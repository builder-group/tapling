//
//  EmojiPickerView.swift
//  Keyboard
//
//  Created by Benno on 06.12.25.
//

import KeyboardKit
import MCEmojiPicker
import SwiftUI

struct EmojiPickerView: View {
    let controller: KeyboardInputViewController

    @State private var selectedEmoji: String = ""

    var body: some View {
        MCEmojiPickerEmbeddedView(
            controller: controller,
            selectedEmoji: $selectedEmoji
        )
        .frame(height: 220)
    }
}

private struct MCEmojiPickerEmbeddedView: UIViewControllerRepresentable {
    let controller: KeyboardInputViewController
    @Binding var selectedEmoji: String

    func makeUIViewController(context: Context)
        -> MCEmojiPickerEmbeddedViewController
    {
        let viewController = MCEmojiPickerEmbeddedViewController()
        viewController.keyboardController = controller
        viewController.onEmojiSelected = { emoji in
            selectedEmoji = emoji
        }
        return viewController
    }

    func updateUIViewController(
        _ uiViewController: MCEmojiPickerEmbeddedViewController,
        context: Context
    ) {}
}

private class MCEmojiPickerEmbeddedViewController: UIViewController {
    var keyboardController: KeyboardInputViewController?
    var onEmojiSelected: ((String) -> Void)?
    private var emojiPickerViewController: MCEmojiPickerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let emojiPicker = MCEmojiPickerViewController()
        emojiPicker.delegate = self
        emojiPicker.isDismissAfterChoosing = false
        emojiPicker.feedBackGeneratorStyle = .light
        emojiPicker.selectedEmojiCategoryTintColor = .systemBlue

        // Embed the emoji picker as a child view controller
        addChild(emojiPicker)
        view.addSubview(emojiPicker.view)
        emojiPicker.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiPicker.view.topAnchor.constraint(equalTo: view.topAnchor),
            emojiPicker.view.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            emojiPicker.view.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            emojiPicker.view.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
        ])
        emojiPicker.didMove(toParent: self)

        emojiPickerViewController = emojiPicker
    }
}

extension MCEmojiPickerEmbeddedViewController: MCEmojiPickerDelegate {
    func didGetEmoji(emoji: String) {
        keyboardController?.insertText(emoji)
        onEmojiSelected?(emoji)

        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}
