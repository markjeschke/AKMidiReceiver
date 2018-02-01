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
    
    @objc func catchNotification(notification:Notification) -> Void {
        guard
            let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? String,
            let midiSignalReceived = userInfo["midiSignalReceived"] as? Bool,
            let midiTypeReceived = userInfo["midiTypeReceived"] as? MidiEventType else {
                print("No userInfo found in notification")
                return
        }
        DispatchQueue.main.async(execute: {
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
                dismissFlashBackgroundColor()
                conductor.midiSignalReceived = false
            }
        } else {
            dismissFlashBackgroundColor()
        }
    }
    
    @objc func dismissFlashBackgroundColor() {
        UIView.animate(withDuration: 0.5) {
            self.outputTextLabel.backgroundColor = UIColor.clear
            self.view.backgroundColor = UIColor.white
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: "outputMessage"),
                                                  object: nil)
    }
    
}

