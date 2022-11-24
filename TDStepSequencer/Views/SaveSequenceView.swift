//
//  SaveSequenceView.swift
//  TDStepSequencer
//
//  Created by Beniamin on 24.11.22.
//

import SwiftUI

struct SaveSequenceView: View {
    @EnvironmentObject var userSequencesViewModel: UserSequencesViewModel
    @EnvironmentObject var sequencerViewModel: SequencerViewModel
    
    var body: some View {
        Button(action: {
            userSequencesViewModel.addNewSequence(notesToStore: sequencerViewModel.noteFrequenciesToPlay)
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.init(uiColor: .init(rgb: 0x485461)))
                    .frame(width: 100, height: 48)
                Image(systemName: "square.and.arrow.down")
                    .foregroundColor(.white)
                    .font(.system(size: 24))
                    .offset(y: -3)
            }
        })
    }
}
