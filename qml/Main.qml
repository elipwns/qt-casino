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
        
        onBetError: function(message) {
            crapsTable.showError(message)
        }
    }
    
    Loader {
        id: crapsTable
        anchors.fill: parent
        source: "qrc:/qml/CrapsTable.qml"
        
        onLoaded: {
            item.gameLogic = gameLogic
        }
        
        function showDiceResult(die1, die2) {
            if (item) item.showDiceResult(die1, die2)
        }
        
        function showError(message) {
            if (item) item.showError(message)
        }
    }
}