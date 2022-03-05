//
//  StoredSequencesView.swift
//  AudioBasics
//
//  Created by Beniamin on 05.03.22.
//

import Foundation
import SwiftUI

struct StoredSequencesView: View {
    @Binding var showView: Bool
    @State var selectedEntry = ""
    @Binding var notesSequenceDictionary: [String : [Float]]    
    
    var body: some View {
        VStack {
            List {
                ForEach(notesSequenceDictionary.keys.sorted(), id: \.self) { key in
                    Text(key)
                        .onTapGesture {
                            selectedEntry = key
                        }
                }.onDelete(perform: removeRows)
            }
        }.toolbar {
            EditButton()
        }
    }
    
    func removeRows(at offsets: IndexSet) {
        let sortedKeys = notesSequenceDictionary.keys.sorted()
        let index = offsets[offsets.startIndex]
        notesSequenceDictionary[sortedKeys[index]] = nil
        UserDefaults.standard.set(notesSequenceDictionary, forKey: UtilStrings.keyStoredSequence)
        if notesSequenceDictionary.count == 0 {
            showView = false
        }
    }
}

