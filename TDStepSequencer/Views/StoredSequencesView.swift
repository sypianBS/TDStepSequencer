//
//  StoredSequencesView.swift
//  TDStepSequencer
//
//  Created by Beniamin on 05.03.22.
//

import Foundation
import SwiftUI

struct StoredSequencesView: View {
    @EnvironmentObject var userSequencesViewModel: UserSequencesViewModel
    @Binding var showView: Bool
    @Binding var selectedEntry: [Float]
    
    var body: some View {
        VStack {
            List {
                ForEach(userSequencesViewModel.storedSequences, id: \.self) { storedSequence in
                    Text(storedSequence.sequenceName)
                        .onTapGesture {
                            selectedEntry = Array(storedSequence.sequence)
                            showView = false
                        }
                }.onDelete(perform: removeRows)
            }
        }.toolbar {
            EditButton()
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        /*let sortedKeys = notesSequenceDictionary.keys.sorted()
        let index = offsets[offsets.startIndex]
        notesSequenceDictionary[sortedKeys[index]] = nil
        UserDefaults.standard.set(notesSequenceDictionary, forKey: UtilStrings.keyStoredSequence)
        if notesSequenceDictionary.count == 0 {
            showView = false
        }*/
    }
}

