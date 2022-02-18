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
    var rate: Double = SequencerRate.sixteenth.rawValue //most common rate among the step sequencers
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: rate, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func setBpm(bpm: Int) {
        self.bpm = bpm
    }
    
    func setRate(rate: SequencerRate) {
        self.rate = rate.rawValue
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
        SoundEngine.shared.volume = 0.5
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
