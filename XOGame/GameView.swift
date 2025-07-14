import SwiftUI
import AVFoundation

struct GameView: View {
    @StateObject private var gameLogic = GameLogic()
    @State private var audioPlayer: AVAudioPlayer?
    @State private var showStats = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Game status
            Text(gameLogic.getGameStatusText())
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(getStatusColor())
                .animation(.easeInOut, value: gameLogic.gameState)
            
            // Game board
            VStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { col in
                            GameCellView(
                                player: gameLogic.board[row][col],
                                isWinningCell: gameLogic.winningCells.contains { $0.0 == row && $0.1 == col },
                                action: {
                                    // Haptic feedback
                                    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                    impactFeedback.impactOccurred()
                                    
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        let previousState = gameLogic.gameState
                                        gameLogic.makeMove(row: row, col: col)
                                        
                                        // Game end haptic feedback
                                        if case .ongoing = previousState,
                                           case .winner(_) = gameLogic.gameState {
                                            let successFeedback = UINotificationFeedbackGenerator()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                successFeedback.notificationOccurred(.success)
                                            }
                                        } else if case .ongoing = previousState,
                                                  case .tie = gameLogic.gameState {
                                            let warningFeedback = UINotificationFeedbackGenerator()
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                warningFeedback.notificationOccurred(.warning)
                                            }
                                        }
                                    }
                                }
                            )
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            
            // Reset button
            Button(action: {
                withAnimation(.easeInOut) {
                    gameLogic.resetGame()
                }
            }) {
                Text("New Game")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .cornerRadius(25)
            }
            .scaleEffect(gameLogic.gameState != .ongoing ? 1.1 : 1.0)
            .animation(.easeInOut, value: gameLogic.gameState)
            
            // Statistics Section
            if gameLogic.stats.totalGames > 0 {
                VStack(spacing: 8) {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            showStats.toggle()
                        }
                    }) {
                        HStack {
                            Text("Game Statistics")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Image(systemName: showStats ? "chevron.up" : "chevron.down")
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    if showStats {
                        VStack(spacing: 12) {
                            HStack {
                                StatItem(title: "Games Played", value: gameLogic.stats.gamesPlayed)
                                Spacer()
                                StatItem(title: "Ties", value: "\(gameLogic.stats.ties)")
                            }
                            
                            HStack {
                                VStack(spacing: 4) {
                                    Text("Player X")
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                        .fontWeight(.semibold)
                                    Text("\(gameLogic.stats.xWins) wins")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                    Text(gameLogic.stats.winPercentageX)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                
                                VStack(spacing: 4) {
                                    Text("Player O")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .fontWeight(.semibold)
                                    Text("\(gameLogic.stats.oWins) wins")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                    Text(gameLogic.stats.winPercentageO)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .scale))
                    }
                }
            }
        }
        .padding()
    }
    
    private func getStatusColor() -> Color {
        switch gameLogic.gameState {
        case .ongoing:
            return gameLogic.currentPlayer == .x ? .blue : .red
        case .winner(let player):
            return player == .x ? .blue : .red
        case .tie:
            return .orange
        }
    }
}

struct GameCellView: View {
    let player: Player?
    let isWinningCell: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Rectangle()
                    .fill(backgroundColor)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: isWinningCell ? 3 : 1)
                    )
                
                if let player = player {
                    Text(player.rawValue)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(player == .x ? .blue : .red)
                        .scaleEffect(1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: player)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(player != nil)
    }
    
    private var backgroundColor: Color {
        if isWinningCell {
            return Color.yellow.opacity(0.3)
        } else if player != nil {
            return Color.gray.opacity(0.1)
        } else {
            return Color.white
        }
    }
    
    private var borderColor: Color {
        if isWinningCell {
            return .yellow
        } else {
            return Color.gray.opacity(0.3)
        }
    }
}

struct StatItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    GameView()
}