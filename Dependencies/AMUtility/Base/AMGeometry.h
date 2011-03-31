//
//  AMGeometry.h
//  AMSpringboardView
//
//  Created by Andy Mroczkowski on 3/6/11.
//  Copyright 2011 Andy Mroczkowski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#ifdef __cplusplus
extern "C" {
#endif
	
    static CGPoint inline AMRectCenter( CGRect rect )
    {
        return CGPointMake(rect.size.width/2. + rect.origin.x,
                           rect.size.height/2. + rect.origin.y);
    }
    
    extern CGRect AMRectMakeWithOriginAndSize( CGPoint origin, CGSize size );
    extern CGRect AMRectMakeWithCenterAndSize( CGPoint center, CGSize size );
    extern CGRect AMRectRectWithSizeCenteredInRect( CGSize size, CGRect referenceRect );
    extern CGRect AMRectInsetWithAspectRatio( CGRect rect, CGFloat aspectRatio );
    extern CGSize AMSizeAspectFitToWidth( CGSize size, CGFloat width );
    extern CGSize AMSizeAspectFitToHeight( CGSize size, CGFloat height );
    extern CGPoint AMPointClampedToRect( CGPoint point, CGRect rect );
    
    
#ifdef __cplusplus
}
#endif
