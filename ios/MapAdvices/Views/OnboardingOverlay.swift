import SwiftUI

struct OnboardingOverlay: View {
    var dismiss: () -> Void

    var body: some View {
        Color.black.opacity(0.5)
            .ignoresSafeArea()
            .overlay(
                VStack {
                    Text("Swipe to explore places!")
                        .font(.headline)
                        .padding(.bottom, 8)
                    Text("👆")
                        .font(.largeTitle)
                        .padding(.bottom, 8)
                    Text("Swipe up to see the next place or down to go back")
                        .multilineTextAlignment(.center)
                        .font(.subheadline)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
            )
            .onTapGesture { dismiss() }
    }
}
