//
//  MAPReplyModel.m
//  地图
//
//  Created by 崔一鸣 on 2018/5/15.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPReplyModel.h"
#import "YYText.h"

@implementation MAPReplyModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSAttributedString *)getAttributedReplyString {
    NSMutableAttributedString *text;
    if ([_type isEqual:@"reply"]) {
        text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@回复%@：%@", _fromUser, _toUser, _text]];
        text.yy_font = [UIFont systemFontOfSize:12];
        text.yy_color = [UIColor blackColor];
        [text yy_setColor:[UIColor colorWithRed:1.00f green:0.58f blue:0.00f alpha:1.00f] range:NSMakeRange(0, _fromUser.length)];
        [text yy_setColor:[UIColor colorWithRed:1.00f green:0.58f blue:0.00f alpha:1.00f] range:NSMakeRange(_fromUser.length + 2, _toUser.length + 1)];
        YYTextHighlight *fromUserHighlight = [YYTextHighlight highlightWithBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]];
        fromUserHighlight.userInfo = @{@"fromeUserKay":_fromUser};
        [text yy_setTextHighlight:fromUserHighlight range:NSMakeRange(0, _fromUser.length)];
        YYTextHighlight *toUserHighlight = [YYTextHighlight highlightWithBackgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]];
        toUserHighlight.userInfo = @{@"toUserKay":_toUser};
        [text yy_setTextHighlight:toUserHighlight range:NSMakeRange(_fromUser.length + 2, _toUser.length + 1)];
    } else {
        text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@", _fromUser, _text]];
        text.yy_font = [UIFont systemFontOfSize:12];
        text.yy_color = [UIColor blackColor];
        [text yy_setColor:[UIColor colorWithRed:1.00f green:0.58f blue:0.00f alpha:1.00f] range:NSMakeRange(0, _fromUser.length + 1)];
        YYTextHighlight *fromUserHighlight = [YYTextHighlight highlightWithBackgroundColor:[UIColor colorWithWhite:0.00 alpha:0.220]];
        fromUserHighlight.userInfo = @{@"fromUserKay" : _fromUser};
        [text yy_setTextHighlight:fromUserHighlight range:NSMakeRange(0, _fromUser.length + 1)];
    }
    return text;
        
}

@end
