//
//  LoadSequenceView.swift
//  TDStepSequencer
//
//  Created by Beniamin on 24.11.22.
//

import SwiftUI

struct LoadSequenceView: View {
    @EnvironmentObject var userSequencesViewModel: UserSequencesViewModel
    @Binding var showSequencesList: Bool
    
    var body: some View {
        Button(action: {
            if userSequencesViewModel.storedSequences.count > 0 {
                showSequencesList = true
            }
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.init(uiColor: .init(rgb: 0x485461)))
                    .frame(width: 100, height: 48)
                Image(systemName: "list.dash")
                    .foregroundColor(userSequencesViewModel.storedSequences.count > 0 ? .white : .gray)
                    .font(.system(size: 24)) //assetsSize))
            }
        })
    }
}
