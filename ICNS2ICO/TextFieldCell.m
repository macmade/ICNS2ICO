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

#import "TextFieldCell.h"

@implementation TextFieldCell

- ( void )drawWithFrame: ( NSRect )frame inView: ( NSView * )view
{
    NSString            * text;
    NSMutableDictionary * attributes;
    CGFloat               fontSize;
    NSRect                textRect;
    NSSize                size;
    
    ( void )view;
    
    if( [ self.objectValue isKindOfClass: [ NSString class ] ] == NO )
    {
        return;
    }
    
    attributes  = [ NSMutableDictionary dictionaryWithCapacity: 10 ];
    fontSize    = [ NSFont systemFontSize ];
    
    if( self.backgroundStyle == NSBackgroundStyleDark )
    {
        [ attributes setObject: [ NSColor whiteColor ] forKey: NSForegroundColorAttributeName ];
    }
    else
    {
        [ attributes setObject: [ NSColor textColor ] forKey: NSForegroundColorAttributeName ];
    }
    
    [ attributes setObject: [ NSFont systemFontOfSize: fontSize ]   forKey: NSFontAttributeName ];
    [ attributes setObject: [ NSColor clearColor ]                  forKey: NSBackgroundColorAttributeName ];
    
    text                  = ( NSString * )( self.objectValue );
    size                  = [ text sizeWithAttributes: attributes ];
    textRect              = frame;
    textRect.origin.y    += ( frame.size.height - size.height ) / ( CGFloat )2;
    textRect.size.height -= ( frame.size.height - size.height ) / ( CGFloat )2;
    
    [ text drawInRect: textRect withAttributes: attributes ];
}

@end
