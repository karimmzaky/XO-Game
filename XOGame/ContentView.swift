import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 8) {
                    Text("XO Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Classic Tic-Tac-Toe")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                
                GameView()
                
                VStack(spacing: 4) {
                    Text("Challenge your friends!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("v1.0")
                        .font(.caption2)
                        .foregroundColor(.tertiary)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Better for iPhone
    }
}

#Preview {
    ContentView()
}