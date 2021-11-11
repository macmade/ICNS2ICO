/*******************************************************************************
 * The MIT License (MIT)
 * 
 * Copyright (c) 2013, DigiDNA - www.digidna.net

 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

/*!
 * @header      
 * @copyright   (c) 2013, DigiDNA - www.digidna.net
 * @author      Jean-David Gadina <macmade@digidna.net>
 * @abstract    ...
 */

@class BackgroundView;

typedef enum
{
    ICOFormatUnknown    = 0x00,
    ICOFormatBMP        = 0x01,
    ICOFormatPNG        = 0x02
}
ICOFormat;

@interface MainWindowController: NSWindowController
{
@private
    
    NSTableView         * _tableView;
    NSPopUpButton       * _destinationPopup;
    NSMatrix            * _icoFormatMatrix;
    NSProgressIndicator * _progressBar;
    NSTextField         * _progressText;
    NSTextField         * _filesCountText;
    BackgroundView      * _mask;
    BackgroundView      * _backgroundView;
    NSImageView         * _iconView;
    NSArray             * _icons;
    NSString            * _destinationPath;
    ICOFormat             _icoFormat;
    BOOL                  _processing;
}

@property( nonatomic, readwrite, retain ) IBOutlet NSTableView         * tableView;
@property( nonatomic, readwrite, retain ) IBOutlet NSPopUpButton       * destinationPopup;
@property( nonatomic, readwrite, retain ) IBOutlet NSMatrix            * icoFormatMatrix;
@property( nonatomic, readwrite, retain ) IBOutlet NSProgressIndicator * progressBar;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField         * progressText;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField         * filesCountText;
@property( nonatomic, readwrite, retain ) IBOutlet NSView              * mask;
@property( nonatomic, readwrite, retain ) IBOutlet NSView              * backgroundView;
@property( nonatomic, readwrite, retain ) IBOutlet NSImageView         * iconView;
@property( atomic, readonly             )          BOOL                  processing;

- ( IBAction )addIcons:                 ( id )sender;
- ( IBAction )removeIcons:              ( id )sender;
- ( IBAction )chooseDestinationFolder:  ( id )sender;
- ( IBAction )setICOFormat:             ( id )sender;
- ( IBAction )convert:                  ( id )sender;

@end
