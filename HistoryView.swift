// File: Views/HistoryView.swift
import SwiftUI

// MARK: - HistoryView
struct HistoryView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var showClearConfirm = false

    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.12).ignoresSafeArea()

            Group {
                if appVM.records.isEmpty {
                    emptyState
                } else {
                    recordsList
                }
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            if !appVM.records.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
                        Haptics.tap()
                        showClearConfirm = true
                    }
                    .foregroundStyle(.red.opacity(0.75))
                }
            }
        }
        .alert("Clear all history?", isPresented: $showClearConfirm) {
            Button("Clear", role: .destructive) {
                appVM.clearHistory()
            }
            Button("Cancel", role: .cancel) {}
        }
        .onAppear { appVM.loadHistory() }
    }

    // MARK: - Records List
    private var recordsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(appVM.records) { record in
                    recordRow(record)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }

    private func recordRow(_ record: SessionRecord) -> some View {
        let emotion = Emotion.find(id: record.emotionKey)
        return VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                // Emotion icon
                if let e = emotion {
                    Image(systemName: e.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(.white.opacity(0.75))
                        .frame(width: 28)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(emotion?.title ?? record.emotionKey.capitalized)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(.white)
                    Text(dateFormatter.string(from: record.date))
                        .font(.system(size: 12, weight: .light, design: .rounded))
                        .foregroundStyle(.white.opacity(0.40))
                }
                Spacer()
            }

            if let win = record.microWin, !win.isEmpty {
                Text(win)
                    .font(.system(size: 13, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
                    .italic()
                    .lineLimit(2)
            }
        }
        .padding(16)
        .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
        .accessibilityElement(children: .combine)
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 40, weight: .thin))
                .foregroundStyle(.white.opacity(0.25))
            Text("No sessions yet.")
                .font(.system(size: 16, weight: .light, design: .rounded))
                .foregroundStyle(.white.opacity(0.35))
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack { HistoryView() }
        .environmentObject(AppViewModel())
}
#endif
