//
//  Octave.swift
//  AudioBasics
//
//  Created by Beniamin on 13.02.22.
//  idea https://codepen.io/enxaneta/post/frequencies-of-musical-notes

import Foundation

class Octave {
    var octaveNumber: Int
    let numberOfSemitones: Double = 12
    let A1frequency: Double = 55 //frequency of the A1 note
    
    init(octaveNumber: Int) {
        self.octaveNumber = octaveNumber
    }
    
    var a: Double {
        A1frequency * pow(2, Double(octaveNumber) - 1) //we multiply by successive powers of 2: 1, 2, 4, 8, 16...
    }
    
    var b: Double {
        getFrequency(distanceToANote: 2)
    }
    
    var aSharp: Double {
        getFrequency(distanceToANote: 1)
    }
        
    var gSharp: Double {
        getFrequency(distanceToANote: -1)
    }
    
    var g: Double {
        getFrequency(distanceToANote: -2)
    }
    
    var fSharp: Double {
        getFrequency(distanceToANote: -3)
    }
    
    var f: Double {
        getFrequency(distanceToANote: -4)
    }
    
    var e: Double {
        getFrequency(distanceToANote: -5)
    }
    
    var dSharp: Double {
        getFrequency(distanceToANote: -6)
    }
    
    var d: Double {
        getFrequency(distanceToANote: -7)
    }
    
    var cSharp: Double {
        getFrequency(distanceToANote: -8)
    }
    
    var c: Double {
        getFrequency(distanceToANote: -9)
    }
    
    func getArrayOfNotesFrequencies() -> [Double] {
        return [a ,aSharp, b, c, cSharp, d, dSharp, e, f, fSharp, g, gSharp]
    }
    
    private func getFrequency(distanceToANote: Double) -> Double {
        return a * pow(2, distanceToANote/numberOfSemitones)
    }
}
