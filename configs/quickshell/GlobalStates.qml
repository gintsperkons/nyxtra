import QtQuick
import Quickshell
pragma Singleton

QtObject {
    id: root

    property bool barShow: true

    property QtObject route: QtObject {
        id: route

        property var stack: []

        property string current:
            stack.length > 0 ? stack[stack.length - 1] : ""
        


        function push(r) {
            stack = stack.concat(r)   // IMPORTANT: reassign
        }

        function pop() {
            if (stack.length > 0)
                stack = stack.slice(0, stack.length - 1)
        }

        function reset(r) {
            stack = r ? [r] : []
        }

        function is(r) {
            return current === r
        }

        function clear() {
            stack = []
        }

        function length() {
            return stack.length
        }

        function isAtIdx(r,idx) {
            return stack.length > idx && stack[idx] === r
        }


        function contains(r) {
            return stack.includes(r)
        }

        function canGoBack() {
            return stack.length > 1
        }
    }
}
