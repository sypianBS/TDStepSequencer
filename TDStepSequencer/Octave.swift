//
//  Octave.swift
//  TDStepSequencer
//
//  Created by Beniamin on 13.02.22.
//  idea https://codepen.io/enxaneta/post/frequencies-of-musical-notes

import Foundation

class Octave {
    var octaveNumber: Int
    let numberOfSemitones: Float = 12
    let A1frequency: Float = 55 //frequency of the A1 note
    
    init(octaveNumber: Int) {
        self.octaveNumber = octaveNumber
    }
    
    var a: Float {
        A1frequency * pow(2, Float(octaveNumber) - 1) //we multiply by successive powers of 2: 1, 2, 4, 8, 16...
    }
    
    var b: Float {
        getFrequency(distanceToANote: 2)
    }
    
    var aSharp: Float {
        getFrequency(distanceToANote: 1)
    }
        
    var gSharp: Float {
        getFrequency(distanceToANote: -1)
    }
    
    var g: Float {
        getFrequency(distanceToANote: -2)
    }
    
    var fSharp: Float {
        getFrequency(distanceToANote: -3)
    }
    
    var f: Float {
        getFrequency(distanceToANote: -4)
    }
    
    var e: Float {
        getFrequency(distanceToANote: -5)
    }
    
    var dSharp: Float {
        getFrequency(distanceToANote: -6)
    }
    
    var d: Float {
        getFrequency(distanceToANote: -7)
    }
    
    var cSharp: Float {
        getFrequency(distanceToANote: -8)
    }
    
    var c: Float {
        getFrequency(distanceToANote: -9)
    }
    
    func getArrayOfNotesFrequencies() -> [Float] {
        return [a ,aSharp, b, c, cSharp, d, dSharp, e, f, fSharp, g, gSharp]
    }
    
    private func getFrequency(distanceToANote: Float) -> Float {
        return a * pow(2, distanceToANote/numberOfSemitones)
    }
}
