// Route.qml
import QtQuick

QtObject {
    id: route

    property var stack: []

    // Current route
    property string current:
        stack.length > 0 ? stack[stack.length - 1] : ""

    // Push a new route
    function push(r) {
        stack = stack.concat(r)   // reassign for reactivity
    }

    // Pop the last route
    function pop() {
        if (stack.length > 0)
            stack = stack.slice(0, stack.length - 1)
    }

    // Reset stack
    function reset(r) {
        stack = r ? [r] : []
    }

    // Check current
    function is(r) {
        return current === r
    }

    // Clear stack
    function clear() {
        stack = []
    }

    // Length
    function length() {
        return stack.length
    }

    // Check specific index
    function isAtIdx(r, idx) {
        return stack.length > idx && stack[idx] === r
    }

    // Contains
    function contains(r) {
        return stack.includes(r)
    }

    // Can go back
    function canGoBack() {
        return stack.length > 1
    }
}
