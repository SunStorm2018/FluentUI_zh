import QtQuick
import QtQuick.Controls
import QtQuick.Window
import FluentUI

Item {
    property string  headerText: ""
    property int headerHeight : 45
    property Component headerDelegate: com_header
    property bool expand: false
    property int contentHeight : 300
    default property alias content: container.data
    id:control
    implicitHeight: Math.max((layout_header.height + layout_container.height),layout_header.height)
    implicitWidth: 400
    QtObject{
        id:d
        property bool flag: false
        function toggle(){
            d.flag = true
            expand = !expand
            d.flag = false
        }
    }
    clip: true
    Component {
        id: com_header
        Item {
            FluText {
                text: control.headerText
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 15
                }
            }
        }
    }
    Rectangle{
        id:layout_header
        width: parent.width
        height: control.headerHeight
        radius: 4
        border.color: FluTheme.dividerColor
        color: {
            if(Window.active){
                return FluTheme.frameActiveColor
            }
            return FluTheme.frameColor
        }
        MouseArea{
            id:control_mouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                d.toggle()
            }
        }
        FluLoader {
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: btn_toggle.left
            }
            sourceComponent: control.headerDelegate
        }
        FluIconButton{
            id: btn_toggle
            anchors{
                verticalCenter: parent.verticalCenter
                right: parent.right
                rightMargin: 15
            }
            color:{
                if(control_mouse.containsMouse || hovered){
                    return FluTheme.dark ? Qt.rgba(73/255,73/255,73/255,1) : Qt.rgba(245/255,245/255,245/255,1)
                }
                return FluTheme.dark ? Qt.rgba(0,0,0,0) : Qt.rgba(0,0,0,0)
            }
            onClicked: {
                d.toggle()
            }
            contentItem: FluIcon{
                rotation: expand?0:180
                iconSource:FluentIcons.ChevronUp
                iconSize: 15
                Behavior on rotation {
                    enabled: FluTheme.animationEnabled
                    NumberAnimation{
                        duration: 167
                        easing.type: Easing.OutCubic
                    }
                }
            }
        }
    }
    Item{
        id:layout_container
        anchors{
            top: layout_header.bottom
            topMargin: -1
            left: layout_header.left
        }
        visible: contentHeight+container.anchors.topMargin !== 0
        height: contentHeight+container.anchors.topMargin
        width: parent.width
        z:-999
        clip: true
        Rectangle{
            id:container
            anchors.fill: parent
            radius: 4
            clip: true
            color: {
                if(Window.active){
                    return FluTheme.frameActiveColor
                }
                return FluTheme.frameColor
            }
            border.color: FluTheme.dividerColor
            anchors.topMargin: -contentHeight
            states: [
                State{
                    name:"expand"
                    when: control.expand
                    PropertyChanges {
                        target: container
                        anchors.topMargin:0
                    }
                },
                State{
                    name:"collapsed"
                    when: !control.expand
                    PropertyChanges {
                        target: container
                        anchors.topMargin:-contentHeight
                    }
                }
            ]
            transitions: [
                Transition {
                    to:"expand"
                    NumberAnimation {
                        properties: "anchors.topMargin"
                        duration: FluTheme.animationEnabled && d.flag ? 167 : 0
                        easing.type: Easing.OutCubic
                    }
                },
                Transition {
                    to:"collapsed"
                    NumberAnimation {
                        properties: "anchors.topMargin"
                        duration: FluTheme.animationEnabled && d.flag ? 167 : 0
                        easing.type: Easing.OutCubic
                    }
                }
            ]
        }
    }
}
