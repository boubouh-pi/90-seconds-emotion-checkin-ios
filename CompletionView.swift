// File: Views/CompletionView.swift
import SwiftUI

// MARK: - CompletionView
struct CompletionView: View {
    @EnvironmentObject var appVM: AppViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var microWin: String = ""
    @State private var appeared = false
    @State private var saved = false
    @FocusState private var textFocused: Bool
    
    var emotion: Emotion { appVM.selectedEmotion ?? .anxious }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.10, blue: 0.18), Color(red: 0.08, green: 0.15, blue: 0.25)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        Circle()
                            .fill(.white.opacity(0.07))
                            .frame(width: 100, height: 100)
                        Image(systemName: "checkmark")
                            .font(.system(size: 40, weight: .thin))
                            .foregroundStyle(.white)
                    }
                    .padding(.top, 64)
                    .scaleEffect(appeared ? 1 : 0.6)
                    .opacity(appeared ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.65).delay(0.1), value: appeared)
                    
                    Text("You did it.")
                        .font(.system(size: 36, weight: .thin, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.top, 24)
                        .opacity(appeared ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.25), value: appeared)
                    
                    Text(completionMessage)
                        .font(.system(size: 15, weight: .light, design: .rounded))
                        .foregroundStyle(.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 48)
                        .padding(.top, 10)
                        .opacity(appeared ? 1 : 0)
                        .animation(.easeOut(duration: 0.5).delay(0.35), value: appeared)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Capture your micro-win (optional)")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .tracking(1.5)
                            .foregroundStyle(.white.opacity(0.40))
                        
                        TextField("What did you notice or feel shift?", text: $microWin, axis: .vertical)
                            .font(.system(size: 15, weight: .light, design: .rounded))
                            .foregroundStyle(.white)
                            .tint(.white)
                            .padding(14)
                            .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                            .focused($textFocused)
                            .lineLimit(3...5)
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 40)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.45), value: appeared)
                    
                    PrimaryButton(
                        title: saved ? "Saved ✓" : "Save & Finish",
                        icon: saved ? "checkmark.circle.fill" : "square.and.arrow.down"
                    ) {
                        guard !saved else { return }
                        textFocused = false
                        
                        Haptics.success()
                        SoundManager.shared.play("accept02", volume: 0.75)
                        
                        appVM.completeSession(microWin: microWin.isEmpty ? nil : microWin)
                        saved = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            appVM.resetSession()
                            dismiss() // ✅ pop CompletionView
                        }
                    }
                    .padding(.horizontal, 28)
                    .padding(.top, 24)
                    .disabled(saved)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.55), value: appeared)
                    
                    Button {
                        Haptics.tap()
                        appVM.resetSession()
                        dismiss() // ✅ pop CompletionView, then SessionView will pop due to selectedEmotion nil
                    } label: {
                        Text("Back to Home")
                            .font(.system(size: 14, weight: .light, design: .rounded))
                            .foregroundStyle(.white.opacity(0.40))
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 60)
                    .opacity(appeared ? 1 : 0)
                    .animation(.easeOut(duration: 0.5).delay(0.65), value: appeared)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { appeared = true }
    }
    
    private var completionMessage: String {
        switch emotion.id {
        case "angry":       return "You paused instead of reacting.\nThat was powerful."
        case "anxious":     return "You breathed through the wave.\nYou're more capable than you think."
        case "overwhelmed": return "You took one moment just for yourself.\nThat matters."
        case "sad":         return "You showed up for yourself with kindness.\nThat's enough."
        default:            return "90 seconds of presence is no small thing."
        }
    }
}
