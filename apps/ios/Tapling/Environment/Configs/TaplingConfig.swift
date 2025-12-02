//
//  TaplingConfig.swift
//  Tapling
//
//  Created by Benno on 02.12.25.
//

import Foundation

struct TaplingConfig {
    static let shared = TaplingConfig()

    /// Base size of the Tapling asset (width and height, since it's square).
    let baseSize: CGFloat = 248
    
    /// Base bottom offset of the body from the bottom of the image (in pixels at base size).
    let baseBodyBottomOffset: CGFloat = 83

    enum Fur: String, CaseIterable {
        case mask = "mask"
        case white = "white"
    }

    enum Hat: String, CaseIterable {
        case banana = "banana"
        case lilDuck = "lil-duck"
        case propellerHat = "propeller-hat"
    }

    enum Face: String, CaseIterable {
        case asia = "asia"
        case cute = "cute"
        case dead = "dead"
        case harryPotter = "harry-potter"
        case pilot = "pilot"
        case pixelCool = "pixel-cool"
    }

    enum Hand: String, CaseIterable {
        case down = "down"
        case up = "up"
    }

    /// Get asset name for fur base layer.
    func furBaseName(fur: Fur) -> String {
        "fur_\(fur.rawValue)_base"
    }

    /// Get asset name for fur left hand layer.
    func furLeftHandName(fur: Fur, hand: Hand) -> String {
        "fur_\(fur.rawValue)_left-\(hand.rawValue)"
    }

    /// Get asset name for fur right hand layer.
    func furRightHandName(fur: Fur, hand: Hand) -> String {
        "fur_\(fur.rawValue)_right-\(hand.rawValue)"
    }

    /// Get asset name for face layer.
    func faceName(face: Face) -> String {
        "face_\(face.rawValue)"
    }

    /// Get asset name for hat layer.
    func hatName(hat: Hat) -> String {
        "hat_\(hat.rawValue)"
    }

    private init() {}
}

/// Tapling character configuration.
struct Tapling {
    let fur: TaplingConfig.Fur
    let hat: TaplingConfig.Hat?
    let face: TaplingConfig.Face
    let leftHand: TaplingConfig.Hand
    let rightHand: TaplingConfig.Hand
}

