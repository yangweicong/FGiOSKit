//
//  NIMKitDataProviderImpl+YLLCustom.m
//  yulala
//
//  Created by Eric on 2019/1/8.
//  Copyright © 2019 YangWeiCong. All rights reserved.
//

#import "NIMKitDataProviderImpl+YLLCustom.h"
#import "NIMKit.h"
#import "NIMKitDataProviderImpl.h"
#import "NIMKitInfoFetchOption.h"
#import "UIImage+NIMKit.h"

@implementation NIMKitDataProviderImpl (YLLCustom)

#pragma mark - P2P 用户信息
- (NIMKitInfo *)userInfoInP2P:(NSString *)userId
                       option:(NIMKitInfoFetchOption *)option
{
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userId];
    NIMUserInfo *userInfo = user.userInfo;
    NIMKitInfo *info;
    if (userInfo)
    {
        info = [[NIMKitInfo alloc] init];
        info.infoId = userId;
        NSString *name = [self nickname:user
                             memberInfo:nil
                                 option:option];
        info.showName = name?:userId;
        info.avatarUrlString = userInfo.thumbAvatarUrl;
        
        //把https 替换 http
        if ([info.avatarUrlString containsString:@"https"]) {
            info.avatarUrlString = [info.avatarUrlString stringByReplacingOccurrencesOfString:@"https" withString:@"http"];
        }
        
        info.avatarImage = [UIImage nim_imageInKit:@"avatar_user"];
    }
    return info;
}

//昵称优先级
- (NSString *)nickname:(NIMUser *)user
            memberInfo:(NIMTeamMember *)memberInfo
                option:(NIMKitInfoFetchOption *)option
{
    NSString *name = nil;
    do{
        if (!option.forbidaAlias && [user.alias length])
        {
            name = user.alias;
            break;
        }
        if (memberInfo && [memberInfo.nickname length])
        {
            name = memberInfo.nickname;
            break;
        }
        
        if ([user.userInfo.nickName length])
        {
            name = user.userInfo.nickName;
            break;
        }
    }while (0);
    return name;
}

#pragma mark - avatar


@end
