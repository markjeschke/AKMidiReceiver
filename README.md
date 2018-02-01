# AKMidiReceiver
Swift Xcode Project that demonstrates how to animate the backgroundColor of a UILabel when MIDI has been received from an external MIDI controller or a MIDI-enabled app. Made with the [AudioKit](http://audiokit.io/) framework.

## Installation

The AudioKit framework in this project was installed using [CocoaPods](https://cocoapods.org/). In order to install AudioKit to run and build this project successfully, please run the following command line in the Terminal Mac app:

```
cd <path/to/the/AKMidiReceiver repo>
``` 

**Step 1** - Install CocoaPods, if you haven't already. Otherwise skip to Step 2.

```language-powerbash
sudo gem install cocoapods
```

**Step 2** - Install the AudioKit via CocoaPods

```language-powerbash
pod update
```
Launch the `AKMidiReceiver.xcworkspace` – not the `AKMidiReceiver.xcodeproj`

