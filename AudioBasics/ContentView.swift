//
//  ContentView.swift
//  AudioBasics
//
//  Created by Beniamin on 12.02.22.
//

import SwiftUI

struct ContentView: View {
    @State var playSound = false
    @State var selectedPitch: Double? = nil
    let thirdOctave = Octave(octaveNumber: 3)
    typealias Pitch = SoundEngine.Pitch
    
    var body: some View {
        HStack {
            //id: \.self -> frequencies are unique
            ForEach(thirdOctave.getArrayOfNotesFrequencies(), id: \.self, content: {
                noteFrequency in
                pitchButton(noteFrequency: noteFrequency)
            })
        }
    }
    
    func pitchButton(noteFrequency: Double) -> some View {
        
        return Button(action: {
            selectedPitch = noteFrequency
            playSound.toggle()
            SoundEngine.shared.volume = playSound ? 0.5 : 0.0
            SoundEngine.shared.frequency = Float(noteFrequency)
        }, label: {
            if playSound {
//                Text(selectedPitch == pitch ? "Stop \(pitch.rawValue)" : "Play \(pitch.rawValue)")
                Text("Stop")
            } else {
//                Text("Play \(pitch.rawValue)")
                Text("Play")
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
