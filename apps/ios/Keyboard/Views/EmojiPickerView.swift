//
//  EmojiPickerView.swift
//  Keyboard
//
//  Created by Benno on 06.12.25.
//

import KeyboardKit
import SwiftUI

struct EmojiPickerView: View {
    let controller: KeyboardInputViewController

    @State private var selectedCategory: EmojiCategory = .smileys
    @State private var programmaticScrollTarget: EmojiCategory?

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 8
    )
    private let emojiSize: CGFloat = 40

    var body: some View {
        VStack(spacing: 0) {
            emojiScrollView
                .frame(height: 180)
            categoryTabBar
        }
    }

    // MARK: - UI

    private var emojiScrollView: some View {
        GeometryReader { geometry in
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top, spacing: 0) {
                        ForEach(EmojiCategory.allCases) { category in
                            categoryColumn(
                                category,
                                containerHeight: geometry.size.height
                            )
                            .frame(width: geometry.size.width)
                            .id(category.id)
                            .background(
                                GeometryReader { itemGeometry in
                                    Color.clear.preference(
                                        key: CategoryVisibilityPreferenceKey
                                            .self,
                                        value: CategoryVisibility(
                                            category: category,
                                            frame: itemGeometry.frame(
                                                in: .named("scrollView")
                                            ),
                                            containerWidth: geometry.size.width
                                        )
                                    )
                                }
                            )
                        }
                    }
                }
                .coordinateSpace(name: "scrollView")
                .onPreferenceChange(CategoryVisibilityPreferenceKey.self) {
                    visibility in
                    updateSelectedCategoryFromScroll(visibility)
                }
                .onChange(of: programmaticScrollTarget) { _, newValue in
                    if let target = newValue {
                        withAnimation(.easeOut(duration: 0.3)) {
                            scrollProxy.scrollTo(target.id, anchor: .leading)
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            programmaticScrollTarget = nil
                        }
                    }
                }
            }
        }
    }

    private func categoryColumn(
        _ category: EmojiCategory,
        containerHeight: CGFloat
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(category.rawValue.uppercased())
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)
                .padding(.top, 12)

            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(Array(category.emojis.enumerated()), id: \.offset) {
                        _,
                        emoji in
                        emojiButton(emoji)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }

    private func emojiButton(_ emoji: String) -> some View {
        Button {
            insertEmoji(emoji)
        } label: {
            Text(emoji)
                .font(.system(size: 32))
                .frame(width: emojiSize, height: emojiSize)
        }
        .buttonStyle(EmojiButtonStyle())
    }

    private var categoryTabBar: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 0) {
                keyboardSwitchButton

                ForEach(EmojiCategory.allCases) { category in
                    categoryTabButton(category)
                        .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 44)
            .background(Color(UIColor.secondarySystemBackground))
        }
    }

    private var keyboardSwitchButton: some View {
        Button {
            switchToTextKeyboard()
        } label: {
            Image(systemName: "textformat.abc")
                .font(.system(size: 20))
                .foregroundColor(.primary)
                .frame(width: 44, height: 44)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func categoryTabButton(_ category: EmojiCategory) -> some View {
        Button {
            selectCategory(category)
        } label: {
            VStack(spacing: 2) {
                Image(systemName: category.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(
                        selectedCategory == category ? .blue : .secondary
                    )

                if selectedCategory == category {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 24, height: 2)
                        .transition(.opacity)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: 24, height: 2)
                }
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Actions

    private func insertEmoji(_ emoji: String) {
        controller.insertText(emoji)
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func switchToTextKeyboard() {
        // TODO: Navigate back to text keyboard
    }

    private func selectCategory(_ category: EmojiCategory) {
        guard selectedCategory != category else { return }

        selectedCategory = category
        programmaticScrollTarget = category

        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }

    private func updateSelectedCategoryFromScroll(
        _ visibility: CategoryVisibility?
    ) {
        guard programmaticScrollTarget == nil, let visibility = visibility
        else { return }

        let center = visibility.containerWidth / 2
        let categoryCenter =
            visibility.frame.minX + (visibility.frame.width / 2)
        let distanceFromCenter = abs(categoryCenter - center)

        if distanceFromCenter < visibility.containerWidth / 3
            && visibility.category != selectedCategory
        {
            selectedCategory = visibility.category
        }
    }
}

private struct CategoryVisibility: Equatable {
    let category: EmojiCategory
    let frame: CGRect
    let containerWidth: CGFloat
}

private struct CategoryVisibilityPreferenceKey: PreferenceKey {
    static var defaultValue: CategoryVisibility?

    static func reduce(
        value: inout CategoryVisibility?,
        nextValue: () -> CategoryVisibility?
    ) {
        if let next = nextValue() {
            value = next
        }
    }
}

private struct EmojiButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        configuration.isPressed
                            ? Color.secondary.opacity(0.2) : Color.clear
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(
                .spring(response: 0.2, dampingFraction: 0.6),
                value: configuration.isPressed
            )
    }
}
