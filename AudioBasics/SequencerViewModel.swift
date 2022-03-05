//
//  SequencerViewModel.swift
//  AudioBasics
//
//  Created by Beniamin on 14.02.22.
//

import Foundation

class SequencerViewModel: ObservableObject {
    @Published var noteFrequenciesToPlay: [Float] = []
    var timer: Timer?
    var counter = 0
    var bpm: Int = 120 //house music tempo
    var rate: Double = SequencerRate.eight.rawValue //the most common rate among the step sequencers is sixteenth, but for the example purposes I set it slower
    private var currentVolume: Float = 0.5
    
    //example: 120 bpm means 120 quarter notes / minute -> 2 quarter notes / second -> 1 quarter note / 0.5 second. So for a rate of 1/4 and bpm of 120, we need to multiplly by 4 to get 0.5s at the end
    var sequencerTimeInterval: Double {
        return rate * 4 * (60 / Double(bpm))
    }
    
    func generateARandomTenNotesSequence() {
        let thirdOctaveFreq = Octave(octaveNumber: 3).getArrayOfNotesFrequencies()
        let tenRandomNotesArray = (1...10).map( {_ in Int.random(in: 0...11)} )
        noteFrequenciesToPlay = tenRandomNotesArray.map { thirdOctaveFreq[$0] }
        self.startTimer()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: sequencerTimeInterval, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func setBpm(bpm: Int) {
        self.bpm = bpm
    }
    
    func setRate(rate: SequencerRate) {
        self.rate = rate.rawValue
    }
    
    func setWaveformTo(waveform: Oscillator.Waveform) {
        switch waveform {
        case .sine:
            currentVolume = 0.5
            SoundEngine.shared.signal = Oscillator.sine
        case .saw:
            currentVolume = 0.15
            SoundEngine.shared.signal = Oscillator.saw
        case .square:
            currentVolume = 0.15
            SoundEngine.shared.signal = Oscillator.square
        }
    }

    
    enum SequencerRate: Double, CaseIterable, CustomStringConvertible {
        case whole = 1
        case half = 0.5
        case quarter = 0.25
        case eight = 0.125
        case sixteenth = 0.0625
        
        var description: String {
            switch self {
            case .whole:
                return "1"
            case .half:
                return "1/2"
            case .quarter:
                return "1/4"
            case .eight:
                return "1/8"
            case .sixteenth:
                return "1/16"
            }
        }
    }

    @objc func updateTimer() {
        SoundEngine.shared.volume = currentVolume
        if counter < noteFrequenciesToPlay.count {
            SoundEngine.shared.frequency = noteFrequenciesToPlay[counter]
            counter += 1
        } else {
            SoundEngine.shared.volume = 0.0
            timer?.invalidate()
            counter = 0
            
        }
    }
}
