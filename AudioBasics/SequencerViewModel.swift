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
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
    }

    @objc func UpdateTimer() {
        print("blabla")
        SoundEngine.shared.volume = 0.5
        if counter < noteFrequenciesToPlay.count {
            SoundEngine.shared.frequency = noteFrequenciesToPlay[counter]
            counter += 1
        } else {
            SoundEngine.shared.volume = 0.0
            timer?.invalidate()
            
        }
    }
}
