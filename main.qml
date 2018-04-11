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

    // this is loss due to either manufacturer claiming too much or because
    // we cant make it empty fully for cell safety reason.
    // 2.8V per cell in lithium ion should trigger land
    property real battery_practical_capacity_factor: 0.1


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
                    // one can add more motor configs here
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
                    // capacity_det_at_max is percentage loss factor when we draw current at max
                    ListElement { text: "NCR18650B"; capacity: 3400; capacity_det_at_max: 0.15; max_current: 6; weight: 55 } //weight is inlcuding overhead of pack making
                    ListElement { text: "NCR18650GA"; capacity: 2800; capacity_det_at_max: 0.15; max_current: 10; weight: 55 }
                    ListElement { text: "NCR20700B"; capacity: 4250; capacity_det_at_max: 0.15; max_current: 15; weight: 65 }
                    ListElement { text: "NCR20700A"; capacity: 3300; capacity_det_at_max: 0.15; max_current: 30; weight: 65  }
                    ListElement { text: "SAMSUNG48G"; capacity: 4800; capacity_det_at_max: 0.15; max_current: 10; weight: 70 } // their max is 10 but cycles are reduced to about 200 at that, 500 at 5A taking middle ground
                    ListElement { text: "SAMSUNG40T"; capacity: 3900; capacity_det_at_max: 0.15; max_current: 30; weight: 70 }
                    // one can add more battery configs here
                }
                textRole: "text"
            }

            Label {
                id: cellParaLimit
                text: 'Cell parallel config limiter : '
            }

            TextField {
                id: cellParaLimit1
                text: "20"
                validator: IntValidator { bottom: 1; top: 20 }
                focus: true
                cursorVisible: true
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
                id: batteryAHlabel
                text: "pack capcity in AH: "
            }

            Label {
                id: batteryAHValue
                text: "AH"
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

            Label {
                id: auw
                text: "All up weight (gm): "
            }

            Label {
                id: auw1
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

                    // if we are limiting the number of parallel cells
                    if (batteryconfiguration > cellParaLimit1.text) {
                        batteryconfiguration = cellParaLimit1.text
                    }

                    var batteryWeightActual = Math.round(currentBattery.weight*currentMotor.cells*batteryconfiguration)

                    var availableCurrentBat = batteryconfiguration*currentBattery.max_current
                    var batAH = batteryconfiguration*currentBattery.capacity*(1-(currentBattery.capacity_det_at_max + battery_practical_capacity_factor))/1000;


                    // generally the good current that should be drawn from a battery should be half of max
                    if (!capPlanning.checked) {
                        availableCurrentBat = batteryconfiguration*currentBattery.max_current/2
                        batAH = batteryconfiguration*currentBattery.capacity*(1-battery_practical_capacity_factor)/1000;
                    }

                    batteryAHValue.text = Math.round(batAH)

                    batteryConfig1.text = currentMotor.cells+"s"+batteryconfiguration+"p";
                    maxAvaialbleCurrent1.text = availableCurrentBat+"A"

                    var hoverPowerBat = thrustAvailable / currentMotor.efficiency
                    var hoverCurrentBat = hoverPowerBat/(3.7*currentMotor.cells) // assumes 100% electrical efficiency

                    hoverCurrent1.text = Math.round(hoverCurrentBat) + "A"

                    var battery_practical_capacity

                    var flightTime=batAH*60/hoverCurrentBat

                    hovertime1.text = Math.round(flightTime) + "minutes"

                    auw1.text = parseInt(quadWieghtInput.text) + batteryWeightActual
                }
            }

        }


    }
}
