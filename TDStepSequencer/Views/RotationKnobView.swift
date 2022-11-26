//
//  RotationKnobView.swift
//  TDStepSequencer
//
//  Created by Beniamin on 23.11.22.
//  based on https://stackoverflow.com/questions/67258304/make-finite-circleslider-swiftui but adapted for discrete values as well as a knob design.

import SwiftUI
import GLKit

struct RotationKnobView: View {
    
    //MARK: - Internal State
    @State private var progress: Double = 0
    @State private var angle: Double = 0
    @State private var currentQuadrant: Quadrant = .one
    @State private var upcomingQuadrant: Quadrant = .one
    @Binding var currentChoice: Int
    
    @EnvironmentObject var sequencerViewModel: SequencerViewModel
    
    var knobType: KnobType
    
    enum KnobType {
        case bpm
        case waveform
        case rate
    }
    
    //MARK: - Configurable properties
    var lineThickness:LineThickness = .max
    var indicatorDiameter = 40.0 //adapt size of the knob
    var lineWidth:Double {
        return indicatorDiameter * lineThickness.rawValue
    }
    var circleSizeMultiplier = 1.5 //adapt size of the inner circle
    var scaledCircleSize: Double {
        let manualScaling = indicatorDiameter * Double(circleSizeMultiplier)
        let boundingScaling = UIScreen.main.bounds.width - 100
        return min(manualScaling, boundingScaling)
    }
    var numberOfChoices: Int
    
    var chunks: [[Int]] {
        let startAngle = 1
        let endAngle = 361
        let fullAngles = Array(startAngle..<endAngle)
        return fullAngles.chunked(into: (endAngle - startAngle) / self.numberOfChoices)
    }
    
    ///A forced size for the dial specified by the caller
    var dialSize: Double?
    
    var intendedDialSize: Double {
       dialSize ?? scaledCircleSize
    }
    
    var canRotateLessThan0 = true
    var canRotateMoreThan360 = true
    var knobDescription: String
    
    //MARK: - View
    var body: some View {
        VStack {
            ZStack {
                dialOutline
                angleIndicator
                innerBackground
                valueIndicator
            }.padding(.bottom, 16)
            knobDescriptionView
        }
    }
    
    var waveformToShow: UIImage {
        switch sequencerViewModel.currentWaveform {
        case .sine:
            return UIImage(named: "sine-wave")!
        case .saw:
            return UIImage(named: "sawtooth-wave")!
        case .square:
            return UIImage(named: "square-wave")!
        }
    }
    
    var valueIndicator: AnyView {
        switch knobType {
        case .bpm:
            return AnyView(
                Text(sequencerViewModel.bpm.description)
                    .foregroundColor(.white)
                    .bold()
            )
        case .waveform:
            return AnyView(
                Image(uiImage: waveformToShow)
                    .renderingMode(.template)
                    .foregroundColor(.white)
            )
        case .rate:
            return AnyView(
                Text(String(describing: sequencerViewModel.rate))
                    .foregroundColor(.white)
                    .bold()
            )
        }
    }
    
    var knobDescriptionView: some View {
        Text(knobDescription)
            .foregroundColor(.white)
            .bold()
            .fixedSize()
    }
    
    private func getAngleToSet(dragAngle: Int) -> Double {
        for (idx, chunk) in self.chunks.enumerated() {
            if chunk.contains(dragAngle) {
                self.currentChoice = idx
                return Double(self.chunks[idx].first!)
            }
        }
        return 0.0
    }
    
    func onDrag(value: DragGesture.Value) {
        currentQuadrant = upcomingQuadrant
        let dx = value.location.x
        let dy = value.location.y
        
        //Atan2 at the edge of the line, removing the radius of the indicator line and atan2 will give from -180 to 180
        let radians = atan2(dy - (0.5 * indicatorDiameter),
                            dx - (0.5 * indicatorDiameter))
        
        var dragAngle = Double(GLKMathRadiansToDegrees(Float(radians)))
        
        // simple technique for 0 to 360... eg = 360 - 176 = 184..
        if dragAngle < 0 {
            dragAngle = 360 + dragAngle
        }
        
        let angleToSet = getAngleToSet(dragAngle: Int(dragAngle))
        setAngleOfIndicator(to: angleToSet)
    }
}

//MARK: - Supporting Views
extension RotationKnobView {
    
    ///The gray outline for the dial. This will have a thickness of `lineWidth` and a
    ///frame that encapsulates `circleSize`
    var dialOutline: some View {
        Circle()
            .stroke(RadialGradient(gradient: Gradient(colors: [.init(uiColor: .init(rgb: 0x485461)), .init(uiColor: .init(rgb: 0x28313B))]), center: .center, startRadius: 50, endRadius: 100),
                    style: StrokeStyle(lineWidth: lineWidth,
                                       lineCap: .round,
                                       lineJoin: .round))
            .frame(width: intendedDialSize, height: intendedDialSize)
    }
    
    /// The circle representing the angle that is currently chosen. It will have a frame
    /// encapsulating `indicatorDiameter` and starts at the `angle` with 0º
    /// indicated at the top.
    var angleIndicator: some View {
        Rectangle()
            .fill(Color.orange)
            .frame(width: indicatorDiameter, height: 10)
            .offset(x: intendedDialSize / 2) //put indicator circle on the edge
            .rotationEffect(.init(degrees: angle))//modification for it to rotate angle chosen
            .gesture(DragGesture().onChanged(onDrag(value:)))
            .rotationEffect(.init(degrees: -90)) //Offset the indicator to compensate for initial SwiftUI coordinate drift
    }
    
    var innerBackground: some View {
        Circle()
            .fill(Color.init(uiColor: .init(rgb: 0x08313B)))
            .frame(width: intendedDialSize, height: intendedDialSize)
    }
}

//MARK: - Supporting Types
extension RotationKnobView {
    
    ///Supporting type to represent the sign of a number.
    ///Helps with pattern matching and exhaustive switches
    enum Sign {
        case positive, negative
        
        ///Positive is defined as >= 0.
        static func of(_ num:Double) -> Sign {
            if num >= 0 {
                return positive
            }
            else {
                return negative
            }
        }
    }
    
    ///A standardized thickness of the line drawn
    enum LineThickness:Double {
        case veryThin = 0.1,
             thin = 0.3,
             regular = 0.5,
             thick = 0.7,
             max = 1.0
    }
    
    ///Quadrants of a circle
    enum Quadrant:Int {
        case one = 1, two, three, four
    }
}

//MARK: - Supporting methods
extension RotationKnobView {
    
    ///Reveals the quadrant of a circle from an x coordinate and atan2
    func quadrant(x:Sign, atan2:Sign) -> Quadrant {
        switch (x, atan2) {
        case (.positive, .positive):
            return .one
        case (.negative, .positive):
            return .two
        case (.negative, .negative):
            return .three
        case (.positive, .negative):
            return .four
        }
    }
    
    ///Sets the angle and progress
    func setAngleOfIndicator(to angle:Double) {
        self.angle = angle
        self.progress = angle/360.0
    }
    
    ///Whether or not this dial should stop at and snap to 360º
    func shouldSnapTo360(from currentQuadrant:Quadrant,
                         to upcomingQuadrant:Quadrant) -> Bool {
        !canRotateMoreThan360 && //configuration
        currentQuadrant == .four && upcomingQuadrant == .one && // in the correct Quadrant?
        progress > 0.8 //Make sure we don't snap too soon
    }
    
    ///Whether or not this dial should stop at and snap to 0º
    func shouldSnapTo0(from currentQuadrant:Quadrant,
                       to upcomingQuadrant:Quadrant) -> Bool {
        !canRotateLessThan0 && //configuration
        currentQuadrant == .one && upcomingQuadrant == .four && // in the correct Quadrant?
        progress < 0.2 //Make sure we don't snap too soon
    }
}

