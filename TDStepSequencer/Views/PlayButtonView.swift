//
//  PlayButtonView.swift
//  TDStepSequencer
//
//  Created by Beniamin on 24.11.22.
//

import SwiftUI

struct PlayButtonView: View {
    @EnvironmentObject var sequencerViewModel: SequencerViewModel
    @Binding var selectedEntry: [Float]
    
    var body: some View {
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
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.init(uiColor: .init(rgb: 0x485461)))
                    .frame(width: 200, height: 48)
                Image(systemName: sequencerViewModel.isPlaying ? "playpause.fill" : "playpause")
                    .foregroundColor(.white)
                    .font(.system(size: 24)) //assetsSize))
            }
        })
    }
}
