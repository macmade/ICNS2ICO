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

#import "ApplicationDelegate.h"
#import "MainWindowController.h"
#import "AboutWindowController.h"

@implementation ApplicationDelegate

- ( void )dealloc
{
    [ _mainWindowController.window  close ];
    [ _aboutWindowController.window close ];
    
    [ _aboutWindowController release ];
    [ _mainWindowController  release ];
    
    [ super dealloc ];
}

- ( void )applicationDidFinishLaunching: ( NSNotification * )notification
{
    ( void )notification;
    
    _mainWindowController = [ MainWindowController new ];
    
    [ _mainWindowController.window center ];
    [ _mainWindowController.window makeKeyAndOrderFront: nil ];
}

- ( BOOL )applicationShouldTerminateAfterLastWindowClosed: ( NSApplication * )sender
{
    ( void )sender;
    
    return YES;
}

- ( NSApplicationTerminateReply )applicationShouldTerminate: ( NSApplication * )sender
{
    ( void )sender;
    
    return ( _mainWindowController.processing == YES ) ? NO : YES;
}

- ( IBAction )openDocument: ( id )sender
{
    [ _mainWindowController addIcons: sender ];
}

- ( IBAction )showAboutWindow: ( id )sender
{
    ( void )sender;
    
    if( _aboutWindowController == nil )
    {
        _aboutWindowController = [ AboutWindowController new ];
    }
    
    [ _aboutWindowController.window center ];
    [ _aboutWindowController.window makeKeyAndOrderFront: nil ];
}

@end
