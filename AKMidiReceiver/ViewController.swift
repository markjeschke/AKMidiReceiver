//
//  ViewController.swift
//  AKMidiReceiver
//
//  Created by Mark Jeschke on 1/30/18.
//  Copyright © 2018 Mark Jeschke. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    
    @IBOutlet weak var outputTextLabel: UILabel!
    
    var conductor = Conductor.sharedInstance
    var midiSignalReceived = false
    var midiTypeReceived: MidiEventType = .noteNumber
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:NSNotification.Name(rawValue: "outputMessage"), object:nil, queue:nil, using:catchNotification)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        flashBackgroundColor()
        midiSignalReceived = false
        self.outputTextLabel.text = "Listening for MIDI events..."
    }
    
    @objc func catchNotification(notification:Notification) -> Void {
        guard
            let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? String,
            let midiSignalReceived = userInfo["midiSignalReceived"] as? Bool,
            let midiTypeReceived = userInfo["midiTypeReceived"] as? MidiEventType else {
                print("No userInfo found in notification")
                return
        }
        DispatchQueue.main.async(execute: { [unowned self] in
            self.outputTextLabel.text = message
            self.midiSignalReceived = midiSignalReceived
            self.midiTypeReceived = midiTypeReceived
            self.flashBackgroundColor()
        })
    }
    
    @objc func flashBackgroundColor() {
        if midiSignalReceived {
            self.outputTextLabel.backgroundColor = UIColor.green
            self.view.backgroundColor = UIColor.lightGray
            if midiTypeReceived != .noteNumber {
                self.perform(#selector(dismissFlashBackgroundColor), with: nil, afterDelay: 0.5)
            }
        } else {
            dismissFlashBackgroundColor()
        }
    }
    
    @objc func dismissFlashBackgroundColor() {
        UIView.animate(withDuration: 0.5) {
            self.outputTextLabel.backgroundColor = UIColor.white
            self.view.backgroundColor = UIColor.white
            self.midiSignalReceived = false
            self.conductor.midiSignalReceived = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "outputMessage"),
                                                  object: nil)
    }
    
}

