// File: Views/SessionView.swift
import SwiftUI

// MARK: - SessionView
struct SessionView: View {
    @EnvironmentObject var appVM: AppViewModel
    @StateObject private var sessionVM = SessionViewModel()
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    @Environment(\.dismiss) var dismiss
    
    @State private var showHelp = false
    @State private var showQuitAlert = false
    @State private var navigateToCompletion = false
    @State private var ringScale: CGFloat = 1.0
    
    var emotion: Emotion { appVM.selectedEmotion ?? .anxious }
    
    var body: some View {
        ZStack {
            animatedBackground
            
            VStack(spacing: 0) {
                topBar
                
                Spacer()
                
                phaseLabel
                timerDisplay
                
                if sessionVM.phase == .breathe {
                    breathingRing
                        .padding(.top, 8)
                }
                
                promptText
                    .padding(.horizontal, 32)
                    .padding(.top, sessionVM.phase == .breathe ? 8 : 32)
                
                Spacer()
                
                controlsBar
                    .padding(.bottom, 48)
            }
        }
        .navigationBarHidden(true)
        .onAppear { sessionVM.start() }
        .onDisappear { sessionVM.stop() }
        
        // ✅ When resetSession() happens, selectedEmotion becomes nil -> pop SessionView
        .onChange(of: appVM.selectedEmotion) { newValue in
            if newValue == nil {
                sessionVM.stop()
                dismiss()
            }
        }
        
        .onChange(of: sessionVM.isFinished) { finished in
            if finished {
                navigateToCompletion = true
            }
        }
        .navigationDestination(isPresented: $navigateToCompletion) {
            CompletionView()
        }
        .navigationDestination(isPresented: $showHelp) {
            HelpView()
        }
        .alert("Quit session?", isPresented: $showQuitAlert) {
            Button("Quit", role: .destructive) {
                sessionVM.stop()
                dismiss()
            }
            Button("Continue", role: .cancel) {}
        } message: {
            Text("Your progress won't be saved.")
        }
    }
    
    // MARK: - Animated Background
    private var animatedBackground: some View {
        ZStack {
            LinearGradient(
                colors: emotion.colorPalette,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 3), value: sessionVM.phase)
            
            if sessionVM.phase == .breathe && !reduceMotion {
                RadialGradient(
                    colors: [emotion.colorPalette[1].opacity(0.4), .clear],
                    center: .center,
                    startRadius: 40,
                    endRadius: 320
                )
                .ignoresSafeArea()
                .scaleEffect(ringScale)
                .animation(.easeInOut(duration: 4).repeatForever(autoreverses: true), value: ringScale)
            }
        }
        .onAppear {
            if !reduceMotion { ringScale = 1.25 }
        }
    }
    
    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            Button {
                Haptics.tap()
                showQuitAlert = true
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(12)
                    .background(.white.opacity(0.10), in: Circle())
            }
            .accessibilityLabel("Quit session")
            
            Spacer()
            
            HStack(spacing: 6) {
                Image(systemName: emotion.icon)
                Text(emotion.title)
            }
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .foregroundStyle(.white.opacity(0.75))
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(.white.opacity(0.10), in: Capsule())
            
            Spacer()
            
            Button {
                Haptics.warning()
                showHelp = true
            } label: {
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.white.opacity(0.6))
                    .padding(12)
                    .background(.white.opacity(0.10), in: Circle())
            }
            .accessibilityLabel("I need help now")
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    // MARK: - Phase Label
    private var phaseLabel: some View {
        let label: String
        switch sessionVM.phase {
        case .labelGround: label = "Label & Ground"
        case .breathe:     label = "Breathe"
        case .reframe:     label = "Reframe & Release"
        }
        return Text(label.uppercased())
            .font(.system(size: 11, weight: .semibold, design: .rounded))
            .tracking(2.5)
            .foregroundStyle(.white.opacity(0.50))
            .animation(.easeInOut(duration: 0.5), value: sessionVM.phase)
    }
    
    // MARK: - Timer Display
    private var timerDisplay: some View {
        Text(TimeFormat.format(seconds: sessionVM.remainingSeconds))
            .font(.system(size: 80, weight: .thin, design: .rounded))
            .foregroundStyle(.white)
            .monospacedDigit()
            .contentTransition(.numericText())
            .animation(.spring(duration: 0.4), value: sessionVM.remainingSeconds)
            .accessibilityLabel("\(sessionVM.remainingSeconds) seconds remaining")
    }
    
    // MARK: - Breathing Ring
    private var breathingRing: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.12), lineWidth: 2)
                .frame(width: 130, height: 130)
            
            Circle()
                .stroke(.white.opacity(0.55), lineWidth: 2)
                .frame(width: 130, height: 130)
                .scaleEffect(reduceMotion ? 1.0 : sessionVM.breatheScale)
                .animation(
                    reduceMotion ? .default : .easeInOut(duration: 4).repeatForever(autoreverses: true),
                    value: sessionVM.breatheScale
                )
            
            Text(sessionVM.breatheInstruction(for: emotion))
                .font(.system(size: 10, weight: .light, design: .rounded))
                .foregroundStyle(.white.opacity(0.70))
                .multilineTextAlignment(.center)
                .frame(width: 90)
        }
        .frame(width: 150, height: 150)
        .transition(.opacity.combined(with: .scale(scale: 0.85)))
    }
    
    // MARK: - Prompt Text
    private var promptText: some View {
        Text(sessionVM.currentPrompt(for: emotion))
            .font(.system(size: 17, weight: .light, design: .rounded))
            .foregroundStyle(.white.opacity(0.88))
            .multilineTextAlignment(.center)
            .lineSpacing(5)
            .transition(.opacity)
            .id(sessionVM.phase)
            .animation(.easeInOut(duration: 0.6), value: sessionVM.phase)
    }
    
    // MARK: - Controls Bar
    private var controlsBar: some View {
        VStack(spacing: 16) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(.white.opacity(0.15)).frame(height: 3)
                    Capsule()
                        .fill(.white.opacity(0.70))
                        .frame(width: geo.size.width * sessionVM.progress, height: 3)
                        .animation(.linear(duration: 1), value: sessionVM.progress)
                }
            }
            .frame(height: 3)
            .padding(.horizontal, 32)
            
            PrimaryButton(
                title: sessionVM.isRunning ? "Pause" : "Resume",
                icon: sessionVM.isRunning ? "pause.fill" : "play.fill"
            ) {
                Haptics.tap()
                if sessionVM.isRunning { sessionVM.stop() } else { sessionVM.start() }
            }
            .padding(.horizontal, 32)
            
            Button {
                Haptics.warning()
                showHelp = true
            } label: {
                Text("I need help now")
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(.white.opacity(0.55))
                    .underline()
            }
            .accessibilityLabel("I need help now — opens safety resources")
        }
    }
}
