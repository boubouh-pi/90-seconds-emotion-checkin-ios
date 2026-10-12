// File: Views/WelcomeView.swift
import SwiftUI

// MARK: - WelcomeView
struct WelcomeView: View {
    @EnvironmentObject var appVM: AppViewModel
    @State private var showHistory = false
    @State private var showSettings = false
    @State private var showEmotionPicker = false
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.05, blue: 0.12), Color(red: 0.08, green: 0.08, blue: 0.20)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Ambient orb
            Circle()
                .fill(Color.white.opacity(0.04))
                .frame(width: 340, height: 340)
                .scaleEffect(pulseScale)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: pulseScale)
                .offset(y: -60)

            VStack(spacing: 0) {
                Spacer()

                // Icon
                Image(systemName: "timer")
                    .font(.system(size: 52, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.bottom, 24)
                    .accessibilityHidden(true)

                // Title
                Text("90 Seconds")
                    .font(.system(size: 44, weight: .thin, design: .rounded))
                    .foregroundStyle(.white)
                    .tracking(2)

                Text("A short reset for intense moments.")
                    .font(.system(size: 16, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                    .padding(.horizontal, 40)

                Spacer()

                // Start
                PrimaryButton(title: "Start", icon: "play.fill") {
                    Haptics.tap()
                    showEmotionPicker = true
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 16)
                .accessibilityLabel("Start a 90-second session")

                // Secondary buttons
                HStack(spacing: 16) {
                    SecondaryTextButton(title: "History", icon: "clock") {
                        Haptics.tap()
                        showHistory = true
                    }
                    SecondaryTextButton(title: "Settings", icon: "gearshape") {
                        Haptics.tap()
                        showSettings = true
                    }
                }
                .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
        .onAppear { pulseScale = 1.12 }
        // Navigation destinations
        .navigationDestination(isPresented: $showEmotionPicker) {
            EmotionPickerView()
        }
        .navigationDestination(isPresented: $showHistory) {
            HistoryView()
        }
        .navigationDestination(isPresented: $showSettings) {
            SettingsCreditsView()
        }
    }
}

// MARK: - SecondaryTextButton
private struct SecondaryTextButton: View {
    let title: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
            .font(.system(size: 14, weight: .regular, design: .rounded))
            .foregroundStyle(.white.opacity(0.50))
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(.white.opacity(0.06), in: Capsule())
        }
        .accessibilityLabel(title)
    }
}

#if DEBUG
#Preview {
    NavigationStack { WelcomeView() }
        .environmentObject(AppViewModel())
}
#endif
