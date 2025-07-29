import QtQuick

Item {
    id: root
    width: 40
    height: 40
    
    property int totalValue: 0
    property var chipBreakdown: []
    
    function updateStack(value) {
        totalValue = value
        chipBreakdown = breakdownIntoChips(value)
    }
    
    function breakdownIntoChips(amount) {
        let chips = []
        let remaining = amount
        let denominations = [500, 250, 100, 50, 25, 10, 5]
        
        for (let denom of denominations) {
            while (remaining >= denom) {
                chips.push(denom)
                remaining -= denom
            }
        }
        return chips
    }
    
    Repeater {
        model: chipBreakdown
        
        Loader {
            source: "qrc:/qml/Chip.qml"
            x: index * 2  // Slight horizontal offset for 3D effect
            y: -index * 3  // Stack vertically
            z: index
            
            onLoaded: {
                item.value = modelData
                item.width = 36  // Slightly smaller for stacking
                item.height = 36
            }
        }
    }
    
    // Subtle total amount text
    Text {
        anchors.top: parent.bottom
        anchors.topMargin: 2
        anchors.horizontalCenter: parent.horizontalCenter
        text: totalValue > 0 ? "$" + totalValue : ""
        color: "#cccccc"
        font.pixelSize: 8
        visible: totalValue > 0
    }
}