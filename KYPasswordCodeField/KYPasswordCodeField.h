//
//  KYPasswordCodeField.h
//  KYPasswordCodeFieldDemo
//
//  Created by kingly on 2017/12/3.
//  Copyright © 2017年 KYPasswordCodeField Software (https://github.com/kingly09/KYPasswordCodeField ) by kingly inc.  

//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE. All rights reserved.
//

#import <UIKit/UIKit.h>

// 密码的样式
typedef NS_ENUM(NSInteger,KYPasswordCodeFieldType) {
    KYPasswordCodeFieldTypeCustom, //普通样式
    KYPasswordCodeFieldTypeSecret  //密码风格
};

/**
 * 自定义分割 密码/验证码输入框
 */
@interface KYPasswordCodeField : UIView

// 输入完成Block回调
@property (nonatomic, copy) void(^EndEditBlcok)(NSString *text);

// 样式
@property (nonatomic, assign) KYPasswordCodeFieldType passwordCodeFieldType;

// 是否需要分隔符
@property (nonatomic, assign) BOOL hasSpaceLine;
// 是否有下标线
@property (nonatomic, assign) BOOL hasUnderLine;

// 是否需要输入之后清空，再次输入使用,默认为NO
@property (nonatomic, assign) BOOL emptyEditEnd;

// 是否添加下划线的动画,默认NO
@property (nonatomic, assign) BOOL underLineAnimation;

// 在underLineAnimation为YES时，未输入状态下是否闪烁，YES为闪烁 NO不闪烁
@property (nonatomic, assign) BOOL noInputAni;

//下划线中心点
@property (nonatomic, assign) CGFloat underLine_center_y;

- (instancetype)initWithFrame:(CGRect)frame
                          num:(NSInteger)num
                    lineColor:(UIColor *)lColor
                     textFont:(CGFloat)font;

- (void)beginEdit;
- (void)endEdit;

@end
