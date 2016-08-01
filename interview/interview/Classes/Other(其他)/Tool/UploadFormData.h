//
//  UploadFormData.h
//  interview
//
//  Created by 于波 on 16/3/31.
//  Copyright © 2016年 于波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadFormData : NSObject
YT_Singleton_H(ImageModel)
/**请求参数名 根据服务器定*/
@property (nonatomic, copy, readwrite) NSString *name;
/**保存到服务器的文件名（可不填）*/
@property (nonatomic, copy, readwrite) NSString *fileName;
/**文件类型 文件类型 image/jpeg，application/pdf*/
@property (nonatomic, copy, readwrite) NSString *mimeType;
/**二进制数据*/
@property (nonatomic, strong, readwrite) NSData *data;
@end
