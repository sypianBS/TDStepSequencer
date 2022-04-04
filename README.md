# TDStepSequencer

AVFoundation + Realm + SwiftUI

This is an early version of a step sequencer which currently plays random notes sequences. The ultimate goal is to make it fully functional by providing a proper UI with an ability to play user-chosen notes sequences.

Author: sypianBS bensypianski@googlemail.com

![simulator_screenshot_E6EA2303-0EBE-4BB2-83F7-D73B022D99D8](https://user-images.githubusercontent.com/99125193/156919405-b8a796d4-7b4f-4be7-9db5-94788329488b.png)

Current features:
- 3 waveforms (sine, saw, square)
- 5 different rates (1, 1/2, 1/4, 1/8, 1/16)
- adjustable bpm
- saving and loading the sequences (only the notes, not the parameters)

ToDos (must have):
- UI for creating the desired sequences
- fix sine wave audio distortion / clicks

ToDos (nice to have):
- arp gate (slightly changes length of the notes) 
- swing / groove
- additional rates (1/6, 1/12, 1/24)
- editable names for the stored sequences
