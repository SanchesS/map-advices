# MapAdvices iOS App

This directory contains a more complete SwiftUI recreation of the onboarding demo in `public/index-onboarding.html`.
It shows an interactive card stack over a MapKit map and mirrors the web behaviour as closely as possible.

## Running

1. Open Xcode 14 or newer on your Mac.
2. Choose **File → Open...** and select the `ios/MapAdvices` folder. Xcode will generate a project automatically.
3. Pick a simulator (e.g. iPhone 14) and press **Run** (⌘R).

When launched for the first time an onboarding overlay explains that cards can be swiped up or down.
The app fetches places from the 2GIS API and displays them on the map with markers and a draggable card stack.
