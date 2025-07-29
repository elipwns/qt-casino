import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    color: "#0d5f2a"
    
    property var gameLogic
    
    function showDiceResult(die1, die2) {
        dice1.text = die1
        dice2.text = die2
        resultText.text = "Roll: " + die1 + " + " + die2 + " = " + (die1 + die2)
    }
    
    // Simple craps table layout
    Column {
        anchors.centerIn: parent
        spacing: 20
        
        Text {
            text: "Qt Casino - Craps Table"
            font.pixelSize: 24
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Row {
            spacing: 20
            anchors.horizontalCenter: parent.horizontalCenter
            
            Rectangle {
                id: dice1
                width: 60
                height: 60
                color: "white"
                border.color: "black"
                border.width: 2
                
                property alias text: die1Text.text
                
                Text {
                    id: die1Text
                    anchors.centerIn: parent
                    font.pixelSize: 24
                    text: "?"
                }
            }
            
            Rectangle {
                id: dice2
                width: 60
                height: 60
                color: "white"
                border.color: "black"
                border.width: 2
                
                property alias text: die2Text.text
                
                Text {
                    id: die2Text
                    anchors.centerIn: parent
                    font.pixelSize: 24
                    text: "?"
                }
            }
        }
        
        Text {
            id: resultText
            text: "Click Roll to start"
            color: "white"
            font.pixelSize: 16
            anchors.horizontalCenter: parent.horizontalCenter
        }
        
        Button {
            text: "Roll Dice"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: gameLogic.rollDice()
        }
        
        Text {
            text: "Chips: " + (gameLogic ? gameLogic.playerChips : 0)
            color: "yellow"
            font.pixelSize: 18
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}