//
//  Oscillator.swift
//  AudioBasics
//
//  Created by Beniamin on 12.02.22.
//

import Foundation

typealias Signal = (_ frequency: Float, _ time: Float) -> Float

struct Oscillator {
    
    static var amplitude: Float = 1
    
    ///sine is a periodic function of time with a period equal to (2 * pi) over b, where b is the factor that time or x is being multiplied by before being passed into the function. In our case, b is equal to (2 * pi * Oscillator.frequency). That means the period of our sine wave is (1 / Oscillator.frequency). This makes perfect sense because our frequency is in Hz or cycles per second. If there are 440 cycles per second in a sine wave, each cycle is allotted 1 / 440th of a second.
    static let sine: Signal =  { frequency, time in
        return Oscillator.amplitude * sin(2.0 * Float.pi * frequency * time) //todoben where does the formula come form ?
    }
}
