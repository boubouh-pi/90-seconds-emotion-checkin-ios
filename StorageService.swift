// File: Services/StorageService.swift
import Foundation

// MARK: - StorageService
final class StorageService {
    private static let key = "session_records_v1"

    // MARK: Load
    static func loadRecords() -> [SessionRecord] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
        return (try? JSONDecoder().decode([SessionRecord].self, from: data)) ?? []
    }

    // MARK: Save
    static func saveRecord(_ record: SessionRecord) {
        var records = loadRecords()
        records.insert(record, at: 0) // newest first
        if records.count > 50 { records = Array(records.prefix(50)) }
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    // MARK: Clear
    static func clearAll() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
