import QtQuick

Rectangle {
    id: root
    width: 40
    height: 40
    radius: 20
    
    property int value: 5
    property color chipColor: getChipColor()
    
    color: chipColor
    border.color: "white"
    border.width: 2
    
    // Inner circle for design
    Rectangle {
        width: parent.width - 8
        height: parent.height - 8
        radius: (parent.width - 8) / 2
        anchors.centerIn: parent
        color: "transparent"
        border.color: "white"
        border.width: 1
    }
    
    Text {
        anchors.centerIn: parent
        text: "$" + value
        color: getTextColor()
        font.pixelSize: 10
        font.bold: true
    }
    
    function getChipColor() {
        switch(value) {
            case 5: return "#dd3333"      // Red
            case 10: return "#3333dd"     // Blue  
            case 25: return "#228822"     // Darker Green
            case 50: return "#ff8800"     // Better Orange
            case 100: return "#222222"    // Dark Gray (better than pure black)
            case 250: return "#aa22aa"    // Purple
            case 500: return "#cc9900"    // Gold/Brown instead of yellow
            default: return "#666666"     // Gray
        }
    }
    
    function getTextColor() {
        switch(value) {
            case 500: return "#ffffff"    // White text on gold
            case 25: return "#ffffff"     // White text on dark green
            case 100: return "#ffffff"    // White text on dark gray
            case 250: return "#ffffff"    // White text on purple
            default: return "#ffffff"     // White for all others
        }
    }
}