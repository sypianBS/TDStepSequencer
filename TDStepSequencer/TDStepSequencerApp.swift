//
//  TDStepSequencerApp.swift
//  TDStepSequencer
//
//  Created by Beniamin on 12.02.22.
//

import SwiftUI

@main
struct TDStepSequencerApp: App {
    @StateObject var sequencerViewModel = SequencerViewModel()
    @StateObject var userSequencesViewModel = UserSequencesViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sequencerViewModel)
                .environmentObject(userSequencesViewModel)
        }
    }
}
