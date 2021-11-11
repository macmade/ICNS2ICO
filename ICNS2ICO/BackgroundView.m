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

#import "BackgroundView.h"

@implementation BackgroundView

- ( void )dealloc
{
    [ _backgroundColor  release ];
    [ _borderColor      release ];
    
    [ super dealloc ];
}

- ( NSColor * )backgroundColor
{
    @synchronized( self )
    {
        return _backgroundColor;
    }
}

- ( void )setBackgroundColor: ( NSColor * )color
{
    @synchronized( self )
    {
        if( color != _backgroundColor )
        {
            [ _backgroundColor release ];
            
            _backgroundColor = [ color retain ];
            
            [ self setNeedsDisplay: YES ];
        }
    }
}

- ( NSColor * )borderColor
{
    @synchronized( self )
    {
        return _borderColor;
    }
}

- ( void )setBorderColor: ( NSColor * )color
{
    @synchronized( self )
    {
        if( color != _borderColor )
        {
            [ _borderColor release ];
            
            _borderColor = [ color retain ];
            
            [ self setNeedsDisplay: YES ];
        }
    }
}

- ( void )drawRect: ( NSRect )rect
{
    if( _backgroundColor != nil )
    {
        [ _backgroundColor setFill ];
        
        NSRectFill( rect );
    }
    
    if( _borderColor != nil )
    {
        {
            NSBezierPath * path;
            NSGradient   * gradient;
            NSRect         subrect;
            
            subrect              = rect;
            subrect.origin.x    += 1;
            subrect.origin.y    += 1;
            subrect.size.width  -= 2;
            subrect.size.height -= 2;
            
            path = [ NSBezierPath bezierPathWithRect: rect ];
            
            [ path appendBezierPath: [ NSBezierPath bezierPathWithRect: subrect ] ];
            [ path setWindingRule: NSEvenOddWindingRule ];
            
            gradient = [ [ NSGradient alloc ] initWithColorsAndLocations: _borderColor, ( CGFloat )0, nil ];
            
            [ gradient drawInBezierPath: path angle: ( CGFloat )0 ];
            [ gradient release ];
        }
    }
    
    [ super drawRect: rect ];
}

@end
