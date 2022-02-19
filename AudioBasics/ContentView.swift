//
//  ContentView.swift
//  AudioBasics
//
//  Created by Beniamin on 12.02.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var sequencerViewModel = SequencerViewModel()
    @State var playSound = false
    @State var selectedPitch: Float? = nil
    @State private var bpm = 120
    let thirdOctave = Octave(octaveNumber: 3)
    @State var selectedRate: SequencerRate = .sixteenth
    @State var selectedWaveform: Oscillator.Waveform = .sine
    typealias Pitch = SoundEngine.Pitch
    typealias SequencerRate = SequencerViewModel.SequencerRate
    
    var body: some View {
        VStack {
            Stepper("BPM: \(bpm)", value: $bpm, in: 20...200)
        HStack {
            //id: \.self -> frequencies are unique
            ForEach(thirdOctave.getArrayOfNotesFrequencies(), id: \.self, content: {
                noteFrequency in
                pitchButton(noteFrequency: noteFrequency)
            })
        }
        
            Picker(selection: $selectedWaveform, label: Text("Rate")) {
                ForEach(Oscillator.Waveform.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            Button(action: {
                let thirdOctaveFreq = thirdOctave.getArrayOfNotesFrequencies()
                let notesSequence: [Float] = [thirdOctaveFreq[2], thirdOctaveFreq[1], thirdOctaveFreq[4], thirdOctaveFreq[4], thirdOctaveFreq[2], thirdOctaveFreq[1], thirdOctaveFreq[2]]
                sequencerViewModel.noteFrequenciesToPlay = notesSequence
                sequencerViewModel.startTimer()
            }, label: {
                Text("Play a sequence of notes")
            })
            
            Picker(selection: $selectedRate, label: Text("Rate")) {
                ForEach(SequencerRate.allCases, id: \.self) {
                    Text($0.description)
                }
            }.pickerStyle(SegmentedPickerStyle())
        }.onChange(of: selectedWaveform, perform: {
            newWaveform in
            SoundEngine.shared.setWaveformTo(waveform: newWaveform)
        })
        .onChange(of: selectedRate, perform: {
            newRate in
            sequencerViewModel.setRate(rate: newRate)
        }).onChange(of: bpm, perform: {
            newBPM in
            sequencerViewModel.setBpm(bpm: newBPM)
        })
    }
    
    
    
    func pitchButton(noteFrequency: Float) -> some View {
        
        return Button(action: {
            selectedPitch = noteFrequency
            playSound.toggle()
            SoundEngine.shared.volume = playSound ? 0.5 : 0.0
            SoundEngine.shared.frequency = noteFrequency
        }, label: {
            if playSound {
//                Text(selectedPitch == pitch ? "Stop \(pitch.rawValue)" : "Play \(pitch.rawValue)")
                Text("Stop")
            } else {
//                Text("Play \(pitch.rawValue)")
                Text("Play")
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
