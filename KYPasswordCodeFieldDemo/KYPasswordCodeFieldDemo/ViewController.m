//
//  ViewController.m
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
// THE SOFTWARE.

#import "ViewController.h"
#import "KYPasswordCodeField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
  [self addView];
  
}


- (void)addView {
  
  NSArray *arr = @[@"普通，下划线 分割线",
                   @"普通，下划线",
                   @"密码",
                   @"密码，分割线"];
  for (NSInteger i = 0; i < arr.count; i ++) {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30 + 110 * i, self.view.frame.size.width, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = arr[i];
    [self.view addSubview:label];
    
    KYPasswordCodeField *v;
    
    
    if (i == 3) {
    
      v = [[KYPasswordCodeField alloc] initWithFrame:CGRectMake(30, 80 + 112 * i, self.view.frame.size.width - 60, 60)
                                                 num:4
                                           lineColor:[UIColor blackColor]
                                            textFont:50];
    }else{
      
      v = [[KYPasswordCodeField alloc] initWithFrame:CGRectMake(30, 80 + 110 * i, self.view.frame.size.width - 60, 60)
                                                 num:6
                                           lineColor:[UIColor blackColor]
                                            textFont:50];
    }
    
    
    switch (i) {
      case 0:
      {
        //下划线
        // v.hasUnderLine = YES;
        //分割线
        v.hasSpaceLine = YES;
        //输入之后置空
        v.emptyEditEnd = YES;
        v.underLineAnimation = YES;
        //输入风格
        v.passwordCodeFieldType = KYPasswordCodeFieldTypeCustom;
      }
        break;
      case 1:
      {
        //下划线
        v.hasUnderLine = YES;
        //分割线
        v.hasSpaceLine = NO;
        
        //输入风格
        v.passwordCodeFieldType = KYPasswordCodeFieldTypeCustom;
      }
        break;
      case 2:
      {
        //下划线
        v.hasUnderLine = NO;
        //分割线
        v.hasSpaceLine = NO;
        
        //输入风格
        v.passwordCodeFieldType = KYPasswordCodeFieldTypeSecret;
      }
        break;
      case 3:
      {
        //下划线
        v.hasUnderLine = NO;
        //分割线
        v.hasSpaceLine = YES;
        
        //输入风格
        v.passwordCodeFieldType = KYPasswordCodeFieldTypeSecret;
      }
        break;
      default:
        break;
    }
    
    
    v.EndEditBlcok = ^(NSString *str) {
      NSLog(@"%@",str);
    };
    [self.view addSubview:v];
  }
}



- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
