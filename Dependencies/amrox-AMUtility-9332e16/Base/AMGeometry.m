//
//  AMGeometry.m
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/6/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import "AMGeometry.h"


CGRect AMRectInsetWithAspectRatio( CGRect rect, CGFloat insetRatio )
{
	CGFloat dx = 0., dy = 0.;
	
	CGFloat myAspectRatio = rect.size.width / rect.size.height;
	
	if( myAspectRatio - insetRatio > 0. )
	{
		dx = (rect.size.width - (rect.size.width * insetRatio / myAspectRatio)) / 2.;
	}
	else if( myAspectRatio - insetRatio < 0. )
	{
		dy = (rect.size.height - (rect.size.height * myAspectRatio / insetRatio)) / 2.;
	}
	
	return CGRectInset(rect, dx, dy);
}


CGRect AMRectMakeWithOriginAndSize( CGPoint origin, CGSize size )
{
	return CGRectMake(origin.x, origin.y, size.width, size.height);
}


CGRect AMRectMakeWithCenterAndSize( CGPoint center, CGSize size )
{
    return CGRectMake(center.x - size.width/2.,
                      center.y - size.height/2., 
                      size.width,
                      size.height);
}


CGRect AMRectRectWithSizeCenteredInRect( CGSize size, CGRect referenceRect )
{
	CGRect rect;
	rect.size = size;
	rect.origin.x = referenceRect.origin.x + (referenceRect.size.width-rect.size.width)/2.;
	rect.origin.y = referenceRect.origin.y + (referenceRect.size.height-rect.size.height)/2.;
	return rect;
}


CGSize AMSizeAspectFitToWidth( CGSize size, CGFloat width )
{
	CGSize newSize;
	newSize.width = width;
	newSize.height = size.height * ( newSize.width / size.width );
	return newSize;
}


CGSize AMSizeAspectFitToHeight( CGSize size, CGFloat height )
{
	CGSize newSize;
	newSize.height = height;
	newSize.width = size.width * ( newSize.height / size.height );
	return newSize;
}


CGPoint AMPointClampedToRect( CGPoint point, CGRect rect )
{
    point.x = MAX(point.x, CGRectGetMinX(rect));
    point.x = MIN(point.x, CGRectGetMaxX(rect));
    point.y = MAX(point.y, CGRectGetMinY(rect));
    point.y = MIN(point.y, CGRectGetMaxY(rect));
    
    return point;
}
