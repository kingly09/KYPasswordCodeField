//
//  KYPasswordCodeField.m
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

#import "KYPasswordCodeField.h"
#import <Foundation/Foundation.h>



#define Space 5
#define LineWidth (self.frame.size.width - lineNum * 2 * Space)/lineNum
#define LineHeight 2

//下标线距离底部高度
#define LineBottomHeight 5

//密码风格 圆点半径
#define RADIUS 5

@interface NSString (Category)

- (CGSize)stringSizeWithFont:(UIFont *)font Size:(CGSize)size;

@end

@implementation NSString (Category)

//根据字符串的字体和size(此处size设置为字符串宽和MAXFLOAT)返回多行显示时的字符串size
- (CGSize)stringSizeWithFont:(UIFont *)font Size:(CGSize)size {
    
    CGSize resultSize;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7) {
        //段落样式
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        
        //字体大小，换行模式
        NSDictionary *attributes = @{NSFontAttributeName : font , NSParagraphStyleAttributeName : style};
        resultSize = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    } else {
        //计算正文的高度
        resultSize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
    }
    return resultSize;
}

@end

@interface KYPasswordCodeField () <UITextFieldDelegate>
{
    NSMutableArray *textArray;
    
    //线的条数
    NSInteger lineNum;

    UIColor *linecolor;
    UIColor *textcolor;
    UIFont *textFont;
    
    //观察者
    NSObject *observer;
    
}
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *underlineArr;
@end


@implementation KYPasswordCodeField

- (instancetype)initWithFrame:(CGRect)frame
                          num:(NSInteger)num
                    lineColor:(UIColor *)lColor
                     textFont:(CGFloat)font {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        textArray = [NSMutableArray arrayWithCapacity:num];
        
        lineNum = num;
        //数字样式是的颜色和线条颜色相同
        linecolor = textcolor = lColor;
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = lColor.CGColor;
        
        textFont = [UIFont boldSystemFontOfSize:font];
        
        
        _underLine_center_y = frame.size.height - LineBottomHeight - LineHeight/2;
        
        self.textField.delegate = self;
        
        _underLineAnimation = NO;
        _emptyEditEnd = NO;
        //设置的字体高度小于self的高
        NSAssert(textFont.lineHeight < self.frame.size.height, @"设置的字体高度应该小于self的高");
        
        //单击手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beginEdit)];
        [self addGestureRecognizer:tapGes];

    }
    
    return self;
}

- (void)setUnderLineAnimation:(BOOL)underLineAnimation {
    _underLineAnimation = underLineAnimation;
    if (underLineAnimation && !_hasUnderLine) {
        self.hasUnderLine = YES;
    }
}


- (void)setHasSpaceLine:(BOOL)hasSpaceLine {
    _hasSpaceLine = hasSpaceLine;
    if (hasSpaceLine) {
        [self addSpaceLine];
    }
}

- (void)setHasUnderLine:(BOOL)hasUnderLine {
    _hasUnderLine = hasUnderLine;
    if (hasUnderLine) {
        [self addUnderLine];
    }
}


#pragma mark - 添加通知
- (void)addNotification {
    //修复双击造成的bug
    if (observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }

    //开始输入
    [self addUnderLineAnimation];
    
    observer = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSInteger length = _textField.text.length;
        
        //改变数组，存储需要画的字符
        //通过判断textfield的长度和数组中的长度比较，选择删除还是添加
        if (length > textArray.count) {
            [textArray addObject:[_textField.text substringWithRange:NSMakeRange(textArray.count, 1)]];
        } else {
            [textArray removeLastObject];
        }
        
        //标记为需要重绘
        [self setNeedsDisplay];
        
        [self underLineHidden];
        
        [self addUnderLineAnimation];


        
        if (length == lineNum && self.EndEditBlcok) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.EndEditBlcok(_textField.text);
                [self emptyAndDisplay];
            });
        }
        if (length > lineNum) {
            _textField.text = [_textField.text substringToIndex:lineNum];
            [self emptyAndDisplay];

        }
    }];
}

//置空 重绘
- (void)emptyAndDisplay {
    [self endEdit];
    if (_emptyEditEnd) {
        _textField.text = @"";
        [textArray removeAllObjects];
        [self setNeedsDisplay];
        [self underLineHidden];
    }
    
    if (_noInputAni) {
        [self addUnderLineAnimation];
    }

}


#pragma mark - 下划线是否隐藏
- (void)underLineHidden {
    if (_hasUnderLine) {
        //判断底部的view隐藏还是显示
        for (NSInteger i = 0; i < lineNum; i ++) {
            CAShapeLayer *obj = [_underlineArr objectAtIndex:i];
            obj.hidden = i < textArray.count;
        }
    }
}


//键盘弹出
- (void)beginEdit {
    if (_textField == nil) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.hidden = YES;
        _textField.delegate = self;
        [self addSubview:_textField];
    }
    [self addNotification];
    [self.textField becomeFirstResponder];
    
}

- (void)endEdit {
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
    [_underlineArr makeObjectsPerformSelector:@selector(removeAnimationForKey:) withObject:@"kOpacityAnimation"];
    [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self endEdit];
}


- (void)setUnderLine_center_y:(CGFloat)underLine_center_y {
    _underLine_center_y = underLine_center_y;
    for (CAShapeLayer *layer in _underlineArr) {
        layer.frame = CGRectMake(CGRectGetMinX(layer.frame),
                                 _underLine_center_y - LineHeight/2,
                                 LineWidth,
                                 LineHeight);
    }
    
}


//添加下划线
- (void)addUnderLine {
    [self.underlineArr removeAllObjects];
    for (NSInteger i = 0; i < lineNum; i ++) {
        CAShapeLayer *line = [CAShapeLayer layer];
        line.frame = CGRectMake(Space * (2 *i + 1) + i * LineWidth, _underLine_center_y - LineHeight/2, LineWidth, LineHeight);
        line.fillColor = linecolor.CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:line.bounds];
        line.path = path.CGPath;
        line.hidden = textArray.count > i;
        [self.layer addSublayer:line];
        [self.underlineArr addObject:line];
    }
    
    if (!_noInputAni) {
        [self addUnderLineAnimation];
    }

}

//添加分割线
- (void)addSpaceLine {
    for (NSInteger i = 0; i < lineNum - 1; i ++) {
        CAShapeLayer *line = [CAShapeLayer layer];
        line.fillColor = linecolor.CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(self.frame.size.width/lineNum * (i + 1), 1, .5, self.frame.size.height - 1)];
        line.path = path.CGPath;
        line.hidden = NO;
        [self.layer addSublayer:line];
    }
}


#pragma mark - 懒加载
- (NSMutableArray *)underlineArr{
    if (_underlineArr == nil) {
        _underlineArr = [NSMutableArray array];
    }
    return _underlineArr;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    switch (_codeType) {
        case KYPasswordCodeFieldTypeCustom:
        {
            //画字
            //字的起点
        
            CGContextRef context = UIGraphicsGetCurrentContext();
            for (NSInteger i = 0; i < textArray.count; i ++) {
                NSString *num = textArray[i];
                CGFloat wordWidth = [num stringSizeWithFont:textFont Size:CGSizeMake(MAXFLOAT, textFont.lineHeight)].width;
                //起点
                CGFloat startX = self.frame.size.width/lineNum * i + (self.frame.size.width/lineNum - wordWidth)/2;
                
                [num drawInRect:CGRectMake(startX, (self.frame.size.height - textFont.lineHeight - LineBottomHeight - LineHeight)/2, wordWidth,  textFont.lineHeight + 5) withAttributes:@{NSFontAttributeName:textFont,NSForegroundColorAttributeName:textcolor}];
            }
            CGContextDrawPath(context, kCGPathFill);
        }
            break;
        case KYPasswordCodeFieldTypeSecret:
        {
            //画圆
            CGContextRef context = UIGraphicsGetCurrentContext();
            for (NSInteger i = 0; i < textArray.count; i ++) {
                //圆点
                CGFloat pointX = self.frame.size.width/lineNum/2 * (2 * i + 1);
                CGFloat pointY = self.frame.size.height/2;
                CGContextAddArc(context, pointX, pointY, RADIUS, 0, 2*M_PI, 0);//添加一个圆
                CGContextDrawPath(context, kCGPathFill);//绘制填充
            }
            CGContextDrawPath(context, kCGPathFill);
            
        }
            break;
        default:
            break;
    }

}



#pragma mark - 有下划线时,下划线的动画
- (void)addUnderLineAnimation {
    if (_underLineAnimation) {
        if (textArray.count >= lineNum) {
            return;
        }
        for (NSInteger i = 0; i < _underlineArr.count; i ++) {
            CAShapeLayer *line = _underlineArr[i];
            if (i == textArray.count) {
                [line addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
            } else {
                [line removeAnimationForKey:@"kOpacityAnimation"];
            }
        }
    }
}


- (CABasicAnimation *)opacityAnimation {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = .8;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}



@end
