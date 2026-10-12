// File: Views/HelpView.swift
import SwiftUI

// MARK: - HelpView
struct HelpView: View {
    @Environment(\.dismiss) var dismiss
    
    private let steps: [(icon: String, text: String)] = [
        ("hand.raised.fill",        "Stop and move to a safe, quiet space if possible."),
        ("eye.fill",                "Look around and name 5 things you can physically see."),
        ("hand.point.up.left.fill", "Feel your feet on the floor. Press them down gently."),
        ("lungs.fill",              "Take 3 slow breaths: breathe in for 4 counts, out for 6."),
        ("person.2.fill",           "Reach out to someone you trust — a friend, family member, or colleague."),
        ("phone.fill",              "If you feel unsafe, contact your local emergency services immediately.")
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.08, blue: 0.18), Color(red: 0.04, green: 0.06, blue: 0.12)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 36, weight: .thin))
                            .foregroundStyle(.white.opacity(0.70))
                            .padding(.bottom, 4)
                        
                        Text("You matter.")
                            .font(.system(size: 32, weight: .thin, design: .rounded))
                            .foregroundStyle(.white)
                        
                        Text("Here are steps to help you get through this moment.")
                            .font(.system(size: 14, weight: .light, design: .rounded))
                            .foregroundStyle(.white.opacity(0.50))
                            .lineSpacing(4)
                    }
                    .padding(.top, 32)
                    .padding(.horizontal, 28)
                    .padding(.bottom, 28)
                    
                    // Steps
                    VStack(spacing: 14) {
                        ForEach(Array(steps.enumerated()), id: \.offset) { index, step in
                            stepRow(icon: step.icon, text: step.text)
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Step \(index + 1): \(step.text)")
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    // Emergency note
                    VStack(alignment: .leading, spacing: 8) {
                        Text("IMPORTANT")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .tracking(2)
                            .foregroundStyle(.white.opacity(0.40))
                        
                        Text("If you or someone else is in immediate danger, contact local emergency services. In the US: 911 · UK: 999 · EU: 112 · AU: 000. Crisis lines: many countries offer 24/7 mental health crisis lines — search '[your country] crisis line' for the correct number.")
                            .font(.system(size: 13, weight: .light, design: .rounded))
                            .foregroundStyle(.white.opacity(0.55))
                            .lineSpacing(4)
                    }
                    .padding(20)
                    .background(.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    
                    // Close button
                    PrimaryButton(title: "I'm okay, go back", icon: "arrow.left") {
                        dismiss()
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 24)
                    .padding(.bottom, 60)
                }
                .frame(maxWidth: 980, alignment: .leading) // nicer on Mac
                .frame(maxWidth: .infinity)
            }
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Step row (aligned)
    private func stepRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.08))
                    .frame(width: 42, height: 42)
                
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.75))
            }
            .frame(width: 42, height: 42, alignment: .top)
            
            Text(text)
                .font(.system(size: 15, weight: .light, design: .rounded))
                .foregroundStyle(.white.opacity(0.85))
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 2)
        }
    }
}

#if DEBUG
#Preview { HelpView() }
#endif
