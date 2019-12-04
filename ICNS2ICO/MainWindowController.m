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
 * @file        
 * @copyright   (c) 2013, DigiDNA - www.digidna.net
 * @author      Jean-David Gadina <macmade@digidna.net>
 * @abstract    ...
 */

#import "MainWindowController.h"
#import "MainWindowController+NSWindowDelegate.h"
#import "MainWindowController+NSTableViewDataSource.h"
#import "BackgroundView.h"
#import <ICOConverter/ICOConverter.h>

@implementation MainWindowController

@synthesize tableView           = _tableView;
@synthesize destinationPopup    = _destinationPopup;
@synthesize icoFormatMatrix     = _icoFormatMatrix;
@synthesize progressBar         = _progressBar;
@synthesize progressText        = _progressText;
@synthesize filesCountText      = _filesCountText;
@synthesize mask                = _mask;
@synthesize backgroundView      = _backgroundView;
@synthesize iconView            = _iconView;
@synthesize processing          = _processing;

- ( id )init
{
    return [ self initWithWindowNibName: @"MainWindow" owner: self ];
}

- ( void )dealloc
{
    [ _tableView        release ];
    [ _destinationPopup release ];
    [ _icoFormatMatrix  release ];
    [ _progressBar      release ];
    [ _progressText     release ];
    [ _filesCountText   release ];
    [ _mask             release ];
    [ _backgroundView   release ];
    [ _iconView         release ];
    [ _icons            release ];
    [ _destinationPath  release ];
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    NSArray    * paths;
    NSMenuItem * item;
    
    _backgroundView.backgroundColor = [ NSColor whiteColor ];
    _backgroundView.alphaValue      = ( CGFloat )0.75;
    
    [ _iconView removeFromSuperview ];
    [ self.window.contentView addSubview: _iconView positioned: NSWindowBelow relativeTo: nil ];
    
    _progressBar.alphaValue     = ( CGFloat )0;
    _progressText.alphaValue    = ( CGFloat )0;
    _mask.alphaValue            = ( CGFloat )0;
    _mask.backgroundColor       = [ NSColor whiteColor ];
    _tableView.dataSource       = self;
    _icoFormat                  = ICOFormatBMP;
    _filesCountText.stringValue = @"";
    
    [ _icoFormatMatrix selectCellWithTag: ICOFormatBMP ];
    
    paths = NSSearchPathForDirectoriesInDomains( NSDesktopDirectory, NSUserDomainMask, YES );
    
    if( paths.count > 0 )
    {
        _destinationPath = [ [ paths objectAtIndex: 0 ] copy ];
    }
    else
    {
        _destinationPath = [ NSHomeDirectory() copy ];
    }
    
    item        = [ [ [ NSMenuItem alloc ] initWithTitle: [ [ NSFileManager defaultManager ] displayNameAtPath: _destinationPath ] action: NULL keyEquivalent: @"" ] autorelease ];
    item.image  = [ [ NSWorkspace sharedWorkspace ] iconForFile: _destinationPath ];
    
    [ _destinationPopup.menu insertItem: item atIndex: 0 ];
    [ _destinationPopup selectItem: item ];
    
    self.window.delegate = self;
}

- ( IBAction )addIcons: ( id )sender
{
    NSOpenPanel * panel;
    
    ( void )sender;
    
    panel = [ [ NSOpenPanel new ] autorelease ];
    
    panel.allowedFileTypes          = @[ @"icns" ];
    panel.canChooseDirectories      = YES;
    panel.canCreateDirectories      = NO;
    panel.canChooseFiles            = YES;
    panel.allowsMultipleSelection   = YES;
    panel.prompt                    = NSLocalizedString( @"Select", nil );
    
    [ panel beginSheetModalForWindow: self.window completionHandler: ^( NSInteger result )
        {
            NSURL           * url;
            NSMutableArray  * icons;
            BOOL              isDir;
            
            _filesCountText.stringValue = @"";
            
            if( result == NSCancelButton || panel.URLs.count == 0 )
            {
                return;
            }
            
            [ _icons release ];
            
            icons = [ NSMutableArray arrayWithCapacity: panel.URLs.count ];
            
            for( url in panel.URLs )
            {
                if( [ [ NSFileManager defaultManager ] fileExistsAtPath: url.path isDirectory: &isDir ] && isDir == YES )
                {
                    {
                        NSDirectoryEnumerator * enumerator;
                        NSString              * file;
                        
                        enumerator = [ [ NSFileManager defaultManager ] enumeratorAtPath: url.path ];
                        
                        while( ( file = [ enumerator nextObject ] ) )
                        {
                            if( [ file.pathExtension isEqualToString: @"icns" ] )
                            {
                                [ icons addObject: [ url.path stringByAppendingPathComponent: file ] ];
                            }
                        }
                    }
                }
                else
                {
                    [ icons addObject: url.path ];
                }
            }
            
            _icons                      = [ [ NSArray arrayWithArray: icons ] retain ];
            _filesCountText.stringValue = [ NSString stringWithFormat: NSLocalizedString( @"NumberOfFiles", nil ), ( unsigned int )( _icons.count ) ];
            
            [ _tableView reloadData ];
        }
    ];
}

- ( IBAction )removeIcons: ( id )sender
{
    NSMutableArray * icons;
    
    ( void )sender;
    
    if( _tableView.selectedRowIndexes.count == 0 )
    {
        return;
    }
    
    icons = [ [ _icons mutableCopy ] autorelease ];
    
    [ icons removeObjectsAtIndexes: _tableView.selectedRowIndexes ];
    
    _icons = [ [ NSArray arrayWithArray: icons ] retain ];
    
    if( _icons.count > 0 )
    {
        _filesCountText.stringValue = [ NSString stringWithFormat: NSLocalizedString( @"NumberOfFiles", nil ), ( unsigned int )( _icons.count ) ];
    }
    else
    {
        _filesCountText.stringValue = @"";
    }
    
    [ _tableView deselectAll: nil ];
    [ _tableView reloadData ];
}

- ( IBAction )chooseDestinationFolder: ( id )sender
{
    NSOpenPanel * panel;
    
    ( void )sender;
    
    panel = [ [ NSOpenPanel new ] autorelease ];
    
    panel.canChooseDirectories      = YES;
    panel.canCreateDirectories      = YES;
    panel.canChooseFiles            = NO;
    panel.allowsMultipleSelection   = NO;
    panel.prompt                    = NSLocalizedString( @"Choose", nil );
    
    [ panel beginSheetModalForWindow: self.window completionHandler: ^( NSInteger result )
        {
            NSMenuItem * item;
            
            if( result == NSCancelButton || panel.URLs.count == 0 )
            {
                [ _destinationPopup selectItemAtIndex: 0 ];
                
                return;
            }
            
            [ _destinationPath release ];
            [ _destinationPopup removeItemAtIndex: 0 ];
            
            _destinationPath = [ panel.URL.path copy ];
            
            item        = [ [ [ NSMenuItem alloc ] initWithTitle: [ [ NSFileManager defaultManager ] displayNameAtPath: _destinationPath ] action: NULL keyEquivalent: @"" ] autorelease ];
            item.image  = [ [ NSWorkspace sharedWorkspace ] iconForFile: _destinationPath ];
            
            [ _destinationPopup.menu insertItem: item atIndex: 0 ];
            [ _destinationPopup selectItem: item ];
        }
    ];
}

- ( IBAction )setICOFormat: ( id )sender
{
    ( void )sender;
    
    _icoFormat = ( ICOFormat )[ _icoFormatMatrix selectedTag ];
}

- ( IBAction )convert: ( id )sender
{
    NSAlert * alert;
    
    ( void )sender;
    
    if( _icons.count == 0 )
    {
        alert = [ NSAlert   alertWithMessageText:       NSLocalizedString( @"NoIconsAlertTitle", nil )
                            defaultButton:              NSLocalizedString( @"OK", nil )
                            alternateButton:            nil
                            otherButton:                nil
                            informativeTextWithFormat:  NSLocalizedString( @"NoIconsAlertText", nil )
                ];
        
        [ alert beginSheetModalForWindow: self.window modalDelegate: nil didEndSelector: NULL contextInfo: nil ];
        
        return;
    }
    
    if( _destinationPath.length == 0 || [ [ NSFileManager defaultManager ] fileExistsAtPath: _destinationPath ] == NO )
    {
        alert = [ NSAlert   alertWithMessageText:       NSLocalizedString( @"NoDestinationAlertTitle", nil )
                            defaultButton:              NSLocalizedString( @"OK", nil )
                            alternateButton:            nil
                            otherButton:                nil
                            informativeTextWithFormat:  NSLocalizedString( @"NoDestinationAlertText", nil )
                ];
        
        [ alert beginSheetModalForWindow: self.window modalDelegate: nil didEndSelector: NULL contextInfo: nil ];
        
        return;
    }
    
    _progressBar.alphaValue     = ( CGFloat )1;
    _progressText.alphaValue    = ( CGFloat )1;
    _mask.alphaValue            = ( CGFloat )0.9;
    
    [ _progressBar startAnimation:   nil ];
    [ _progressBar setIndeterminate: NO ];
    [ _progressBar setMinValue:      0 ];
    [ _progressBar setMaxValue:      _icons.count ];
    [ _progressBar setDoubleValue:   0 ];
    
    _processing = YES;
    
    dispatch_async
    (
        dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0 ),
        ^( void )
        {
            NSString     * icon;
            ICOConverter * converter;
            
            converter           = [ [ ICOConverter alloc ] initWithDestinationDirectory: _destinationPath ];
            converter.icoFormat = ( _icoFormat == ICOConverterFormatPNG ) ? ICOConverterFormatPNG : ICOConverterFormatBMP;
            
            for( icon in _icons )
            {
                [ converter convertImageAtPath: icon ];
                
                dispatch_async
                (
                    dispatch_get_main_queue(),
                    ^( void )
                    {
                        [ _progressBar setDoubleValue:  [ _progressBar doubleValue ] + 1 ];
                    }
                );
            }
            
            [ NSThread sleepForTimeInterval: 1 ];
            [ converter release ];
            
            dispatch_sync
            (
                dispatch_get_main_queue(),
                ^( void )
                {
                    NSAlert * successAlert;
                    
                    _progressBar.alphaValue     = ( CGFloat )0;
                    _progressText.alphaValue    = ( CGFloat )0;
                    _mask.alphaValue            = ( CGFloat )0;
                    
                    [ _progressBar setIndeterminate: YES ];
                    [ _progressBar stopAnimation: nil ];
                    
                    _processing = NO;
                    
                    successAlert = [ NSAlert alertWithMessageText:      NSLocalizedString( @"ConversionOKAlertTitle", nil )
                                             defaultButton:             NSLocalizedString( @"OK", nil )
                                             alternateButton:           nil
                                             otherButton:               nil
                                             informativeTextWithFormat: NSLocalizedString( @"ConversionOKAlertText", nil )
                                   ];
                    
                    [ successAlert beginSheetModalForWindow: self.window modalDelegate: nil didEndSelector: NULL contextInfo: nil ];
                }
            ); 
        }
    );
}

@end
