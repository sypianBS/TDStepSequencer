//
//  ContentView.swift
//  TDStepSequencer
//
//  Created by Beniamin on 12.02.22.
//

import SwiftUI

struct ContentView: View {
    typealias Pitch = SoundEngine.Pitch
    typealias SequencerRate = SequencerViewModel.SequencerRate
    @StateObject var sequencerViewModel = SequencerViewModel()
    @StateObject var userSequencesViewModel = UserSequencesViewModel()
    @State var selectedPitch: Float? = nil
    @State private var bpm = 120
    @State var showSequencesList = false
    @State var selectedRate: SequencerRate = .eight
    @State var selectedWaveform: Oscillator.Waveform = .saw
    @State var selectedEntry: [Float] = []
    let assetsSize: CGFloat = 24
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                playbackSettingsView
                playLoadSaveView
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
            }).onChange(of: selectedEntry, perform: {
                _ in
                if selectedEntry.count > 0 {
                    sequencerViewModel.playLoadedSequence(sequence: selectedEntry)
                    sequencerViewModel.isPlaying = true
                    selectedEntry = []
                }
            })
        }
    }
    
    var playbackSettingsView: AnyView {
        return AnyView(VStack(alignment: .leading) {
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
        })
    }
    
    var playLoadSaveView: AnyView {
        return AnyView(VStack(alignment: .leading) {
            Text("Play, load, save".uppercased())
                .font(.headline)
                .padding(.bottom, 8)
            HStack(spacing: 16) {
                Spacer()
                Button(action: {
                    if !sequencerViewModel.isPlaying {
                        selectedEntry = []
                        sequencerViewModel.generateARandomTenNotesSequence()
                        sequencerViewModel.isPlaying = true
                    } else {
                        sequencerViewModel.stopPlaying()
                        selectedEntry = []
                        sequencerViewModel.isPlaying = false
                    }
                }, label: {
                    Image(systemName: sequencerViewModel.isPlaying ? "playpause.fill" : "playpause")
                        .font(.system(size: assetsSize))
                })
                
                if userSequencesViewModel.storedSequences.count > 0 {
                    Button(action: {
                        showSequencesList = true
                    }, label: {
                        Image(systemName: "list.dash")
                            .font(.system(size: assetsSize))
                    })
                } else {
                    Image(systemName: "list.dash")
                        .font(.system(size: assetsSize))
                        .foregroundColor(.gray)
                }
                
                Button(action: {
                    userSequencesViewModel.addNewSequence(notesToStore: sequencerViewModel.noteFrequenciesToPlay)
                }, label: {
                    Image(systemName: "square.and.arrow.down")
                        .font(.system(size: assetsSize))
                        .offset(y: -3)
                })
                Spacer()
            }
            NavigationLink("", isActive: $showSequencesList) {
                StoredSequencesView(showView: $showSequencesList, selectedEntry: $selectedEntry).environmentObject(userSequencesViewModel)
            }
           
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
