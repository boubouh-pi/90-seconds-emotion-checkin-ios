// File: Views/EmotionPickerView.swift
import SwiftUI

struct EmotionPickerView: View {
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var navigateToSession = false
    @State private var appeared = false
    
    let columns = [
        GridItem(.flexible(), spacing: 18),
        GridItem(.flexible(), spacing: 18)
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.12).ignoresSafeArea()
            
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("How are you feeling?")
                        .font(.system(size: 30, weight: .thin, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text("Choose what's strongest right now.")
                        .font(.system(size: 14, weight: .light, design: .rounded))
                        .foregroundStyle(.white.opacity(0.45))
                }
                .padding(.top, 26)
                .padding(.bottom, 20)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 16)
                .animation(.easeOut(duration: 0.5), value: appeared)
                
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(Array(Emotion.all.enumerated()), id: \.element.id) { index, emotion in
                        EmotionCard(emotion: emotion) {
                            Haptics.tap()
                            SoundManager.shared.play("humordome", volume: 0.6)
                            appVM.startSession(emotion: emotion)
                            navigateToSession = true
                        }
                        .frame(height: 150) // ✅ bigger
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 24)
                        .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.08 + 0.15), value: appeared)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.9))
                        Text("What you'll do in 90 seconds")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        bullet("Label the emotion", subtitle: "20 seconds to slow the mind.")
                        bullet("Guided breathing", subtitle: "45 seconds to calm the body.")
                        bullet("Reframe + next step", subtitle: "25 seconds to regain control.")
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(.white.opacity(0.10), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 24)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 18)
                .animation(.easeOut(duration: 0.6).delay(0.25), value: appeared)
                
                Spacer(minLength: 16)
                
                Text("Most intense feelings peak and soften when you stop feeding them.")
                    .font(.system(size: 12, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.35))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 34)
                    .padding(.bottom, 18)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.6).delay(0.35), value: appeared)
            }
            .frame(maxWidth: 980) // ✅ fills nicely on Mac
            .frame(maxWidth: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { appeared = true }
        
        // ✅ When resetSession makes selectedEmotion nil, pop back to Welcome
        .onChange(of: appVM.selectedEmotion) { newValue in
            if newValue == nil { dismiss() }
        }
        
        .navigationDestination(isPresented: $navigateToSession) {
            SessionView()
        }
    }
    
    @ViewBuilder
    private func bullet(_ title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white.opacity(0.75))
                .padding(.top, 1)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(.white.opacity(0.85))
                Text(subtitle)
                    .font(.system(size: 12, weight: .light, design: .rounded))
                    .foregroundStyle(.white.opacity(0.45))
            }
        }
    }
}
