# iOS XO Game (Tic-Tac-Toe)

A beautiful and modern iOS Tic-Tac-Toe game built with SwiftUI.

## Features

- **Clean SwiftUI Interface**: Modern, responsive design that works on iPhone and iPad
- **Smooth Animations**: Elegant transitions and visual feedback for better user experience
- **Smart Game Logic**: Complete tic-tac-toe logic with win detection and tie handling
- **Visual Win Indication**: Winning cells are highlighted with special styling
- **Reset Functionality**: Easy "New Game" button to start fresh
- **Color-Coded Players**: Player X (Blue) vs Player O (Red)

## Game Components

### 1. `XOGameApp.swift`
- Main app entry point using SwiftUI App lifecycle

### 2. `ContentView.swift`
- Root view that hosts the game interface
- Contains the app title and game container

### 3. `GameLogic.swift`
- Complete game state management
- Player enum with associated colors
- Win condition checking (rows, columns, diagonals)
- Board state tracking and move validation

### 4. `GameView.swift`
- Main game interface with 3x3 grid
- Interactive game cells with animations
- Status display showing current player or game result
- Reset button for starting new games

## How to Run

1. Open `XOGame.xcodeproj` in Xcode
2. Select your target device/simulator
3. Press ⌘+R to build and run

## Game Rules

- Player X (Blue) goes first
- Players alternate turns
- First to get 3 in a row (horizontal, vertical, or diagonal) wins
- If all 9 squares are filled with no winner, it's a tie
- Use "New Game" button to reset and play again

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.0+

## Architecture

The app follows MVVM architecture:
- **Model**: `GameLogic` class manages game state
- **View**: SwiftUI views handle the interface
- **Binding**: `@StateObject` and `@Published` provide reactive updates
