import QtQuick

Rectangle {
    id: root
    width: 60
    height: 60
    color: "white"
    border.color: "black"
    border.width: 2
    radius: 8
    
    property int value: 1
    property bool isRolling: false
    
    function startRolling() {
        isRolling = true
        rollAnimation.start()
    }
    
    function stopRolling(finalValue) {
        rollAnimation.stop()
        root.rotation = 0  // Reset rotation
        isRolling = false
        value = finalValue
        // Force dot pattern update
        for (var i = 0; i < 9; i++) {
            dotRepeater.itemAt(i).color = getDotVisible(i) ? "black" : "transparent"
        }
    }
    
    RotationAnimation {
        id: rollAnimation
        target: root
        property: "rotation"
        from: 0
        to: 360
        duration: 800
        loops: Animation.Infinite
        easing.type: Easing.InOutQuad
    }
    
    Grid {
        anchors.centerIn: parent
        rows: 3
        columns: 3
        spacing: 4
        
        Repeater {
            id: dotRepeater
            model: 9
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: getDotVisible(index) ? "black" : "transparent"
            }
        }
    }
    
    function getDotVisible(position) {
        if (isRolling) {
            // Show random pattern while rolling
            return Math.random() > 0.5
        }
        
        // Positions: 0,1,2 (top row), 3,4,5 (middle), 6,7,8 (bottom)
        switch(value) {
            case 1: return position === 4  // center
            case 2: return position === 0 || position === 8  // corners
            case 3: return position === 0 || position === 4 || position === 8  // diagonal
            case 4: return position === 0 || position === 2 || position === 6 || position === 8  // four corners
            case 5: return position === 0 || position === 2 || position === 4 || position === 6 || position === 8  // four corners + center
            case 6: return position === 0 || position === 2 || position === 3 || position === 5 || position === 6 || position === 8  // six dots
            default: return false
        }
    }
    
    Timer {
        id: dotUpdateTimer
        interval: 100
        running: isRolling
        repeat: true
        onTriggered: {
            // Force dot pattern update while rolling
            for (var i = 0; i < 9; i++) {
                dotRepeater.itemAt(i).color = getDotVisible(i) ? "black" : "transparent"
            }
        }
    }
}