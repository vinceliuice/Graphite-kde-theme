import org.kde.breeze.components

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15 as QQC2

import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kirigami 2.20 as Kirigami

SessionManagementScreen {
    id: root
    property Item mainPasswordBox: passwordBox

    property bool showUsernamePrompt: !showUserList

    property string lastUserName
    property bool passwordFieldOutlined: config.PasswordFieldOutlined == "true"
    property bool hidePasswordRevealIcon: config.HidePasswordRevealIcon == "false"

    property bool loginScreenUiVisible: false

    //the y position that should be ensured visible when the on screen keyboard is visible
    property int visibleBoundary: mapFromItem(loginButton, 0, 0).y
    onHeightChanged: visibleBoundary = mapFromItem(loginButton, 0, 0).y + loginButton.height + Kirigami.Units.smallSpacing

    property int fontSize: parseInt(config.fontSize)

    signal loginRequest(string username, string password)

    onShowUsernamePromptChanged: {
        if (!showUsernamePrompt) {
            lastUserName = ""
        }
    }

    onUserSelected: {
        // Don't startLogin() here, because the signal is connected to the
        // Escape key as well, for which it wouldn't make sense to trigger
        // login.
        focusFirstVisibleFormControl();
    }

    QQC2.StackView.onActivating: {
        // Controls are not visible yet.
        Qt.callLater(focusFirstVisibleFormControl);
    }

    function focusFirstVisibleFormControl() {
        const nextControl = (userNameInput.visible
            ? userNameInput
            : (passwordBox.visible
                ? passwordBox
                : loginButton));
        // Using TabFocusReason, so that the loginButton gets the visual highlight.
        nextControl.forceActiveFocus(Qt.TabFocusReason);
    }

    /*
     * Login has been requested with the following username and password
     * If username field is visible, it will be taken from that, otherwise from the "name" property of the currentIndex
     */
    function startLogin() {
        const username = showUsernamePrompt ? userNameInput.text : userList.selectedUser
        const password = passwordBox.text

        footer.enabled = false
        mainStack.enabled = false
        userListComponent.userList.opacity = 0.5

        // This is partly because it looks nicer, but more importantly it
        // works round a Qt bug that can trigger if the app is closed with a
        // TextField focused.
        //
        // See https://bugreports.qt.io/browse/QTBUG-55460
        loginButton.forceActiveFocus();
        loginRequest(username, password);
    }

    PlasmaComponents3.TextField {
        id: userNameInput
        height: fontSize + 8
        padding: Kirigami.Units.mediumSpacing
        leftPadding: Kirigami.Units.mediumSpacing
        Layout.fillWidth: true
        font.pointSize: fontSize + 2
        opacity: 0.5
        text: lastUserName
        visible: showUsernamePrompt
        focus: showUsernamePrompt && !lastUserName //if there's a username prompt it gets focus first, otherwise password does
        placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Username")
        color: "black"
        placeholderTextColor: "black"
        background: Rectangle {
            radius: 100
            color: "white"
        }
        onAccepted: {
            if (root.loginScreenUiVisible) {
                passwordBox.forceActiveFocus()
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true

        PlasmaExtras.PasswordField {
            id: passwordBox
            padding: Kirigami.Units.mediumSpacing
            leftPadding: Kirigami.Units.mediumSpacing
            height: fontSize + 8 // this doesn't work
            font.pointSize: fontSize + 2
            opacity: passwordFieldOutlined ? 1.0 : 0.5
            font.family: config.Font || "Noto Sans"
            Layout.fillWidth: true

            placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Password")
            focus: !showUsernamePrompt || lastUserName

            onAccepted: {
                if (root.loginScreenUiVisible) {
                    startLogin();
                }
            }

            // style: TextField {
            color: passwordFieldOutlined ? "white" : "black"
            placeholderTextColor: passwordFieldOutlined ? "white" : "white"
            passwordCharacter: config.PasswordFieldCharacter == "" ? "●" : config.PasswordFieldCharacter
            background: Rectangle {
                radius: 100
                border.color: "white"
                border.width: 0
                color: "white"
            }

            visible: root.showUsernamePrompt || userList.currentItem.needsPassword

            Keys.onEscapePressed: {
                mainStack.currentItem.forceActiveFocus();
            }

            //if empty and left or right is pressed change selection in user switch
            //this cannot be in keys.onLeftPressed as then it doesn't reach the password box
            Keys.onPressed: event => {
                if (event.key === Qt.Key_Left && !text) {
                    userList.decrementCurrentIndex();
                    event.accepted = true
                }
                if (event.key === Qt.Key_Right && !text) {
                    userList.incrementCurrentIndex();
                    event.accepted = true
                }
            }

            Connections {
                target: sddm
                function onLoginFailed() {
                    passwordBox.selectAll()
                    passwordBox.forceActiveFocus()
                }
            }
        }

        Image {
            id: loginButton
            source: Qt.resolvedUrl("assets/login.svg")
            smooth: true
            sourceSize: Qt.size(passwordBox.height, passwordBox.height)


            MouseArea {
                anchors.fill: parent
                onClicked: startLogin();
            }
            Keys.onReturnPressed: clicked()
        }
        PropertyAnimation {
            id: showLoginButton
            target: loginButton
            properties: "opacity"
            to: 0.75
            duration: 100
        }
        PropertyAnimation {
            id: hideLoginButton
            target: loginButton
            properties: "opacity"
            to: 0
            duration: 80
        }
    }
}
