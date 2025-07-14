# 🎮 Try Your XO Game NOW - Online Simulators

Test your game immediately on your iPhone browser! Here are direct links and ready-to-use code.

## 🚀 **Option 1: Flutter/Android Version** (EASIEST)

### **Try it NOW:**
1. **Open this link on your iPhone**: https://dartpad.dev
2. **Click**: "New Pad" → Choose "Flutter"
3. **Delete** all existing code
4. **Copy & paste** this complete XO game:

```dart
import 'package:flutter/material.dart';

void main() => runApp(XOGameApp());

class XOGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'XO Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  String winner = '';
  List<int> winningCells = [];
  int xWins = 0;
  int oWins = 0;
  int ties = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('XO Game', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Game Status
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: winner.isEmpty ? Colors.blue.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                winner.isEmpty 
                  ? 'Player $currentPlayer\'s Turn' 
                  : winner == 'Tie' 
                    ? 'It\'s a Tie!' 
                    : 'Player $winner Wins! 🎉',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                  color: winner.isEmpty 
                    ? (currentPlayer == 'X' ? Colors.blue : Colors.red)
                    : Colors.green.shade700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            SizedBox(height: 20),
            
            // Game Board
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.opacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) {
                      bool isWinningCell = winningCells.contains(index);
                      return GestureDetector(
                        onTap: () => makeMove(index),
                        child: AnimatedBuilder(
                          animation: _scaleAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: board[index].isNotEmpty ? _scaleAnimation.value : 1.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isWinningCell 
                                    ? Colors.yellow.shade200 
                                    : Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isWinningCell 
                                      ? Colors.yellow.shade600 
                                      : Colors.grey.shade300,
                                    width: isWinningCell ? 3 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    board[index],
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: board[index] == 'X' 
                                        ? Colors.blue 
                                        : Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 20),
            
            // New Game Button
            ElevatedButton(
              onPressed: resetGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 5,
              ),
              child: Text(
                'New Game',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            
            SizedBox(height: 20),
            
            // Statistics
            if (xWins + oWins + ties > 0)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatColumn('X Wins', xWins.toString(), Colors.blue),
                    _buildStatColumn('Ties', ties.toString(), Colors.orange),
                    _buildStatColumn('O Wins', oWins.toString(), Colors.red),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  void makeMove(int index) {
    if (board[index] == '' && winner == '') {
      setState(() {
        board[index] = currentPlayer;
        _animationController.forward().then((_) {
          _animationController.reverse();
        });
        
        if (checkWinner()) {
          if (currentPlayer == 'X') {
            xWins++;
          } else {
            oWins++;
          }
        } else if (board.every((cell) => cell.isNotEmpty)) {
          winner = 'Tie';
          ties++;
        } else {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool checkWinner() {
    List<List<int>> winningCombos = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
      [0, 4, 8], [2, 4, 6], // Diagonals
    ];

    for (var combo in winningCombos) {
      if (board[combo[0]] != '' &&
          board[combo[0]] == board[combo[1]] &&
          board[combo[1]] == board[combo[2]]) {
        winner = currentPlayer;
        winningCells = combo;
        return true;
      }
    }
    return false;
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      winner = '';
      winningCells = [];
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
```

5. **Click "Run"** (blue play button)
6. **See your game** running immediately! 🎉

---

## 🍎 **Option 2: iOS SwiftUI Version**

### **Online iOS Simulator:**
1. **Open**: https://appetize.io
2. **Click**: "Demo" → "iOS Simulator"
3. **Unfortunately**: You can't easily upload custom code to try SwiftUI online

### **Alternative - SwiftUI Playground:**
1. **Try**: https://developer.apple.com/swift-playgrounds/
2. **Note**: Limited functionality, better to use DartPad above

---

## 🎯 **What You'll See in DartPad:**

✨ **Beautiful Features:**
- Clean, modern interface
- Smooth animations when placing X's and O's
- Winning cells highlighted in yellow
- Game statistics tracking
- Professional Material Design
- Responsive layout that works on mobile

🎮 **Full Game Features:**
- Player vs Player gameplay
- Win detection (rows, columns, diagonals)
- Tie game detection
- Game statistics (X wins, O wins, ties)
- "New Game" reset button
- Visual feedback and animations

---

## 🚀 **Next Steps After Trying:**

### **If you like the Flutter version:**
1. **Bookmark** DartPad.dev
2. **Save your code** by creating account
3. **Experiment** with colors, text, animations
4. **Learn Flutter** to build more features
5. **Eventually publish** to Google Play Store

### **If you want to stick with iOS:**
1. **Choose cloud Mac solution** from our iOS guide
2. **Rent MacinCloud** for $30/month
3. **Upload your iOS project**
4. **Submit to App Store**

---

## 💡 **Pro Tips for DartPad:**

- **Save your work**: Create free account to save projects
- **Share easily**: Get shareable links to show friends
- **Mobile friendly**: Works great on iPhone browser
- **Real-time preview**: See changes instantly
- **Learn by doing**: Modify the code and see what happens!

---

## 🎨 **Try These Modifications:**

Once you have the game running, try changing:

```dart
// Change colors:
primarySwatch: Colors.purple,  // Instead of Colors.blue

// Change text:
title: 'My Awesome Game',  // Instead of 'XO Game'

// Change cell size:
fontSize: 50,  // Instead of 40
```

**Click "Run" after each change to see the result!**

---

## 🎉 **Ready to Try?**

**Just go to**: https://dartpad.dev 

**Copy the code above and click Run!**

Your XO game will be running in seconds! 🚀

Tell me how it works for you! 😊