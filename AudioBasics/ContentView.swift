//
//  ContentView.swift
//  AudioBasics
//
//  Created by Beniamin on 12.02.22.
//

import SwiftUI

struct ContentView: View {
    @State var playSound = false
    @State var selectedPitch: Pitch? = nil
    typealias Pitch = SoundEngine.Pitch
    
    var body: some View {
        HStack {
            ForEach(Pitch.allCases, content: {
                pitch in
                pitchButton(pitch: pitch)
            })
        }
    }
    
    func pitchButton(pitch: Pitch) -> some View {
        
        let pitchDictionary: [Pitch : Float] = [Pitch.C1 : 220, Pitch.C2 : 440, Pitch.C3 : 880]
        
        return Button(action: {
            selectedPitch = pitch
            playSound.toggle()
            SoundEngine.shared.volume = playSound ? 0.5 : 0.0
            SoundEngine.shared.frequency = pitchDictionary[pitch]!
        }, label: {
            if playSound {
                Text(selectedPitch == pitch ? "Stop \(pitch.rawValue)" : "Play \(pitch.rawValue)")
            } else {
                Text("Play \(pitch.rawValue)")
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
