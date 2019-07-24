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
                text: 'Quad Weight without battery and wihout motors (gm): '
            }
            TextField {
                id: quadWieghtInput
                text: "0"
                validator: IntValidator { bottom: 100; top: 20000 }
                focus: true
                cursorVisible: true
            }

            Label {
                id: payloadWeight
                text: 'payload weight (gm): '
            }
            TextField {
                id: payloadWeightInput
                text: "0"
                validator: IntValidator { bottom: 100; top: 20000 }
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
                    ListElement { text: "3s sunnysky a2212-1 60%T 10' "; weight: 50; efficiency: 6.5; thrust: 400; cells: 3 }
                    ListElement { text: "3s sunnysky a2212-1 50%T 10' "; weight: 50; efficiency: 7.5; thrust: 350; cells: 3 }
                    ListElement { text: "4s sunnysky V2806 50%T 11'"; weight: 58; efficiency: 8.5; thrust: 400; cells: 4 }
                    ListElement { text: "4s sunnysky V2806 40%T 11-1255'"; weight: 58; efficiency: 9.5; thrust: 400; cells: 4 }
                    ListElement { text: "6s sunnysky V2806_400 45%T 11-1255'"; weight: 58; efficiency: 9.5; thrust: 400; cells: 6 }
                    ListElement { text: "3s sunnysky V2806 60%T 11'" ; weight: 58; efficiency: 8.5; thrust: 400; cells: 3 }
                    ListElement { text: "4s TMotor MN3510 50%T 15'"; weight: 100; efficiency: 13; thrust: 280; cells: 4 }
                    ListElement { text: "4s TMotor MN3510 65%T 15'"; weight: 100; efficiency: 12; thrust: 500; cells: 4 }
                    ListElement { text: "4s TMotor MN3510 70%T 15'"; weight: 100; efficiency: 11; thrust: 630; cells: 4 }
                    ListElement { text: "4s TMotor MN3510 75%T 15'"; weight: 100; efficiency: 11; thrust: 760; cells: 4 }
                    ListElement { text: "4s TMotor MN3510 85%T 15'"; weight: 100; efficiency: 10; thrust: 900; cells: 4 }
                    ListElement { text: "5s TMotor MN3510 60%T 15'"; weight: 100; efficiency: 12; thrust: 630; cells: 5 }
                    ListElement { text: "5s TMotor MN3510 55%T 15'"; weight: 100; efficiency: 12; thrust: 500; cells: 5 }
                    ListElement { text: "6s TMotor MN3510 50%T 15'"; weight: 100; efficiency: 11; thrust: 780; cells: 6 }
                    ListElement { text: "6s TMotor MN3510 50%T 14'"; weight: 100; efficiency: 11.5; thrust: 660; cells: 6 }
                    ListElement { text: "8s TMotor MN3510 50%T 14'"; weight: 100; efficiency: 10; thrust: 800; cells: 8 }
                    ListElement { text: "4s TMotor MN3510 75%T 15'"; weight: 100; efficiency: 11; thrust: 760; cells: 4 }
                    ListElement { text: "6s TMotor P80_340 50%T 22'"; weight: 400; efficiency: 8.0; thrust: 2800; cells: 6 }
                    ListElement { text: "12s TMotor P80_100 50%T 28'"; weight: 650; efficiency: 11; thrust: 3200; cells: 12 }
                    ListElement { text: "12s sunnysky M8_100 40%T 26"; weight: 250; efficiency: 11.5; thrust: 1750; cells: 12 }
                    ListElement { text: "12s sunnysky X6215S 50%T 22"; weight: 350; efficiency: 7; thrust: 3800; cells: 12 }
                    ListElement { text: "6s sunnysky X5212S_280 40%T 22"; weight: 260; efficiency: 10; thrust: 1500; cells: 6 }
                    ListElement { text: "6s sunnysky X5212S_280 45%T 22"; weight: 260; efficiency: 9; thrust: 1800; cells: 6 }
                    ListElement { text: "6s sunnysky X6212S_300 45%T 20"; weight: 308; efficiency: 8; thrust: 2000; cells: 6 }
                    ListElement { text: "6s Antigravity 4006 KV380 60%T 1555"; weight: 68; efficiency: 9; thrust: 1000; cells: 6 }
                    ListElement { text: "6s Antigravity 4006 KV380 50%T 1555"; weight: 68; efficiency: 10; thrust: 800; cells: 6 }
                    ListElement { text: "6s Antigravity 4006 KV380 75%T 1555"; weight: 68; efficiency:7.5; thrust: 1560; cells: 6 }
                    ListElement { text: "6s sunnysky 4004 KV400 70%T 1247"; weight: 51; efficiency: 6.5; thrust: 900; cells: 6 }

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
                    ListElement { text: "NCR18650B"; capacity: 3400; capacity_det_at_max: 0.15; max_current: 6; weight: 55; cost: 6 } //weight is inlcuding overhead of pack making, international
                    ListElement { text: "NCR18650GA"; capacity: 2800; capacity_det_at_max: 0.15; max_current: 10; weight: 55; cost: 8 }
                    ListElement { text: "NCR20700B"; capacity: 4250; capacity_det_at_max: 0.15; max_current: 15; weight: 65; cost: 10 }
                    ListElement { text: "NCR20700A"; capacity: 3300; capacity_det_at_max: 0.15; max_current: 30; weight: 65; cost: 11  }
                    ListElement { text: "SAMSUNG48G"; capacity: 4800; capacity_det_at_max: 0.15; max_current: 10; weight: 70 ; cost: 9 } // their max is 10 but cycles are reduced to about 200 at that, 500 at 5A taking middle ground
                    ListElement { text: "SAMSUNG40T"; capacity: 3900; capacity_det_at_max: 0.15; max_current: 25; weight: 70; cost: 9 }
                    ListElement { text: "SAMSUNG30T"; capacity: 3000; capacity_det_at_max: 0.15; max_current: 35; weight: 70; cost: 9 }
                    ListElement { text: "SAMSUNG25R"; capacity: 2600; capacity_det_at_max: 0.15; max_current: 20; weight: 48; cost: 8 }
                    ListElement { text: "LG HG2";     capacity: 2900; capacity_det_at_max: 0.15; max_current: 20; weight: 52; cost: 9 }
                    ListElement { text: "LG MG1";     capacity: 2800; capacity_det_at_max: 0.15; max_current: 10; weight: 49; cost: 4 }
                    ListElement { text: "LG M36";     capacity: 3300; capacity_det_at_max: 0.10; max_current: 10; weight: 55; cost: 8 }
                    ListElement { text: "IJOY 2170 40A"; capacity: 3600; capacity_det_at_max: 0.15; max_current: 24; weight: 70; cost: 17}
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
                validator: IntValidator { bottom: 1; top: 60 }
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
                id: battweight
                text: "Battery weight(gm): "
            }

            Label {
                id: battweight1
                text: " "
            }

            Label {
                id: battcost
                text: "Battery Cost Intl($): "
            }

            Label {
                id: battcost1
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

            Label {
                id: thrAt50
                text: "Thrust available (gm): "
            }

            Label {
                id: thrAt501
                text: " "
            }



            Button {
                text: "calculate"
                onClicked: {
                    var currentMotor = motorModel.get(motorType.currentIndex)
                    var currentBattery = batteryModel.get(batteryType.currentIndex)
                    var currentFrame = frameModel.get(frameConfig.currentIndex)
                    var quadWeightwithoutBattery = parseInt(quadWieghtInput.text) + parseInt(payloadWeightInput.text) + currentMotor.weight*currentFrame.motors

                    var thrustAvailable = currentMotor.thrust * currentFrame.motors * currentFrame.efficiencyFactor
                    var batteryWeightAvailable = thrustAvailable - quadWeightwithoutBattery
                    var numberofBatteries = batteryWeightAvailable/currentBattery.weight
                    var batteryconfiguration = Math.round(numberofBatteries/currentMotor.cells)

                    // if we are limiting the number of parallel cells
                    if (batteryconfiguration > cellParaLimit1.text) {
                        batteryconfiguration = cellParaLimit1.text
                    }

                    var batteryWeightActual = Math.round(currentBattery.weight*currentMotor.cells*batteryconfiguration)
                    var batteryCostActual = Math.round(currentBattery.cost*currentMotor.cells*batteryconfiguration)

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

                    battweight1.text = batteryWeightActual
                    battcost1.text = batteryCostActual

                    auw1.text = quadWeightwithoutBattery + batteryWeightActual

                    thrAt501.text = thrustAvailable
                }
            }

        }


    }
}
