// File: ViewModels/SessionViewModel.swift
import SwiftUI
import Combine

// MARK: - SessionViewModel
final class SessionViewModel: ObservableObject {
    // MARK: Constants
    static let totalSeconds = 90

    // Phase boundaries (seconds elapsed)
    static let phaseAEnd = 20
    static let phaseBEnd = 65

    // MARK: Published
    @Published var remainingSeconds: Int = totalSeconds
    @Published var isRunning: Bool = false
    @Published var isFinished: Bool = false

    var phase: SessionPhase {
        let elapsed = Self.totalSeconds - remainingSeconds
        if elapsed < Self.phaseAEnd { return .labelGround }
        if elapsed < Self.phaseBEnd { return .breathe }
        return .reframe
    }

    var progress: Double {
        1.0 - Double(remainingSeconds) / Double(Self.totalSeconds)
    }

    // Breathing ring animation — cycles on an 8-second period during phase B
    var breatheScale: CGFloat {
        guard phase == .breathe else { return 1.0 }
        let elapsed = Double(Self.totalSeconds - remainingSeconds - Self.phaseAEnd)
        let period: Double = 8.0
        let angle = (elapsed.truncatingRemainder(dividingBy: period)) / period * 2 * Double.pi
        return CGFloat(1.0 + 0.35 * sin(angle))
    }

    private var timer: AnyCancellable?

    // MARK: - Control
    func start() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    func stop() {
        isRunning = false
        timer?.cancel()
        timer = nil
    }

    func reset() {
        stop()
        remainingSeconds = Self.totalSeconds
        isFinished = false
    }

    // MARK: - Prompt
    func currentPrompt(for emotion: Emotion) -> String {
        emotion.phaseTexts[phase] ?? ""
    }

    func breatheInstruction(for emotion: Emotion) -> String {
        emotion.breatheInstruction
    }

    // MARK: - Private
    private func tick() {
        guard remainingSeconds > 0 else {
            stop()
            isFinished = true
            return
        }
        remainingSeconds -= 1
    }
}
