// File: Models/Emotion.swift
import SwiftUI

// MARK: - Phase Enum
enum SessionPhase: String, CaseIterable {
    case labelGround = "labelGround"
    case breathe     = "breathe"
    case reframe     = "reframe"
}

// MARK: - Emotion Model
struct Emotion: Identifiable, Hashable {
    let id: String
    let title: String
    let icon: String // SF Symbol name
    let colorPalette: [Color]
    let phaseTexts: [SessionPhase: String]
    let breatheInstruction: String
}

// MARK: - Presets
extension Emotion {
    static let all: [Emotion] = [angry, anxious, overwhelmed, sad]
    
    // MARK: Angry (discharge + longer exhale + boundary reframe)
    static let angry = Emotion(
        id: "angry",
        title: "Angry",
        icon: "flame.fill",
        colorPalette: [
            Color(red: 0.70, green: 0.10, blue: 0.10),
            Color(red: 0.90, green: 0.30, blue: 0.05),
            Color(red: 0.25, green: 0.05, blue: 0.05)
        ],
        phaseTexts: [
            .labelGround:
                "Say it quietly: \"I feel angry.\"\n" +
            "Unclench your jaw. Drop your shoulders.\n" +
            "Exhale like a slow sigh.",
            .breathe:
                "Anger is energy. We’re lowering the heat.\n" +
            "Make the exhale longer than the inhale.",
            .reframe:
                "What boundary was crossed?\n" +
            "Choose one calm next step — even a small one."
        ],
        breatheInstruction: "In… 4 counts.\nOut… 6 counts.\nRepeat."
    )
    
    // MARK: Anxious (safety scan + box breathing + control reframe)
    static let anxious = Emotion(
        id: "anxious",
        title: "Anxious",
        icon: "waveform.path.ecg",
        colorPalette: [
            Color(red: 0.10, green: 0.25, blue: 0.60),
            Color(red: 0.35, green: 0.55, blue: 0.85),
            Color(red: 0.05, green: 0.10, blue: 0.30)
        ],
        phaseTexts: [
            .labelGround:
                "Say it: \"I feel anxious.\"\n" +
            "Look around and name 5 objects you see.\n" +
            "Right now, you are here.",
            .breathe:
                "Box breathing to steady the nervous system.\n" +
            "Let the rhythm be your anchor.",
            .reframe:
                "What is true right now?\n" +
            "What’s one thing you can control in the next 10 minutes?"
        ],
        breatheInstruction: "In… 4.\nHold… 4.\nOut… 4.\nHold… 4."
    )
    
    // MARK: Overwhelmed (reduce load + steady breathing + one tiny step)
    static let overwhelmed = Emotion(
        id: "overwhelmed",
        title: "Overwhelmed",
        icon: "cloud.heavyrain.fill",
        colorPalette: [
            Color(red: 0.20, green: 0.15, blue: 0.40),
            Color(red: 0.50, green: 0.35, blue: 0.75),
            Color(red: 0.08, green: 0.06, blue: 0.18)
        ],
        phaseTexts: [
            .labelGround:
                "Say: \"This is a lot.\" That’s valid.\n" +
            "You don’t need to solve everything.\n" +
            "Pick ONE thing to hold in mind.",
            .breathe:
                "We’re reducing mental load.\n" +
            "Keep the breath simple and steady.",
            .reframe:
                "What is one tiny next step?\n" +
            "Small is still progress."
        ],
        breatheInstruction: "In… 4.\nOut… 4.\nRepeat."
    )
    
    // MARK: Sad (self-compassion + warmth + connection reframe)
    static let sad = Emotion(
        id: "sad",
        title: "Sad",
        icon: "drop.fill",
        colorPalette: [
            Color(red: 0.08, green: 0.25, blue: 0.35),
            Color(red: 0.25, green: 0.50, blue: 0.60),
            Color(red: 0.04, green: 0.10, blue: 0.18)
        ],
        phaseTexts: [
            .labelGround:
                "Say it: \"I feel sad.\"\n" +
            "Place a hand on your chest.\n" +
            "Give yourself permission to feel this.",
            .breathe:
                "Gentle breathing — no pressure.\n" +
            "Let the exhale be soft and slow.",
            .reframe:
                "If a friend felt this, what would you tell them?\n" +
            "Offer yourself the same kindness."
        ],
        breatheInstruction: "In… 4.\nOut… 6.\nRepeat."
    )
    
    static func find(id: String) -> Emotion? {
        all.first { $0.id == id }
    }
}
