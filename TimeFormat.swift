// File: Utilities/TimeFormat.swift
import Foundation

// MARK: - TimeFormat
enum TimeFormat {
    /// Formats a total second count as "M:SS"
    /// e.g., 90 → "1:30", 5 → "0:05"
    static func format(seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
