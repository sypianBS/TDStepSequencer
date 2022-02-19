//
//  Oscillator.swift
//  AudioBasics
//
//  Created by Beniamin on 12.02.22.
//  based on the https://developer.apple.com/documentation/avfaudio/audio_engine/building_a_signal_generator

import Foundation

typealias Signal = (_ frequency: Float, _ time: Float) -> Float

struct Oscillator {
    
    enum Waveform: Int {
        case sine, saw, square
    }
    
    static var amplitude: Float = 1
    
    ///sine is a periodic function of time with a period equal to (2 * pi) over b, where b is the factor that time or x is being multiplied by before being passed into the function. In our case, b is equal to (2 * pi * Oscillator.frequency). That means the period of our sine wave is (1 / Oscillator.frequency). This makes perfect sense because our frequency is in Hz or cycles per second. If there are 440 cycles per second in a sine wave, each cycle is allotted 1 / 440th of a second.
    static let sine: Signal =  { frequency, time in
        return Oscillator.amplitude * sin(2.0 * Float.pi * frequency * time) //todoben where does the formula come form ?
    }
    
    static let saw: Signal = { frequency, time in
        let period = 1.0 / frequency
        let currentTime = fmod(Double(time), Double(period))
        return Oscillator.amplitude * ((Float(currentTime) / period) * 2 - 1.0)
    }
    
    static let square: Signal = { frequency, time in
        let period = 1.0 / Double(frequency)
        let currentTime = fmod(Double(time), period)
        return ((currentTime / period) < 0.5) ? Oscillator.amplitude : -1.0 * Oscillator.amplitude
    }
}
