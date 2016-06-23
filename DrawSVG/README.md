# DrawSVG

Copyright (C) 2016 Matthew Tso

DrawSVG is an SVG Drawing and Animation experimental project. It uses the PocketSVG Framework by Ariel Elkin at [https://github.com/arielelkin/PocketSVG] to create CGPaths from an SVG file's `d` attribute that is found in its `path` tag. The resulting CGPath is used to draw CAShapeLayers so that the path can be animated.

## Requirements

### Build

Xcode 7.3, iOS 9.0 SDK

### Runtime

iOS 9.3

## Notes

It is obvious that rendering performance suffers at the moment. In Crazy Mode, 2232 CAShapeLayers are created and added to the main view. Animating these CAShapeLayers causes the frame rate to drop into single digits.