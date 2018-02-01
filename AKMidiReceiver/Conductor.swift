//
//  Conductor.swift
//  AKMidiReceiver
//
//  Created by Mark Jeschke on 1/30/18.
//  Copyright © 2018 Mark Jeschke. All rights reserved.
//

import AudioKit
import UIKit

enum MidiEventType: String {
    case
        noteNumber          = "Note Number",
        continuousControl   = "Continuous Control",
        programChange       = "Program Change"
}

class Conductor: AKMIDIListener {
    
    // Globally accessible
    static let sharedInstance = Conductor()
    
    // Set the instance variables outside of the init()
    let midi = AKMIDI()

    var demoSampler = SamplerAudioFileLoader()
    var samplerMixer = AKMixer()
    var outputMIDIMessage = ""
    var midiSignalReceived = false
    var midiTypeReceived: MidiEventType = .noteNumber
    
    init() {
        
        // Session settings
        AKSettings.bufferLength = .medium
        AKSettings.defaultToSpeaker = true
        
        // Allow audio to play while the iOS device is muted.
        AKSettings.playbackWhileMuted = true
        
        do {
            try AKSettings.setSession(category: .playAndRecord, with: [.defaultToSpeaker, .allowBluetooth, .mixWithOthers])
        } catch {
            AKLog("Could not set session category.")
        }
        
        demoSampler.loadEXS24Sample(filePath: "TX Metalimba")
        
        // If you wish to load a wav file, comment the `loadEXS24` method and uncomment this one:
//      demoSampler.loadWavSample(filePath: "Kick") // Load Kick wav file
        
        [demoSampler] >>> samplerMixer
        AudioKit.output = samplerMixer
        AudioKit.start()
        
        // MIDI Configure
        midi.createVirtualInputPort(98909, name: "MidiTrigger")
        midi.openInput()
        midi.openOutput()
        midi.addListener(self)
    }
    
    // Capture the MIDI Text within a DispatchQueue, so that it's on the main thread.
    // Otherwise, it won't display.
    func captureMIDIText() {
        let nc = NotificationCenter.default
        DispatchQueue.main.async(execute: {
            nc.post(name: NSNotification.Name(rawValue: "outputMessage"),
                    object: nil,
                    userInfo: [
                        "message": self.outputMIDIMessage,
                        "midiSignalReceived": self.midiSignalReceived,
                        "midiTypeReceived": self.midiTypeReceived
                ])
        })
    }
    
    // MARK: MIDI received
    
    // Note On Number + Velocity + MIDI Channel
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        playNote(note: noteNumber, velocity: velocity, channel: channel)
        midiTypeReceived = .noteNumber
        outputMIDIMessage = "\(midiTypeReceived.rawValue)\nChannel: \(channel+1)  noteOn: \(noteNumber)  velocity: \(velocity)"
        print(outputMIDIMessage)
        midiSignalReceived = true
        captureMIDIText()
    }
    
    // Note Off Number + Velocity + MIDI Channel
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, channel: MIDIChannel) {
        stopNote(note: noteNumber, channel: channel)
        midiTypeReceived = .noteNumber
        outputMIDIMessage = "\(midiTypeReceived.rawValue)\nChannel: \(channel+1)  noteOff: \(noteNumber)"
        print(outputMIDIMessage)
        midiSignalReceived = false
        captureMIDIText()
    }
    
    // Controller Number + Value + MIDI Channel
    func receivedMIDIController(_ controller: MIDIByte, value: MIDIByte, channel: MIDIChannel) {
        // If the controller value reaches 127 or above, then trigger the `demoSampler` note.
        // If the controller value is less, then stop the note.
        // This creates an on/off type of "momentary" MIDI messaging.
        if value >= 127 {
            playNote(note: 60, velocity: 127, channel: channel + 1)
        } else {
            stopNote(note: 60, channel: channel + 1)
        }
        midiTypeReceived = .continuousControl
        outputMIDIMessage = "\(midiTypeReceived.rawValue)\nChannel: \(channel+1)  controller: \(controller)  value: \(value)"
        midiSignalReceived = true
        captureMIDIText()
    }
    
    // Program Change Number + MIDI Channel
    func receivedMIDIProgramChange(_ program: MIDIByte, channel: MIDIChannel) {
        // Trigger the `demoSampler` note and release it after half a second (0.5), since program changes don't have a note off release.
        triggerSamplerNote(channel)
        midiTypeReceived = .programChange
        outputMIDIMessage = "\(midiTypeReceived.rawValue)\nChannel: \(channel+1)  programChange: \(program)"
        midiSignalReceived = true
        captureMIDIText()
    }
    
    func playNote(note: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        demoSampler.play(noteNumber: note, velocity: velocity, channel: channel)
    }
    
    func stopNote(note: MIDINoteNumber, channel: MIDIChannel) {
        demoSampler.stop(noteNumber: note, channel: channel)
    }
    
    func triggerSamplerNote(_ channel: MIDIChannel) {
        playNote(note: 60, velocity: 127, channel: channel + 1)
        let releaseNoteDelay = DispatchTime.now() + 0.5 // Change 0.5 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: releaseNoteDelay) {
            self.stopNote(note: 60, channel: channel + 1)
        }
    }

}
