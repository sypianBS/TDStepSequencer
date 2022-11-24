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
    @State var selectedRate = 8 // SequencerRate = .eight
    @State var selectedWaveform = 0 // Oscillator.Waveform = .saw
    @State var selectedEntry: [Float] = []
    let assetsSize: CGFloat = 24
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                playbackSettingsView
                    .padding(.horizontal, 16)
            }
            .onChange(of: selectedWaveform, perform: {
                val in
                var newWaveform: Oscillator.Waveform
                switch val {
                case 0:
                    newWaveform = .saw
                case 1:
                    newWaveform = .square
                case 2:
                    newWaveform = .sine
                default:
                    newWaveform = .saw //should never happen
                }
                sequencerViewModel.setWaveformTo(waveform: newWaveform)
            })
            .onChange(of: selectedRate, perform: {
                val in
                var newRate: SequencerRate = .eight
                switch val {
                case 0:
                    newRate = .whole
                case 1:
                    newRate = .half
                case 2:
                    newRate = .quarter
                case 3:
                    newRate = .eight
                case 4:
                    newRate = .sixteenth
                default:
                    newRate = .sixteenth
                }
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
            VStack(spacing: 48) {
                Text("Playback settings".uppercased())
                    .foregroundColor(.white)
                    .font(.headline)
                HStack(spacing: 80) {
                    RotationKnobView(currentChoice: $bpm, numberOfChoices: 180, knobDescription: "BPM")
                    RotationKnobView(currentChoice: $selectedRate, numberOfChoices: 5, knobDescription: "Wave")
                    RotationKnobView(currentChoice: $selectedWaveform, numberOfChoices: 3, knobDescription: "Rate")
                }
                HStack {
                    PlayButtonView(selectedEntry: $selectedEntry).environmentObject(sequencerViewModel)
                    LoadSequenceView(showSequencesList: $showSequencesList).environmentObject(userSequencesViewModel)
                    SaveSequenceView().environmentObject(sequencerViewModel).environmentObject(userSequencesViewModel)
                }
                NavigationLink("", isActive: $showSequencesList) {
                    StoredSequencesView(showView: $showSequencesList, selectedEntry: $selectedEntry).environmentObject(userSequencesViewModel)
                }
            }.padding(.horizontal, 8)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
