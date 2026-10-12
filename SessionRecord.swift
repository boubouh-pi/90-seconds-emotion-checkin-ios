// File: Models/SessionRecord.swift
import Foundation

// MARK: - SessionRecord
struct SessionRecord: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var emotionKey: String
    var microWin: String?

    var emotionTitle: String {
        Emotion.find(id: emotionKey)?.title ?? emotionKey.capitalized
    }
}
