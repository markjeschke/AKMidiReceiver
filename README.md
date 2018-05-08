# AKMidiReceiver
Swift Xcode Project that demonstrates how to animate the backgroundColor of a UILabel when MIDI has been received from an external MIDI controller or a MIDI-enabled app. This also includes how to implement reverb effects into the audio signal. Made with the [AudioKit](http://audiokit.io/) framework.

The EXS24 sounds are for demo purposes, only. They are borrowed from the incredible [ROM Player](https://github.com/AudioKit/ROMPlayer) by [Matthew Fetcher](https://github.com/analogcode).

## Installation

The AudioKit framework in this project was installed using [CocoaPods](https://cocoapods.org/). In order to install AudioKit to run and build this project successfully, please run the following command line in the Terminal Mac app:

```
cd <path/to/the/AKMidiReceiver repo>
``` 

**Step 1** - Install CocoaPods. If you already have it installed on your machine, you may skip to Step 2.

```language-powerbash
sudo gem install cocoapods
```

**Step 2** - Install the AudioKit framework via CocoaPods

```language-powerbash
pod update
```
Launch the `AKMidiReceiver.xcworkspace` – not the `AKMidiReceiver.xcodeproj`

**Notes**

* Minimum target is iOS 9.0. 
* Updated with Xcode 9.3, but is compatible with Xcode 8.0 project document.

**No Scheme Found in the Xcode Workspace?** 

If you open the Workspace and no scheme is found in the Xcode project, please follow these steps that were found [here](https://stackoverflow.com/questions/21755799/xcode-no-scheme):

1. Click on No Scheme
2. Click on Manage Scheme
3. Click on Autocreate Schemes Now


