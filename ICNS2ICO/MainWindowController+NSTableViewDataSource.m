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

#import "MainWindowController+NSTableViewDataSource.h"

static NSString * const __TableColumnIDIcon = @"Icon";
static NSString * const __TableColumnIDName = @"Name";

@implementation MainWindowController( NSTableViewDataSource )

- ( NSInteger )numberOfRowsInTableView: ( NSTableView * )tableView
{
    ( void )tableView;
    
    return ( NSInteger )( _icons.count );
}

- ( id )tableView: ( NSTableView * )tableView objectValueForTableColumn: ( NSTableColumn * )tableColumn row: ( NSInteger )row
{
    NSString * path;
    
    ( void )tableView;
    
    if( ( NSUInteger )row >= _icons.count )
    {
        return nil;
    }
    
    path = [ _icons objectAtIndex: ( NSUInteger )row ];
    
    if( [ tableColumn.identifier isEqualToString: __TableColumnIDIcon ] )
    {
        return [ [ [ NSImage alloc ] initWithContentsOfFile: path ] autorelease ];
    }
    else if( [ tableColumn.identifier isEqualToString: __TableColumnIDName ] )
    {
        return [ [ NSFileManager defaultManager ] displayNameAtPath: path ];
    }
    
    return nil;
}

@end
