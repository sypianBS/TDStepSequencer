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
                _ in
                sequencerViewModel.setWaveformTo(waveform: newSelectedWaveform)
            })
            .onChange(of: selectedRate, perform: {
                _ in
                sequencerViewModel.setRate(rate: newSequencerdRate)
            }).onChange(of: bpm, perform: {
                newBPM in
                let adjustedBPM = newBPM + 20 //range is then 20..<200 instead of 0..<180
                sequencerViewModel.setBpm(bpm: adjustedBPM)
            }).onChange(of: selectedEntry, perform: {
                _ in
                if selectedEntry.count > 0 {
                    sequencerViewModel.playLoadedSequence(sequence: selectedEntry)
                    sequencerViewModel.isPlaying = true
                    selectedEntry = []
                }
            })
        }.environment(\.colorScheme, .dark)
    }
    var newSelectedWaveform: Oscillator.Waveform {
        switch selectedWaveform {
        case 0:
            return .saw
        case 1:
            return .square
        case 2:
            return .sine
        default:
            return .saw //should never happen
        }
    }
    
    var newSequencerdRate: SequencerRate {
        switch selectedRate {
        case 0:
            return .whole
        case 1:
            return .half
        case 2:
            return .quarter
        case 3:
            return .eight
        case 4:
            return .sixteenth
        default:
            return .sixteenth
        }
    }
    
    var playbackSettingsView: AnyView {
        return AnyView(VStack(alignment: .leading) {
            VStack(spacing: 48) {
                Text("Playback settings".uppercased())
                    .foregroundColor(.white)
                    .font(.headline)
                HStack(spacing: 80) {
                    RotationKnobView(currentChoice: $bpm, knobType: .bpm, numberOfChoices: 180, knobDescription: "BPM").environmentObject(sequencerViewModel)
                    RotationKnobView(currentChoice: $selectedRate, knobType: .rate, numberOfChoices: 5, knobDescription: "Rate").environmentObject(sequencerViewModel)
                    RotationKnobView(currentChoice: $selectedWaveform, knobType: .waveform, numberOfChoices: 3, knobDescription: "Osc").environmentObject(sequencerViewModel)
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
