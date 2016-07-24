//
//  Photo.h
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, assign) NSInteger farm;
@property (nonatomic, strong) NSString * id_photo;
@property (nonatomic, assign) BOOL isfamily;
@property (nonatomic, assign) BOOL isfriend;
@property (nonatomic, assign) BOOL ispublic;
@property (nonatomic, strong) NSString * owner;
@property (nonatomic, strong) NSString * secret;
@property (nonatomic, strong) NSString * server;
@property (nonatomic, strong) NSString * title;

@end
