//
//  ContentView.swift
//  TDStepSequencer
//
//  Created by Beniamin on 12.02.22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var sequencerViewModel = SequencerViewModel()
    @State var playSound = false
    @State var selectedPitch: Float? = nil
    @State private var bpm = 120
    @State var showSequencesList = false
    let thirdOctave = Octave(octaveNumber: 3)
    @State var selectedRate: SequencerRate = .eight
    @State var selectedWaveform: Oscillator.Waveform = .sine
    @State var selectedEntry: [Float] = []
    typealias Pitch = SoundEngine.Pitch
    typealias SequencerRate = SequencerViewModel.SequencerRate
    
    var body: some View {
        NavigationView {
            VStack {
                Stepper(UtilStrings.bpm +  ": \(bpm)", value: $bpm, in: 20...200)
                Picker(selection: $selectedWaveform, label: Text("Rate")) {
                    ForEach(Oscillator.Waveform.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                Button(action: {
                    sequencerViewModel.generateARandomTenNotesSequence()
                    selectedEntry = []
                }, label: {
                    Text(UtilStrings.playARandomSequenceOfNotes)
                })
                
                Button(action: {
                    sequencerViewModel.playLoadedSequence(sequence: selectedEntry)
                }, label: {
                    Text("Play loaded sequence").foregroundColor(selectedEntry.count > 0 ? .blue : .gray)
                })
                
                Picker(selection: $selectedRate, label: Text("Rate")) {
                    ForEach(SequencerRate.allCases, id: \.self) {
                        Text($0.description)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Button(action: { sequencerViewModel.storeSequence() }, label: {
                    Text("Save the sequence")
                })
                Button(action: { sequencerViewModel.printStoredSequence()}, label: {
                    Text("Print the stored sequence")
                })
                
                NavigationLink("", isActive: $showSequencesList) {
                    StoredSequencesView(showView: $showSequencesList, selectedEntry: $selectedEntry,  notesSequenceDictionary: $sequencerViewModel.notesSequenceDictionary)
                }
                if sequencerViewModel.notesSequenceDictionary.count > 0 {
                    Button(action: {
                        showSequencesList = true
                    }, label: {
                        Text("show list")
                    })
                } else {
                    Text("show list")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 16)
            .onChange(of: selectedWaveform, perform: {
                newWaveform in
                sequencerViewModel.setWaveformTo(waveform: newWaveform)
            })
            .onChange(of: selectedRate, perform: {
                newRate in
                sequencerViewModel.setRate(rate: newRate)
            }).onChange(of: bpm, perform: {
                newBPM in
                sequencerViewModel.setBpm(bpm: newBPM)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
