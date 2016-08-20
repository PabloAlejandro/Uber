//
//  PhotosRequest.m
//  Uber
//
//  Created by Pablo Alejandro Perez Martinez on 19/08/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "PhotosRequest.h"
#import "Photos.h"
#import "Photo.h"

@interface PhotosRequest ()

@end

@implementation PhotosRequest

- (NSURLSessionDataTask *)retrieveDataWithCompletion:(RequestResultBlock)completion
{
    return [super retrieveDataWithCompletion:^(id result, NSDictionary *userInfo) {
        completion([self photosFromJson:result], userInfo);
    }];
}

- (Photos *)photosFromJson:(NSDictionary *)json
{
    Photos * photos = nil;
    
    if([json isKindOfClass:[NSDictionary class]]) {
        
        NSDictionary * photosDict = (NSDictionary *)[json objectForKey:@"photos"];
        
        photos = [Photos new];
        photos.page = [[photosDict objectForKey:@"page"] integerValue];
        photos.pages = [[photosDict objectForKey:@"pages"] integerValue];
        photos.perpage = [[photosDict objectForKey:@"perpage"] integerValue];
        photos.total = [[photosDict objectForKey:@"total"] integerValue];
        
        for(NSDictionary * photoDict in [photosDict objectForKey:@"photo"]) {
            
            Photo * photo = [Photo new];
            photo.farm = [[photoDict objectForKey:@"farm"] integerValue];
            photo.id_photo = [photoDict objectForKey:@"id"];
            photo.isfamily = [[photoDict objectForKey:@"isfamily"] boolValue];
            photo.isfriend = [[photoDict objectForKey:@"isfriend"] boolValue];
            photo.ispublic = [[photoDict objectForKey:@"ispublic"] boolValue];
            photo.owner = [photoDict objectForKey:@"owner"];
            photo.secret = [photoDict objectForKey:@"secret"];
            photo.server = [photoDict objectForKey:@"server"];
            photo.title = [photoDict objectForKey:@"title"];
            
            [photos.photos addObject:photo];
        }
    }
    
    return photos;
}

@end
