// File: Components/EmotionCard.swift
import SwiftUI

// MARK: - EmotionCard
struct EmotionCard: View {
    let emotion: Emotion
    let action: () -> Void
    
    @State private var isPressed = false
    
    private var startColor: Color { emotion.colorPalette.first ?? .black }
    private var endColor: Color { emotion.colorPalette.last ?? .black }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                // Gradient background
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [startColor, endColor],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.12), lineWidth: 1)
                    )
                
                VStack(spacing: 14) {
                    Image(systemName: emotion.icon)
                        .font(.system(size: 30, weight: .thin))
                        .foregroundStyle(.white.opacity(0.90))
                    
                    Text(emotion.title)
                        .font(.system(size: 18, weight: .light, design: .rounded))
                        .foregroundStyle(.white)
                }
                .padding(.vertical, 28)
            }
        }
        .scaleEffect(isPressed ? 0.96 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
        .buttonStyle(PressedButtonStyle(isPressed: $isPressed))
        .accessibilityLabel("Select \(emotion.title)")
    }
}

// MARK: - PressedButtonStyle
private struct PressedButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { val in
                isPressed = val
            }
    }
}

#if DEBUG
#Preview {
    EmotionCard(emotion: .angry) {}
        .frame(width: 160, height: 120)
        .padding()
}
#endif
