//
//  SequencerViewModel.swift
//  TDStepSequencer
//
//  Created by Beniamin on 14.02.22.
//

import Foundation

class SequencerViewModel: ObservableObject {
    @Published var noteFrequenciesToPlay: [Float] = []
    @Published var isPlaying = false
    let userDefaults = UserDefaults.standard
    var timer: Timer?
    var counter = 0
    @Published var bpm: Int = 120 //house music tempo
    @Published var rate: SequencerRate = SequencerRate.eight
    private var currentVolume: Float = 0.5
    @Published var currentWaveform: Oscillator.Waveform = .saw
        
    //example: 120 bpm means 120 quarter notes / minute -> 2 quarter notes / second -> 1 quarter note / 0.5 second. So for a rate of 1/4 and bpm of 120, we need to multiplly by 4 to get 0.5s at the end
    var sequencerTimeInterval: Double {
        return rate.rawValue * 4 * (60 / Double(bpm))
    }
    
    //note: if there is no sound, try to check the input source and make sure it is not the Soundflower / Blackhole If it is, change to the internal microphone and then rebuild the project
    func playLoadedSequence(sequence: [Float]) {
        noteFrequenciesToPlay = sequence
        self.startTimer()
    }
    
    func generateARandomTenNotesSequence() {
        let thirdOctaveFreq = Octave(octaveNumber: 3).getArrayOfNotesFrequencies()
        let tenRandomNotesArray = (1...10).map( {_ in Int.random(in: 0...11)} )
        noteFrequenciesToPlay = tenRandomNotesArray.map { thirdOctaveFreq[$0] }
        self.startTimer()
    }
    
    func stopPlaying() {
        self.noteFrequenciesToPlay = []
        isPlaying = false
    }
    
    //just for development purposes
    func printStoredSequence() {
        if let storedNoteFrequenciesToPlay = userDefaults.object(forKey: UtilStrings.keyStoredSequence) as? [String:[Float]] {
            print(storedNoteFrequenciesToPlay.keys)
        }
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: sequencerTimeInterval, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func setBpm(bpm: Int) {
        self.bpm = bpm
    }
    
    func setRate(rate: SequencerRate) {
        self.rate = rate
    }
    
    func setWaveformTo(waveform: Oscillator.Waveform) {
        switch waveform {
        case .sine:
            currentVolume = 0.5
            currentWaveform = .sine
            SoundEngine.shared.signal = Oscillator.sine
        case .saw:
            currentVolume = 0.15
            currentWaveform = .saw
            SoundEngine.shared.signal = Oscillator.saw
        case .square:
            currentVolume = 0.15
            currentWaveform = .square
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
            isPlaying = false
            
        }
    }
}

//DateFormatter is computationally expensive so we don't want to create it multiple times
extension DateFormatter {
    static let dateAndTime: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss E, d MMM y"
        return df
    }()
}
