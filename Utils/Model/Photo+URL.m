//
//  Photo+URL.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "Photo+URL.h"

@implementation Photo (URL)

- (NSURL *)url
{
    NSString * baseUrl = [NSString stringWithFormat:@"https://farm%lu.static.flickr.com/%@/%@_%@.jpg", self.farm, self.server, self.id_photo, self.secret];
    return [NSURL URLWithString:baseUrl];
}

@end
