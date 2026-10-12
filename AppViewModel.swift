// File: ViewModels/AppViewModel.swift
import SwiftUI
import Combine

// MARK: - App State
enum AppScreen {
    case welcome
    case emotionPicker
    case session
    case completion
    case history
    case help
    case settings
}

// MARK: - AppViewModel
final class AppViewModel: ObservableObject {
    @Published var screen: AppScreen = .welcome
    @Published var selectedEmotion: Emotion? = nil
    @Published var records: [SessionRecord] = []
    @Published var currentRecord: SessionRecord? = nil

    init() {
        loadHistory()
    }

    // MARK: - Navigation
    func startSession(emotion: Emotion) {
        selectedEmotion = emotion
        currentRecord = SessionRecord(date: Date(), emotionKey: emotion.id, microWin: nil)
        screen = .session
    }

    func completeSession(microWin: String?) {
        guard var record = currentRecord else { return }
        let trimmed = microWin?.trimmingCharacters(in: .whitespacesAndNewlines)
        record.microWin = trimmed?.isEmpty == false ? trimmed : nil
        StorageService.saveRecord(record)
        loadHistory()
        Haptics.success()
        screen = .completion
    }

    func resetSession() {
        selectedEmotion = nil
        currentRecord = nil
        screen = .welcome
    }

    // MARK: - History
    func loadHistory() {
        records = Array(StorageService.loadRecords().prefix(10))
    }

    func clearHistory() {
        StorageService.clearAll()
        records = []
    }
}
