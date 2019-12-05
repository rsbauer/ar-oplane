# ar-oplane

Looking up at the sky, it was always a curiosity to know more about what was flying.  Things like type of aircraft, air carrier, altitude, airspeed, and anything else.  Using augmented reality, this app queries a ADB-S lookup service provider for aircraft in the general area.  It then plots them on the device in relation to the area in view.  Spin the phone around to observe aircraft in that part of the sky.  

Sadly, the hardware compass on the phone, depending on location, may not point to north which causes the air craft to be out of alignment in relation to the sky.  Top the left or right edges repeatedly to move the "north" box indicator to roughly where north is to correct.  

Another limitation is the aircraft boxes may not perfectly line up due to latency in receivers receiving the ADS-B signal, posting it, and this app querying it and displaying it.  As such, do not use this for any purpose beyond entertainment and at your own risk.

### App Features:
* Augmented reality view of the aircraft in the area (sadly, no ability at this time to configure the range or any  additional aircraft info displayed)

### Project Features:
* AppDelegate uses the service design pattern
* Network call state machine (experimental)
* A (modified) message broker 

### Screen Shots

AR View 
--- 
<img src="https://raw.githubusercontent.com/rsbauer/ar-oplane/master/images/arview.png" width="400">

### Getting Started

You will need the source code from here and the latest Xcode installed.  

Although CocoaPods was used, the author added the Pods directory to the repository in case a pod is no longer avaialbe and to ease onboarding.  

If desired, pods can be installed: (this requiers CocoaPods to be installed)

  `pod install`

### Prerequisites

Before starting, you will need Cocoapods installed.  

1. Clone this repo

  `git clone [this repo url]`

2. Install pods

  `pod install`

5. Open the ComicReader.xcworkspace

  `open ComicReader.wxworkspace`

6. Build!

## Running the tests

From Xcode, select the Test Navigator and select all tests or individual tests.  
 
## Deployment

Deployments are ad hoc at this time.

### License

See LICENSE file located in this repository.

