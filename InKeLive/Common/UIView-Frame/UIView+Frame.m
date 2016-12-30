// UIView+Frame.m
//
// Copyright (c) 2009 Alex Nazaroff, AJR (http://ajiiro.com/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIView+Frame.h"

@implementation UIView (Frames)

-(void) setOrigin:(CGPoint)loc
{
    CGRect rc = self.frame;
    rc.origin = loc;
    self.frame = rc;
}

-(void) setX:(CGFloat)x
{
    CGRect rc = self.frame;
    rc.origin.x = x;
    self.frame = rc;
}

-(void) setY:(CGFloat)y
{
    CGRect rc = self.frame;
    rc.origin.y = y;
    self.frame = rc;
}

-(void) setSize:(CGSize)sz
{
    CGRect rc = self.frame;
    rc.size = sz;
    self.frame = rc;
}

-(void) setWidth:(CGFloat)w
{
    CGRect rc = self.frame;
    rc.size.width = w;
    self.frame = rc;
}

-(void) setHeight:(CGFloat)h
{
    CGRect rc = self.frame;
    rc.size.height = h;
    self.frame = rc;
}

-(void) setCenterY:(CGFloat) y
{
    CGPoint pt = self.center;
    pt.y = y;
    self.center = pt;
}

-(void) setCenterX:(CGFloat) x
{
    CGPoint pt = self.center;
    pt.x = x;
    self.center = pt;
}

-(CGPoint) origin
{
    return self.frame.origin;
}

-(CGFloat) x
{
    return self.frame.origin.x;
}

-(CGFloat) y
{
    return self.frame.origin.y;
}

-(CGFloat) top
{
    return self.frame.origin.y;
}

-(CGFloat) left
{
    return self.frame.origin.x;
}

-(CGFloat) right
{
    return self.frame.origin.x + self.frame.size.width;
}

-(CGFloat) bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

-(CGSize) size
{
    return self.frame.size;
}

-(CGFloat) height
{
    return self.frame.size.height;
}

-(CGFloat) width
{
    return self.frame.size.width;
}

-(CGFloat) centerX
{
    return self.center.x;
}

-(CGFloat) centerY
{
    return self.center.y;
}

@end
