//
//  StoredSequencesView.swift
//  AudioBasics
//
//  Created by Beniamin on 05.03.22.
//

import Foundation
import SwiftUI

struct StoredSequencesView: View {
    @Binding var notesSequenceDictionary: [String : [Float]]
    
    var body: some View {
        VStack {
            List {
                ForEach(notesSequenceDictionary.keys.sorted(), id: \.self) { key in
                    Text(key.description)
                }
            }
        }
    }
}

