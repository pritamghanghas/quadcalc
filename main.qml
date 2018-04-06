import QtQuick 2.9
import QtQuick.Controls 2.2

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Scroll")

    property string batteryConfigStr : "max battery config is "
    property string hoverTimeStr : "hover time is "
    property string maxAvailableCurrentStr : "max available current is "
    property string hoverCurrentStr : "hover current "


    ScrollView {
        anchors.fill: parent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: 20

        Grid {
            anchors.fill: parent;
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalItemAlignment: Grid.AlignLeft

            columns: 2
            spacing: 10


            Label {
                id: quadWeight
                text: 'Quad Weight without battery (gm): '
            }
            TextField {
                id: quadWieghtInput
                text: "0"
                validator: IntValidator { bottom: 100; top: 10000 }
                focus: true
                cursorVisible: true
            }


            Label {
                id: frame
                text: 'Frame configuration in use'
            }


            ComboBox {
                id: frameConfig
                model: ListModel {
                    id: frameModel
                    ListElement { text: "x4"; motors: 4; efficiencyFactor: 1.0 }
                    ListElement { text: "x8"; motors: 8; efficiencyFactor: 0.9 }
                }
                textRole: "text"
            }



            Label {
                id: motor
                text: 'motor type to use'
            }


            ComboBox {
                id: motorType
                width: 300
                model: ListModel {
                    id: motorModel
                    ListElement { text: "3s sunnysky a2212-1 60%T"; weight: 50; efficiency: 6.5; thrust: 400; cells: 3 }
                    ListElement { text: "4s sunnysky V2806 50%T"; weight: 58; efficiency: 9.5; thrust: 400; cells: 4 }
                    ListElement { text: "3s sunnysky V2806 60%T"; weight: 58; efficiency: 10; thrust: 400; cells: 3 }
                    ListElement { text: "4s TMotor MN4008 50%T"; weight: 100; efficiency: 13; thrust: 600; cells: 4 }
                }
                textRole: "text"
            }



            Label {
                id: battery
                text: "li-ion battery to use"
            }

            ComboBox {
                id: batteryType
                model: ListModel {
                    id: batteryModel
                    ListElement { text: "NCR18650B"; capacity: 3400; usefull_capacity: 2800; max_current: 6; weight: 55 } //weight is inlcuding overhead of pack making
                    ListElement { text: "NCR18650GA"; capacity: 2800; usefull_capacity: 2500; max_current: 10; weight: 55 }
                    ListElement { text: "NCR20700B"; capacity: 4250; usefull_capacity: 3900; max_current: 15; weight: 65 }
                    ListElement { text: "NCR20700A"; capacity: 3300; usefull_capacity: 2800; max_current: 30; weight: 65  }
                }
                textRole: "text"
            }


            CheckBox {
                id: capPlanning
                text: "plan on max battery current"
                checked: true
            }

            Label {
                id: dummy
                text: " "
            }

            Label {
                id: batteryConfig
                text: batteryConfigStr
            }

            Label {
                id: batteryConfig1
                text: " "
            }



            Label {
                id: hovertime
                text: hoverTimeStr
            }

            Label {
                id: hovertime1
                text: " "
            }

            Label {
                id: maxAvaialbleCurrent
                text: maxAvailableCurrentStr
            }

            Label {
                id: maxAvaialbleCurrent1
                text: " "
            }

            Label {
                id: hoverCurrent
                text: hoverCurrentStr
            }

            Label {
                id: hoverCurrent1
                text: " "
            }

            Button {
                text: "calculate"
                onClicked: {
                    var currentMotor = motorModel.get(motorType.currentIndex)
                    var currentBattery = batteryModel.get(batteryType.currentIndex)
                    var currentFrame = frameModel.get(frameConfig.currentIndex)

                    var thrustAvailable = currentMotor.thrust * currentFrame.motors * currentFrame.efficiencyFactor
                    var batteryWeightAvailable = thrustAvailable - quadWieghtInput.text
                    var numberofBatteries = batteryWeightAvailable/currentBattery.weight
                    var batteryconfiguration = Math.round(numberofBatteries/currentMotor.cells)
                    var maxAvailableCurrentBat = batteryconfiguration*currentBattery.max_current

                    batteryConfig1.text = currentMotor.cells+"s"+batteryconfiguration+"p";
                    maxAvaialbleCurrent1.text = maxAvailableCurrentBat+"A"

                    var hoverPowerBat = thrustAvailable / currentMotor.efficiency
                    var hoverCurrentBat = hoverPowerBat/(3.7*currentMotor.cells) // assumes 100% electrical efficiency

                    hoverCurrent1.text = Math.round(hoverCurrentBat) + "A"

                    var batAH = batteryconfiguration*currentBattery.usefull_capacity/1000;
                    var flightTime=batAH*60/hoverCurrentBat

                    hovertime1.text = Math.round(flightTime) + "minutes"
                }
            }

        }


    }
}
