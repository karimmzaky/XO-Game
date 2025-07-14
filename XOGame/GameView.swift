import SwiftUI

struct GameView: View {
    @StateObject private var gameLogic = GameLogic()
    
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
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        gameLogic.makeMove(row: row, col: col)
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

#Preview {
    GameView()
}