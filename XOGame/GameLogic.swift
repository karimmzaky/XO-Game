import Foundation

enum Player: String, CaseIterable {
    case x = "X"
    case o = "O"
    
    var color: String {
        switch self {
        case .x: return "blue"
        case .o: return "red"
        }
    }
}

enum GameState {
    case ongoing
    case winner(Player)
    case tie
}

class GameLogic: ObservableObject {
    @Published var board: [[Player?]] = Array(repeating: Array(repeating: nil, count: 3), count: 3)
    @Published var currentPlayer: Player = .x
    @Published var gameState: GameState = .ongoing
    @Published var winningCells: [(Int, Int)] = []
    
    func makeMove(row: Int, col: Int) {
        guard gameState == .ongoing && board[row][col] == nil else { return }
        
        board[row][col] = currentPlayer
        
        if let winner = checkWinner() {
            gameState = .winner(winner)
        } else if isBoardFull() {
            gameState = .tie
        } else {
            currentPlayer = currentPlayer == .x ? .o : .x
        }
    }
    
    func resetGame() {
        board = Array(repeating: Array(repeating: nil, count: 3), count: 3)
        currentPlayer = .x
        gameState = .ongoing
        winningCells = []
    }
    
    private func checkWinner() -> Player? {
        // Check rows
        for row in 0..<3 {
            if let player = board[row][0],
               board[row][0] == board[row][1] && board[row][1] == board[row][2] {
                winningCells = [(row, 0), (row, 1), (row, 2)]
                return player
            }
        }
        
        // Check columns
        for col in 0..<3 {
            if let player = board[0][col],
               board[0][col] == board[1][col] && board[1][col] == board[2][col] {
                winningCells = [(0, col), (1, col), (2, col)]
                return player
            }
        }
        
        // Check diagonals
        if let player = board[0][0],
           board[0][0] == board[1][1] && board[1][1] == board[2][2] {
            winningCells = [(0, 0), (1, 1), (2, 2)]
            return player
        }
        
        if let player = board[0][2],
           board[0][2] == board[1][1] && board[1][1] == board[2][0] {
            winningCells = [(0, 2), (1, 1), (2, 0)]
            return player
        }
        
        return nil
    }
    
    private func isBoardFull() -> Bool {
        return board.allSatisfy { row in
            row.allSatisfy { $0 != nil }
        }
    }
    
    func getGameStatusText() -> String {
        switch gameState {
        case .ongoing:
            return "Player \(currentPlayer.rawValue)'s Turn"
        case .winner(let player):
            return "Player \(player.rawValue) Wins!"
        case .tie:
            return "It's a Tie!"
        }
    }
}