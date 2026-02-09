import Quickshell // for PanelWindow
import QtQuick // for Text
import Quickshell.Io

PanelWindow {
  	anchors {
    	top: true
    	left: true
    	right: true
  	}

	implicitHeight: 50
	color: "#FF000000"	
	Rectangle {
		id: bar
		anchors.fill: parent
		anchors.leftMargin: 10
		anchors.rightMargin: 10
		//color: "#4Fda4540";
		radius: 10
		color: "transparent";

		border.color: "#FFda4540"
		border.width: 1;

	//	x1: 0; y1: 0
	//	x2: width; y2: height
	//	gradient: Gradient {
	//		GradientStop {position: 0.0; color: "#ffda4540"}
	//		GradientStop {position: 1.0; color: "#0faaaaaa"}
	//	}
	
		Item {
			anchors.fill: parent
			clip: true
				ShaderEffect {
					anchors.fill: parent			

					property color leftColor: "#8fff3030"
					property color rightColor: "#8f112c31"//"#8f1a4249"
					property vector2d resolution: Qt.vector2d(width, height)
					fragmentShader: "shaders/grad.frag.qsb"
				}
		}		
	}

	Item {
		id: clockComp
		anchors.centerIn: parent
		property string timeText: "00:00"

		Timer {
			interval: 1000
			running: true
			repeat: true
			triggeredOnStart: true
			onTriggered: {
				const d = new Date();
				let h = d.getHours();
				
				const ampm = h >= 12 ? "PM" : "AM"
				h = h % 12
				if (h == 0) h = 12;
				const mm = String(d.getMinutes()).padStart(2, "0");
				const ss = String(d.getSeconds()).padStart(2, "0");
				clockComp.timeText = `${h}:${mm}:${ss} ${ampm}`
			}
		}

		Rectangle {
			id: clockCard
			anchors.centerIn: parent
			width: 150
			height: bar.height * 0.75

			radius: 4
			color: "#dF4b191c"

			border.color: "#FFda4540"
			border.width: 1

			FontLoader {
				id: rajdhani
				source: "fonts/Rajdhani Semibold.ttf"
			}

			Text {
				id: clockText
				anchors.centerIn: parent
				text: clockComp.timeText

				font.family: rajdhani.name
				font.pixelSize: 25
				color: "#ff5cebf4"
			}

			ShaderEffectSource {
				id: textSource
				sourceItem: clockText
				live: true
				hideSource: true
				smooth: true
			}

		ShaderEffect {
			id: clockFx

			// Fill the entire clockCard to give maximum space for ghosts
			anchors.fill: parent
			
			// This is sampled2D source in frag shader
			property variant source: textSource
			property vector2d resolution: Qt.vector2d(width, height);
			property vector2d textSize: Qt.vector2d(clockText.width, clockText.height);
			
			// Calculate padding dynamically based on text position within the card
			property vector2d padding: Qt.vector2d(
				(clockCard.width - clockText.width) / 2,
				(clockCard.height - clockText.height) / 2
			)

			property vector4d trailColor: Qt.vector4d(0.3608, 0.9216, 0.9569, 1.0)
			property vector2d stepPx: Qt.vector2d(10.0,-3.0);
       			property real decay: 0.2
			
			fragmentShader: "shaders/clock.frag.qsb"
		}
		}
	}	

}
