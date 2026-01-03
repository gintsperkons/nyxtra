
import qs
import qs.services
import qs.services.models
import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
    

Scope {
  id: launcherRoot
  property real wheelAccumulator: 0 
  property var itemList: []
  property int selected: 0
  property var menuList: [
          {
          name: "Applications",
          type: "menu",
          persist: true,
          execute: () => {
            GlobalStates.route.push(Enums.route.applicationsMenu);
          }
        },
        {
          name: "Power",
          type: "menu",
          persist: true,
          execute: () => {
            GlobalStates.route.push(Enums.route.powerMenu);
          }
        },
        {
          name: "Settings",
          type: "menu",
          persist: true,
          execute: () => {
            GlobalStates.route.push(Enums.route.settings);
          }
        }
  ]



  Loader {
    id: loader   
    active: GlobalStates.route.contains(Enums.route.launcher) 
    
    sourceComponent:PanelWindow {
      id: launcher
      color: "transparent"
      WlrLayershell.layer: WlrLayer.Overlay
      implicitWidth: 800
      implicitHeight:600

      readonly property HyprlandMonitor monitor: Hyprland.monitorFor(launcher.screen)
      property bool monitorIsFocused: (Hyprland.focusedMonitor?.id == monitor?.id)

      WlrLayershell.namespace: "quickshell:launcher"

      Rectangle {
        id: bg
        anchors.fill: parent
        color: Config.launcher.backgroundColor
        border.color: Config.launcher.borderColor 
        border.width: 1
        radius: 10
        focus: false
        TextField {
          id: search
          focus: true
          color: Config.launcher.textColor
          background: Rectangle {  
            color:  Config.launcher.backgroundColor 
            radius: 6          
            border.color: Config.launcher.borderColor 
          }
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.margins: 0
          padding: 4
          font.pixelSize: 20
          
          onTextChanged: {
            launcherRoot.itemList = []
            launcherRoot.itemList = [
              ...Applications.search(search.text),
              ... PowerMenuItems.search(search.text)
            ].slice()
            launcherRoot.selected = 0
          }
            
          Keys.onPressed: (event) => {
            if (event.key === Qt.Key_Escape) {
                GlobalStates.route.pop();
            } else if (event.key === Qt.Key_Down){
              if (launcherRoot.selected < itemList.length - 1)
              {
                launcherRoot.selected += 1
                selector.hoverY = -1
                elementList.positionViewAtIndex(launcherRoot.selected, ListView.Beginning)
              }
            } else if (event.key === Qt.Key_Up){
              if (launcherRoot.selected > 0)
              {
                launcherRoot.selected -= 1
                selector.hoverY = -1
                elementList.positionViewAtIndex(launcherRoot.selected, ListView.Beginning)
              }
            } else if (event.key === Qt.Key_Return){
              if (itemList.length > launcherRoot.selected){
                if (itemList[launcherRoot.selected].type == "application")
                  ApplicationModel.incrementUsageCount(itemList[launcherRoot.selected].name)
                itemList[launcherRoot.selected].execute()
                if (itemList[launcherRoot.selected].persist) GlobalStates.route.reset()
              }
            }
          }
        }
        Rectangle {
          property real hoverY: -1
          id:selector
          focus: false
          anchors.left: parent.left
          anchors.right: parent.right
          implicitHeight:32
          color: Config.launcher.cursorColor  
          y: hoverY >= 0 ? hoverY : (selected * 36) + 32 - elementList.contentY
          border.color: Config.launcher.borderColor 
          border.width: 1
        }
        ListView {
          id: elementList
          focus: false
          anchors.top: search.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.bottom: parent.bottom
          clip: true
          interactive: false
          spacing: 4
          model:itemList

          delegate: Row {
            height: 32
            focus: false
            enabled: false
            leftPadding: 10
            Image {
              id: appIcon
              anchors.verticalCenter: parent.verticalCenter
              width: 32
              height: 32
              source: modelData.icon
            }

            Text {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              focus: false
              text: modelData.name
              font.pixelSize: 14
              color: Config.launcher.textColor
            }

            Text {
              anchors.verticalCenter: parent.verticalCenter
              leftPadding: 10
              focus: false
              text: modelData.categories.join(", ")
              font.pixelSize: 14
              color: Config.launcher.textColorSecondary
            }
          }
        }
        MouseArea {
          anchors.fill: parent
          hoverEnabled: true
          propagateComposedEvents: true   // allow events to continue to children
          acceptedButtons: Qt.AllButtons
            onPositionChanged: {
              // Compute relative hover Y
              var relativeY = mouse.y - elementList.y
              // Include scrolled content offset
              var totalY = relativeY + elementList.contentY
              // Compute hover position for the selector
              selector.hoverY = Math.floor(totalY / 36) * 36 - elementList.contentY + 32
              var idx = Math.floor(totalY / 36)  // 32 px height + 4 px spacing

              if (idx >= 0 && idx < elementList.count) {
                launcherRoot.selected = idx
              }
            }

          onWheel: {
            wheelAccumulator += wheel.angleDelta.y / 120.0  // typical mouse wheel step is 120
            // Only move selection when accumulated delta passes ±1
            if (wheelAccumulator >= 1) {
              selector.hoverY = -1
              launcherRoot.selected = Math.min(launcherRoot.selected + 1, elementList.count - 1)
              wheelAccumulator -= 1
              elementList.positionViewAtIndex(launcherRoot.selected, ListView.Beginning)

            } else if (wheelAccumulator <= -1) {
              selector.hoverY = -1
              launcherRoot.selected = Math.max(launcherRoot.selected - 1, 0)
              wheelAccumulator += 1
              elementList.positionViewAtIndex(launcherRoot.selected, ListView.Beginning)
            }
            wheel.accepted = true
          }

          onClicked: {
            // Y relative to the top of the ListView
            var relativeY = mouse.y - elementList.y

            // Include scrolled content offset
            var totalY = relativeY + elementList.contentY

            // Compute the index
            var idx = Math.floor(totalY / 36) // 32 px height + 4 px spacing

            if (idx >= 0 && idx < elementList.count) {
              console.log("Clicked item:", idx, "Name:", launcherRoot.itemList[idx].name)

              // Update selected index
              launcherRoot.selected = idx

              // Scroll ListView to show the selected item
              elementList.positionViewAtIndex(idx, ListView.Beginning)

              // Execute application if desired
              if (itemList[launcherRoot.selected].type == "application")
                ApplicationModel.incrementUsageCount(launcherRoot.itemList[idx].name)
              launcherRoot.itemList[idx].execute()

              // // Close launcher
              // launcherRoot.close()
            }
          }
        }
      }

  
  
      HyprlandFocusGrab { // Click outside to close
        id: grab
        windows: [ launcher ]
        active: loader.active
        onCleared: () => {
          // if (!active) launcherRoot.close;
          search.text = ""
        }
      }
    }
  }

  Component.onCompleted: {
          itemList = [
            ...Applications.search(),
            ...PowerMenuItems.search()
          ].slice(); 
  }
  Connections {
    target: GlobalStates.route

    function onCurrentChanged() {
      console.log("route changed",GlobalStates.route.stack)
      console.log("route changed",GlobalStates.route.length())
      if(!GlobalStates.route.isAtIdx(Enums.route.launcher,0)) return;
      if(GlobalStates.route.length() <=1){
        itemList = [
          ...menuList
        ].slice(); 
        return;
      }
      if(GlobalStates.route.length() <=2) {
        console.log("second menu")
        if (GlobalStates.route.isAtIdx(Enums.route.applicationsMenu,1)){
          itemList = [
            ...Applications.search()
          ].slice(); 
          return;
        }
        if (GlobalStates.route.isAtIdx(Enums.route.powerMenu,1)){
          itemList = [
            ...PowerMenuItems.search()
          ].slice(); 
          return;
        }
        console.log("second menu none")
        return;

      }


      console.log("route changed end",GlobalStates.route.stack)
    }
  }



  

}