import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Greetd

ShellRoot {
    FloatingWindow {
        id: window

        color: "#000000"

        property string password: ""
        property string status: ""

        property int fontSize: Math.max(16, Math.round(height / 45))

        function login() {
            if (userField.text === "" || passwordField.text === "")
                return;

            password = passwordField.text;
            status = "";
            if (Greetd.state !== GreetdState.Inactive)
                Greetd.cancelSession();
            Greetd.createSession(userField.text);
        }

        Connections {
            target: Greetd

            function onAuthMessage(message, error, responseRequired, echoResponse) {
                if (!responseRequired) {
                    window.status = message;
                    return;
                }

                if (echoResponse || window.password === "") {
                    window.password = "";
                    window.status = message !== "" ? "Unsupported login prompt: " + message : "Unsupported login prompt";
                    passwordField.text = "";
                    Greetd.cancelSession();
                    return;
                }

                Greetd.respond(window.password);
                window.password = "";
            }

            function onAuthFailure(message) {
                window.status = message !== "" ? message : "Login failed";
                passwordField.text = "";
                passwordField.forceActiveFocus();
            }

            function onReadyToLaunch() {
                Greetd.launch(["systemd-cat --identifier=hyprland start-hyprland"]);
            }

            function onError(error) {
                window.password = "";
                window.status = error;
                passwordField.text = "";
                passwordField.forceActiveFocus();
            }
        }

        ColumnLayout {
            anchors.centerIn: parent
            width: window.fontSize * 18
            spacing: window.fontSize

            TextField {
                id: userField

                Layout.fillWidth: true
                text: Quickshell.env("MUEN_USER") ?? ""
                placeholderText: "Username"
                font.family: "Monospace"
                font.pixelSize: window.fontSize
                color: "#d0d0d0"
                background: Rectangle {
                    color: "#000000"
                    border.color: userField.activeFocus ? "#d0d0d0" : "#303030"
                    border.width: 2
                }
                onAccepted: passwordField.forceActiveFocus()
            }

            TextField {
                id: passwordField

                Layout.fillWidth: true
                echoMode: TextInput.Password
                placeholderText: "Password"
                focus: true
                font.family: "Monospace"
                font.pixelSize: window.fontSize
                color: "#d0d0d0"
                background: Rectangle {
                    color: "#000000"
                    border.color: passwordField.activeFocus ? "#d0d0d0" : "#303030"
                    border.width: 2
                }
                onAccepted: window.login()
            }

            Text {
                Layout.fillWidth: true
                text: Greetd.available ? window.status : "greetd is not running"
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.Wrap
                font.family: "Monospace"
                font.pixelSize: Math.round(window.fontSize * 0.7)
                color: "#cc3333"
            }
        }
    }
}
