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
    [ _progressBar setMaxValue:      ( double )( _icons.count ) ];
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
