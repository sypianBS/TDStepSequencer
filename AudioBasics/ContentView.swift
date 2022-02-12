//
//  ContentView.swift
//  AudioBasics
//
//  Created by Beniamin on 12.02.22.
//

import SwiftUI

struct ContentView: View {
    @State var playSound = false
    
    var body: some View {
        Button(action: {
            playSound.toggle()
            SoundEngine.shared.volume = playSound ? 0.5 : 0.0
        }, label: {
            Text(playSound ? "Stop playing sine" : "Play sine")
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
