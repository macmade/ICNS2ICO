ICNS2ICO
========

[![Build Status](https://img.shields.io/github/workflow/status/macmade/ICNS2ICO/ci-mac?label=macOS&logo=apple)](https://github.com/macmade/ICNS2ICO/actions/workflows/ci-mac.yaml)
[![Issues](http://img.shields.io/github/issues/macmade/ICNS2ICO.svg?logo=github)](https://github.com/macmade/ICNS2ICO/issues)
![Status](https://img.shields.io/badge/status-active-brightgreen.svg?logo=git)
![License](https://img.shields.io/badge/license-mit-brightgreen.svg?logo=open-source-initiative)  
[![Contact](https://img.shields.io/badge/follow-@macmade-blue.svg?logo=twitter&style=social)](https://twitter.com/macmade)
[![Sponsor](https://img.shields.io/badge/sponsor-macmade-pink.svg?logo=github-sponsors&style=social)](https://github.com/sponsors/macmade)

About
-----

ICNS2ICO lets you easily convert icons from the Apple's ICNS format to the Windows ICO format.

### Background

A lot of nice icon conversion applications are available, but unfortunately they all have a common pitfall with the ICO format.

Since Windows Vista, ICO files may contain PNG encoded representations, up to 256x256 pixels (Windows XP used BMP).  So all applications generate PNG representations when generating icons larger to 32x32.

Unfortunately, when used in a WPF program on Windows XP, this often leads to crashes, because the PNG format is not supported.

So in order to use ICO files with Windows XP, the internal format must be BMP.  
You can still use representations up to 256x256 pixels, as long as they're also in the BMP format.

ICNS2ICO lets you choose the internal format for the generated ICO files.

![Screenshot](http://www.xs-labs.com/uploads/image/misc/icns2ico.png)

### Installation

ICNS2ICO uses the ImageMagick library to produce valid BMP files.  
While the Cocoa framework is able to output images in such a format, it unfortunately produces files that are incompatible with Windows.  
That's where ImageMagick comes in handy.

The simplest to install ImageMagick is to use [HomeBrew](http://brew.sh).  
Once it's installed on your computer, simply type, from a terminal window:

    brew install imagemagick@6
    
You'll then be able to build and run ICNS2ICO from Xcode.

License
-------

ICNS2ICO is released under the terms of the MIT License.

Repository Infos
----------------

    Owner:			DigiDNA
    Web:			www.digidna.net
    Blog:			blog.digidna.net
    Twitter:		@DigiDNA
    GitHub:			github.com/DigiDNA
