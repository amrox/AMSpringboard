//
//  Utility.m
//  GeoTick
//
//  Created by Andy Mroczkowski on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


NSString* AMGetUUID()
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}

NSString* AMGetApplicationDocumentsDirectory()
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
