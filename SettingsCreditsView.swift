// File: Views/SettingsCreditsView.swift
import SwiftUI

// MARK: - SettingsCreditsView
struct SettingsCreditsView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var showClearConfirm = false

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.12).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    // Data section
                    sectionHeader("Data")
                    VStack(spacing: 0) {
                        rowButton(title: "Clear all session history", icon: "trash", color: .red.opacity(0.75)) {
                            Haptics.tap()
                            showClearConfirm = true
                        }
                    }
                    .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))

                    // Credits section
                    sectionHeader("Credits")
                    VStack(alignment: .leading, spacing: 12) {
                        creditRow(title: "SF Symbols", detail: "Icons by Apple Inc. Used under the SF Symbols license.")
                        Divider().background(.white.opacity(0.10))
                        creditRow(title: "Third-party libraries", detail: "None. This app has zero external dependencies.")
                        Divider().background(.white.opacity(0.10))
                        creditRow(title: "Sound assets", detail: "No audio assets included in this release.")
                    }
                    .padding(16)
                    .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))

                    // About section
                    sectionHeader("About")
                    VStack(alignment: .leading, spacing: 8) {
                        Text("90 Seconds")
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundStyle(.white)
                        Text("A Swift Student Challenge submission.\nBuilt with SwiftUI. No network access required.\nAll data stored locally on this device.")
                            .font(.system(size: 13, weight: .light, design: .rounded))
                            .foregroundStyle(.white.opacity(0.50))
                            .lineSpacing(4)

                        Text("\nThis app provides psychoeducational guidance only. It is not a substitute for professional mental health care.")
                            .font(.system(size: 12, weight: .light, design: .rounded))
                            .foregroundStyle(.white.opacity(0.35))
                            .lineSpacing(3)
                    }
                    .padding(16)
                    .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))

                    Spacer(minLength: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
        }
        .navigationTitle("Settings & Credits")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("Clear all history?", isPresented: $showClearConfirm) {
            Button("Clear", role: .destructive) { appVM.clearHistory() }
            Button("Cancel", role: .cancel) {}
        }
    }

    // MARK: - Helpers
    private func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(.system(size: 11, weight: .semibold, design: .rounded))
            .tracking(2)
            .foregroundStyle(.white.opacity(0.35))
            .padding(.leading, 4)
    }

    private func rowButton(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundStyle(color)
                    .frame(width: 24)
                Text(title)
                    .font(.system(size: 15, weight: .regular, design: .rounded))
                    .foregroundStyle(color)
                Spacer()
            }
            .padding(16)
        }
        .accessibilityLabel(title)
    }

    private func creditRow(title: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(.white.opacity(0.75))
            Text(detail)
                .font(.system(size: 13, weight: .light, design: .rounded))
                .foregroundStyle(.white.opacity(0.45))
                .lineSpacing(3)
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack { SettingsCreditsView() }
        .environmentObject(AppViewModel())
}
#endif
