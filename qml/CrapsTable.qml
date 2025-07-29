import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    color: "transparent"
    
    // Background felt layer (changeable for themes)
    Rectangle {
        id: backgroundFelt
        anchors.fill: parent
        color: "#0d5f2a"  // Classic green felt
        
        // Future theme options:
        // Disco: animated gradient or pattern
        // Space: dark with stars
        // Luxury: rich textures
        property string feltTheme: "classic"
    }
    
    // Theme properties
    property color tableColor: "#0d5f2a"
    property color passLineColor: "#1a4d7280"  // Semi-transparent blue
    property color dontPassColor: "#4d1a1a80"  // Semi-transparent red
    property color fieldColor: "#4a4a4a60"     // Semi-transparent gray
    
    property var gameLogic
    
    function showDiceResult(die1, die2) {
        // Stop rolling animation and show final values
        if (dice1.item) dice1.item.stopRolling(die1)
        if (dice2.item) dice2.item.stopRolling(die2)
        
        resultText.text = "Roll: " + die1 + " + " + die2 + " = " + (die1 + die2)
        errorText.text = "" // Clear any error
    }
    
    function startDiceRoll() {
        // Start rolling animation
        if (dice1.item) dice1.item.startRolling()
        if (dice2.item) dice2.item.startRolling()
        
        // Show result after animation delay
        rollDelayTimer.restart()
    }
    
    Timer {
        id: rollDelayTimer
        interval: 1000
        onTriggered: gameLogic.rollDice()
    }
    
    function showError(message) {
        errorText.text = message
        errorTimer.restart()
    }
    
    Timer {
        id: errorTimer
        interval: 3000
        onTriggered: errorText.text = ""
    }
    
    // Header with title and controls
    Column {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
        spacing: 10
        
        Text {
            text: "Qt Casino - Craps Table"
            font.pixelSize: 20
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        // Game state and controls
        Row {
            spacing: 30
            anchors.horizontalCenter: parent.horizontalCenter
            
            Column {
                spacing: 5
                
                Text {
                    text: "Phase: " + (gameLogic ? gameLogic.gamePhase : "Come Out")
                    color: "yellow"
                    font.pixelSize: 12
                    font.bold: true
                }
                
                Text {
                    text: gameLogic && gameLogic.point > 0 ? "Point: " + gameLogic.point : "No Point"
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                }
            }
            
            // Dice area
            Row {
                spacing: 15
                
                Loader {
                    id: dice1
                    source: "qrc:/qml/Die.qml"
                    property int value: 1
                    onLoaded: item.value = Qt.binding(() => value)
                }
                
                Loader {
                    id: dice2
                    source: "qrc:/qml/Die.qml"
                    property int value: 1
                    onLoaded: item.value = Qt.binding(() => value)
                }
            }
            
            Column {
                spacing: 5
                
                Button {
                    text: "Roll Dice"
                    onClicked: startDiceRoll()
                }
                
                Text {
                    text: "Chips: $" + (gameLogic ? gameLogic.playerChips : 0)
                    color: "yellow"
                    font.pixelSize: 14
                    font.bold: true
                }
            }
        }
        
        // Result text
        Text {
            id: resultText
            text: gameLogic && gameLogic.lastResult !== "" ? gameLogic.lastResult : "Click Roll to start"
            color: "white"
            font.pixelSize: 14
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Text {
            id: errorText
            text: ""
            color: "red"
            font.pixelSize: 12
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            visible: text !== ""
        }
    }
    
    // Main craps table layout (proper casino style)
    Item {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 30
        width: parent.width * 0.85
        height: parent.height * 0.6
        
        // Point numbers row (top)
        Row {
            id: pointNumbers
            spacing: 3
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            
            Repeater {
                model: [4, 5, "SIX", 8, "NINE", 10]
                
                Rectangle {
                    width: 70
                    height: 45
                    color: {
                        let pointValue = (modelData === "SIX") ? 6 : (modelData === "NINE") ? 9 : modelData
                        return (gameLogic && gameLogic.point === pointValue) ? "#ffd700" : "#ffffff40"
                    }
                    border.color: "white"
                    border.width: 2
                    
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        color: {
                            let pointValue = (modelData === "SIX") ? 6 : (modelData === "NINE") ? 9 : modelData
                            return (gameLogic && gameLogic.point === pointValue) ? "black" : "black"
                        }
                        font.pixelSize: 16
                        font.bold: true
                    }
                }
            }
        }
        
        // Central COME area (large red area)
        Rectangle {
            id: comeArea
            width: parent.width * 0.7
            height: 80
            anchors.top: pointNumbers.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#cc333360"  // Semi-transparent red
            border.color: "white"
            border.width: 2
            
            Text {
                anchors.centerIn: parent
                text: "COME"
                color: "white"
                font.pixelSize: 24
                font.bold: true
            }
        }
        
        // FIELD area (central yellow area)
        Rectangle {
            id: fieldArea
            width: parent.width * 0.7
            height: 50
            anchors.top: comeArea.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.fieldColor
            border.color: "white"
            border.width: 2
            
            Row {
                anchors.centerIn: parent
                spacing: 10
                
                Text {
                    text: "FIELD"
                    color: "yellow"
                    font.pixelSize: 16
                    font.bold: true
                }
                
                Text {
                    text: "2, 3, 4, 9, 10, 11, 12"
                    color: "white"
                    font.pixelSize: 12
                }
                
                Text {
                    text: "Pays Double: 2, 12"
                    color: "yellow"
                    font.pixelSize: 10
                }
            }
        }
        
        // Don't Pass Bar
        Rectangle {
            id: dontPassBar
            width: parent.width
            height: 35
            anchors.top: fieldArea.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.dontPassColor
            border.color: "white"
            border.width: 2
            
            Row {
                anchors.centerIn: parent
                spacing: 20
                
                Text {
                    text: "Don't Pass Bar"
                    color: "white"
                    font.pixelSize: 12
                    font.bold: true
                }
                
                Loader {
                    id: dontPassChips
                    source: gameLogic && gameLogic.dontPassBet > 0 ? "qrc:/qml/ChipStack.qml" : ""
                    onLoaded: if (item) item.updateStack(gameLogic.dontPassBet)
                    
                    // Update stack when bet amount changes  
                    property int betAmount: gameLogic ? gameLogic.dontPassBet : 0
                    onBetAmountChanged: {
                        if (item && betAmount > 0) {
                            item.updateStack(betAmount)
                        }
                    }
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: gameLogic.placeBet("Don't Pass")
            }
        }
        
        // Pass Line (bottom, prominent)
        Rectangle {
            id: passLine
            width: parent.width
            height: 50
            anchors.top: dontPassBar.bottom
            anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            color: root.passLineColor
            border.color: "white"
            border.width: 3
            
            Row {
                anchors.centerIn: parent
                spacing: 20
                
                Text {
                    text: "PASS LINE"
                    color: "white"
                    font.pixelSize: 18
                    font.bold: true
                }
                
                Loader {
                    id: passLineChips
                    source: gameLogic && gameLogic.passLineBet > 0 ? "qrc:/qml/ChipStack.qml" : ""
                    onLoaded: if (item) item.updateStack(gameLogic.passLineBet)
                    
                    // Update stack when bet amount changes
                    property int betAmount: gameLogic ? gameLogic.passLineBet : 0
                    onBetAmountChanged: {
                        if (item && betAmount > 0) {
                            item.updateStack(betAmount)
                        }
                    }
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: gameLogic.placeBet("Pass Line")
            }
        }
    }
    
    // Bet amount selector at bottom
    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 20
        spacing: 5
        
        Text {
            text: "Bet Amount:"
            color: "white"
            font.pixelSize: 14
            anchors.verticalCenter: parent.verticalCenter
        }
        
        Repeater {
            model: gameLogic ? gameLogic.availableBetAmounts : []
            
            Item {
                width: 45
                height: 45
                
                Loader {
                    id: chipLoader
                    source: "qrc:/qml/Chip.qml"
                    anchors.centerIn: parent
                    
                    onLoaded: {
                        item.value = modelData
                    }
                }
                
                // Selection indicator
                Rectangle {
                    width: parent.width + 4
                    height: parent.height + 4
                    radius: (parent.width + 4) / 2
                    anchors.centerIn: parent
                    color: "transparent"
                    border.color: "#ffd700"
                    border.width: 3
                    visible: gameLogic && gameLogic.selectedBetAmount === modelData
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: gameLogic.setSelectedBetAmount(modelData)
                }
            }
        }
    }
}