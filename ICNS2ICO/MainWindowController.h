/*******************************************************************************
 * Copyright (c) 2013, DigiDNA - www.digidna.net
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *  -   Redistributions of source code must retain the above copyright notice,
 *      this list of conditions and the following disclaimer.
 *  -   Redistributions in binary form must reproduce the above copyright
 *      notice, this list of conditions and the following disclaimer in the
 *      documentation and/or other materials provided with the distribution.
 *  -   Neither the name of 'Jean-David Gadina' nor the names of its
 *      contributors may be used to endorse or promote products derived from
 *      this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
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
