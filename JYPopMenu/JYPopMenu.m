//
//  JYPopMenu.m
//  JYPopMenu
//
//  Created by sun on 16/5/9.
//  Copyright © 2016年 sun. All rights reserved.
//

#import "JYPopMenu.h"
static BOOL isShow = NO;
static JYPopMenu *popMenu;

@implementation JYPopMenu {
    JYPopMenuView *_popMenuView;
}
+ (instancetype)shareJYPopMenu {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popMenu = [[JYPopMenu alloc] init];
    });
    return popMenu;
}

- (void)showJYMenuWithTargetFrame:(CGRect)targetFrame WithTargetView:(UIView *)view WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(JYPopMenuDidSelectedBlock)block {
    BOOL isEqual = false;
    if (_popMenuView) {
        isEqual = CGRectEqualToRect(_popMenuView.getTargetFrame, targetFrame);
        [_popMenuView dismissJYMenu:YES];
        _popMenuView = nil;
    }
    if (isEqual) return;

    if (CGRectEqualToRect(_overlayFrame, CGRectZero)) {
        _popMenuView = [[JYPopMenuView alloc] init];
    } else {
        _popMenuView = [[JYPopMenuView alloc] initWithFrame:_overlayFrame];
    }
    [_popMenuView showJYMenuWithTargetFrame:targetFrame WithTargetView:view WithItemNameArray:itemNameArray withSelectedBlock:block];
}

- (void)showJYMenuWithTargetFrame:(CGRect)targetFrame WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(JYPopMenuDidSelectedBlock)block {
    BOOL isEqual = false;
    if (_popMenuView) {
        isEqual = CGRectEqualToRect(_popMenuView.getTargetFrame, targetFrame);
        [_popMenuView dismissJYMenu:YES];
        _popMenuView = nil;
    }
    if (isEqual) return;

    if (CGRectEqualToRect(_overlayFrame, CGRectZero)) {
        _popMenuView = [[JYPopMenuView alloc] init];
    } else {
        _popMenuView = [[JYPopMenuView alloc] initWithFrame:_overlayFrame];
    }
    [_popMenuView showJYMenuWithTargetFrame:targetFrame WithItemNameArray:itemNameArray withSelectedBlock:block];
}

- (void)dismissJYMenu:(BOOL)animated {

    [_popMenuView dismissJYMenu:animated];
    _popMenuView = nil;
    isShow = NO;
}
@end

@interface JYPopMenuView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIImageView *menuContainerView;
@property(nonatomic, strong) UITableView *menuTableView;
@property(nonatomic, assign) CGRect targetFrame;
@end

static const int JYMenuItemsHeight = 35;
static const int JYMenuItemsWidth = 80;
static const int JYMenuTableViewHSpace = 5;
static const int JYMenuTableViewVSpace = 5;
static const int arrowHeight = 5;

@implementation JYPopMenuView {
    NSMutableArray *_menuItems;
    UIView *_superView;
    CGFloat menuTableViewHeight;
}

- (id)init {
    if (self = [self initWithFrame:[[UIScreen mainScreen] bounds]]) {

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImageView *)menuContainerView {
    if (!_menuContainerView) {
        menuTableViewHeight = JYMenuItemsHeight * _menuItems.count + JYMenuTableViewVSpace;

        CGFloat x = CGRectGetMidX(_targetFrame) - (JYMenuItemsWidth + JYMenuTableViewHSpace * 2 + 4) / 2;
        CGFloat y = CGRectGetMinY(_targetFrame) - menuTableViewHeight - arrowHeight;
        CGFloat width = JYMenuItemsWidth + JYMenuTableViewHSpace * 2;
        CGFloat height = menuTableViewHeight + arrowHeight;

        _menuContainerView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];

        _menuContainerView.image = [[UIImage imageNamed:@"publicSessionMenu.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 5, 10, 5) resizingMode:UIImageResizingModeStretch];
        _menuContainerView.userInteractionEnabled = YES;
        _menuContainerView.layer.cornerRadius = 5.0f;
        _menuContainerView.clipsToBounds = YES;

        [_menuContainerView addSubview:self.menuTableView];
    }
    return _menuContainerView;
}

- (UITableView *)menuTableView {
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_menuContainerView.frame), menuTableViewHeight) style:UITableViewStylePlain];
        _menuTableView.delegate = self;
        _menuTableView.rowHeight = JYMenuItemsHeight;
        _menuTableView.dataSource = self;
        _menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _menuTableView.scrollEnabled = NO;
    }
    return _menuTableView;
}

- (void)showJYMenuWithTargetFrame:(CGRect)targetFrame WithTargetView:(UIView *)view WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(JYPopMenuDidSelectedBlock)block {
    _superView = view;
    if (!_superView)
        return;

    _menuItems = itemNameArray.mutableCopy;
    _targetFrame = targetFrame;
    _popMenuDidSelectedBlock = block;
    [self showJYMenu];
}

- (void)showJYMenuWithTargetFrame:(CGRect)targetFrame WithItemNameArray:(NSArray *)itemNameArray withSelectedBlock:(JYPopMenuDidSelectedBlock)block {
    _superView = [[UIApplication sharedApplication] keyWindow];

    _menuItems = itemNameArray.mutableCopy;
    _targetFrame = targetFrame;
    _popMenuDidSelectedBlock = block;
    [self showJYMenu];

}

- (void)showJYMenu {
    [self addSubview:self.menuContainerView];
    _menuContainerView.alpha = 0;

    CGRect toFrame = _menuContainerView.frame;
    _menuContainerView.frame = CGRectMake(CGRectGetMinX(_menuContainerView.frame), CGRectGetMinY(_targetFrame), CGRectGetWidth(_menuContainerView.frame), 1);
    [_superView addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        _menuContainerView.alpha = 1;
        _menuContainerView.frame = toFrame;
    }];
    isShow = YES;
}

- (void)dismissJYMenu:(BOOL)animated {
    if (_superView) {
        if (animated) {
            CGRect toFrame = CGRectMake(CGRectGetMinX(_menuContainerView.frame), CGRectGetMinY(_targetFrame), CGRectGetWidth(_menuContainerView.frame), 1);
            [UIView animateWithDuration:0.3 animations:^{
                _menuContainerView.alpha = 0;
                _menuContainerView.frame = toFrame;
            }                completion:^(BOOL finish) {
                [self removeFromSuperview];
            }];
        } else {
            [self removeFromSuperview];
        }
        isShow = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint localPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.menuTableView.frame, localPoint)) {
        [self hitTest:localPoint withEvent:event];
    } else {
        [self dismissJYMenu:YES];
    }
}

- (CGRect)getTargetFrame {
    return self.targetFrame;
}

#pragma mark tableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JYPopMenuTableCell *cell = (JYPopMenuTableCell *) [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell) cell = [[JYPopMenuTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];

    cell.JYTextLabel.font = [UIFont systemFontOfSize:12];
    cell.JYTextLabel.textAlignment = NSTextAlignmentCenter;
    cell.JYTextLabel.text = _menuItems[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _popMenuDidSelectedBlock(indexPath.row, _menuItems[indexPath.row]);
}
@end


@implementation JYPopMenuTableCell {

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //60-tableviewwidth 35-tableviewCell height
        self.JYTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, JYMenuItemsWidth + JYMenuTableViewHSpace * 2, JYMenuItemsHeight)];
        [self addSubview:_JYTextLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);

    //上分割线，
    CGContextSetStrokeColorWithColor(context, [UIColor groupTableViewBackgroundColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
}


@end
