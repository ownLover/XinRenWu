//
//  XinZengViewController.h
//  MyBear
//
//  Created by 紫平方 on 16/10/11.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "BaseViewController.h"

@interface XinZengViewController : BaseViewController<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *tf;
@property(nonatomic,retain)NSString *nowFuQin;
@property(nonatomic,retain)NSDictionary *tempEditDic;
@property(nonatomic,retain)NSString *oldFuqin;
@property(nonatomic,assign)NSInteger nowCeng;
@property(nonatomic,assign)NSInteger selectIndex;
@property(nonatomic,assign)BOOL isEdit;
@end
