//
//  SamplerAudioFileLoader.swift
//  AKMidiReceiver
//
//  Created by Mark Jeschke on 1/31/18.
//  Copyright © 2018 Mark Jeschke. All rights reserved.
//

import AudioKit

class SamplerAudioFileLoader: AKMIDISampler {
    
    internal func loadWavSample(filePath: String) {
        do {
            try self.loadWav("Sounds/\(filePath)")
        } catch {
            print("Could not locate the Wav file.")
        }
    }
    
    internal func loadEXS24Sample(filePath: String) {
        do {
            try self.loadEXS24("Sounds/Sampler Instruments/\(filePath)")
        } catch {
            print("Could not locate the EXS24 file.")
        }
    }

}
