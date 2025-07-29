import QtQuick
import QtQuick.Controls
import QtCasino

ApplicationWindow {
    id: window
    width: 800
    height: 600
    visible: true
    title: "Qt Casino - Craps"
    
    GameLogic {
        id: gameLogic
        
        onDiceRolled: function(die1, die2) {
            crapsTable.showDiceResult(die1, die2)
        }
    }
    
    CrapsTable {
        id: crapsTable
        anchors.fill: parent
        gameLogic: gameLogic
    }
}