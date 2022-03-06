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
    @State var isPlaying = false
    typealias Pitch = SoundEngine.Pitch
    typealias SequencerRate = SequencerViewModel.SequencerRate
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading) {
                    Text("Playback settings".uppercased())
                        .font(.headline)
                    VStack {
                        Stepper(UtilStrings.bpm +  ": \(bpm)", value: $bpm, in: 20...200)
                        Picker(selection: $selectedWaveform, label: Text("Rate")) {
                            ForEach(Oscillator.Waveform.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        Picker(selection: $selectedRate, label: Text("Rate")) {
                            ForEach(SequencerRate.allCases, id: \.self) {
                                Text($0.description)
                            }
                        }.pickerStyle(SegmentedPickerStyle())
                    }.padding(.horizontal, 8)
                }
                
                VStack(alignment: .leading) {
                    Text("Play, load, save".uppercased())
                        .font(.headline)
                        .padding(.bottom, 8)
                    HStack {
                        Spacer()
                        Button(action: {
                            sequencerViewModel.generateARandomTenNotesSequence()
                            selectedEntry = []
                            isPlaying = true
                        }, label: {
                            Image(systemName: isPlaying ? "playpause.fill" : "playpause")
                        })
                        
                        /*Button(action: {
                            sequencerViewModel.playLoadedSequence(sequence: selectedEntry)
                        }, label: {
                            Image(systemName: "play").foregroundColor(selectedEntry.count > 0 ? .blue : .gray)
                        })*/
                        
                        Button(action: { sequencerViewModel.storeSequence() }, label: {
                            Image(systemName: "square.and.arrow.down")
                        })
                        
                        if sequencerViewModel.notesSequenceDictionary.count > 0 {
                            Button(action: {
                                showSequencesList = true
                            }, label: {
                                Image(systemName: "list.dash")
                            })
                        } else {
                            Image(systemName: "list.dash")
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    NavigationLink("", isActive: $showSequencesList) {
                        StoredSequencesView(showView: $showSequencesList, selectedEntry: $selectedEntry,  notesSequenceDictionary: $sequencerViewModel.notesSequenceDictionary)
                    }
                   
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
