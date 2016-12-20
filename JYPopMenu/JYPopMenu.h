//
//  JYPopMenu.h
//  JYPopMenu
//
//  Created by sun on 16/5/9.
//  Copyright © 2016年 sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

typedef void(^JYPopMenuDidSelectedBlock)(NSInteger index, NSString *itemNameStr);

@interface JYPopMenu : NSObject
@property(nonatomic, assign) CGRect overlayFrame;//背景

+ (instancetype)shareJYPopMenu;

- (void)showJYMenuWithTargetFrame:(CGRect)targetFrame WithTargetView:(UIView *)view WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(JYPopMenuDidSelectedBlock)block;
- (void)showJYMenuWithTargetFrame:(CGRect)targetFrame WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(JYPopMenuDidSelectedBlock)block;

- (void)dismissJYMenu:(BOOL)animated;
@end

@interface JYPopMenuView : UIView
@property(nonatomic, copy) JYPopMenuDidSelectedBlock popMenuDidSelectedBlock;

- (void)showJYMenuWithTargetFrame:(CGRect)targetFrame WithTargetView:(UIView *)view WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(JYPopMenuDidSelectedBlock)block;
- (void)showJYMenuWithTargetFrame:(CGRect)targetFrame WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(JYPopMenuDidSelectedBlock)block;

- (void)dismissJYMenu:(BOOL)animated;

- (CGRect)getTargetFrame;
@end




@interface JYPopMenuTableCell : UITableViewCell
@property(nonatomic, strong) UILabel *JYTextLabel;
@end
