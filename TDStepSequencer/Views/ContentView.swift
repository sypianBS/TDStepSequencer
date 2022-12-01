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
    @EnvironmentObject var sequencerViewModel: SequencerViewModel
    @EnvironmentObject var userSequencesViewModel: UserSequencesViewModel
    @State var selectedPitch: Float? = nil
    @State var showSequencesList = false
    let assetsSize: CGFloat = 24
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                playbackSettingsView
                    .padding(.horizontal, 16)
            }
        }.environment(\.colorScheme, .dark)
    }
}

extension ContentView {
    var playbackSettingsView: AnyView {
        return AnyView(VStack(alignment: .leading) {
            VStack(spacing: 48) {
                Text("Playback settings".uppercased())
                    .foregroundColor(.white)
                    .font(.headline)
                HStack(spacing: 80) {
                    RotationKnobView(currentChoice: $sequencerViewModel.bpm, knobType: .bpm, numberOfChoices: 180, knobDescription: "BPM")
                    RotationKnobView(currentChoice: $sequencerViewModel.selectedRate, knobType: .rate, numberOfChoices: 5, knobDescription: "Rate")
                    RotationKnobView(currentChoice: $sequencerViewModel.selectedWaveform, knobType: .waveform, numberOfChoices: 3, knobDescription: "Osc")
                }
                HStack {
                    PlayButtonView(selectedEntry: $sequencerViewModel.selectedEntry)
                    LoadSequenceView(showSequencesList: $showSequencesList)
                    SaveSequenceView()
                }
                NavigationLink("", isActive: $showSequencesList) {
                    StoredSequencesView(showView: $showSequencesList, selectedEntry: $sequencerViewModel.selectedEntry)
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
