//
//  SimpleViewController.m
//  练练看
//
//  Created by 王奥东 on 16/11/23.
//  Copyright © 2016年 王奥东. All rights reserved.
//

#import "SimpleViewController.h"
#import "SetViewController.h"


#define Row 8 //行数
#define Colum 6 //列数
#define Width 50 //每个Button的边长



@interface SimpleViewController ()

@end

@implementation SimpleViewController {
    int _map[Row][Colum];
    SetViewController *_set;
    UIButton *_lastButton;//上一次点击的button
    UIButton *_currentButton;//当前点击的button
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//获取按钮的x，y坐标
-(int)getXFromButtonTag:(NSInteger)tag {
    int m;
    if (tag%6 == 0) {
        m = 5;
    }else {
        m = tag%6-1;
    }
    return m;
}

-(int)getYFromButtonTag:(NSInteger)tag {
    NSInteger m;
    if (tag%6 == 0) {
        m = tag/6-1;
    }else {
        m = tag/6;
    }
    return (int)m;
}

//检查第一个坐标到第二个坐标的路径上是否有别的按钮
//同行
-(BOOL)checkPathWithX1:(int)x1 andX2:(int)x2 throughY:(int)y {
    for (int i = x1+1; i<x2; i++) {
        if (_map[y][i] == 1) {
            return NO;
        }
    }
    return YES;
}
//同列
-(BOOL)checkPathWithY1:(int)y1 andY2:(int)y2 throughX:(int)x {
    for (int i = y1+1; i<y2; i++) {
        if (_map[i][x] == 1) {
            return NO;
        }
    }
    return YES;
}

//判断消除路径是否正确
//此方法中我们限定所有的判断都是根据坐标点，从上到下，从左到右的顺序进行的，这样便于操作。
/**
    
    注意：已经过判断让y2小于y1
 
    先判断两个按钮是为同一个，在判断是否为同一行。
    同一行如果是第一行或最后一行可以消除，如果不是就判断路径
    再判断判断是否为同一列。
    同一列如果是第一列或最后一列可以消除，如果不是就判断路径
    如果都不是，就判断第一个按钮是否在第一行第一列 
 
 在判断是否为第一行，而后是第一列
 
 因为y2小于y1是判断后的限制条件，所以在判断第二个按钮是否为最后一行最后一列
 在判断是否为最后一行、而后是最后一列
 
 都不是，分第二个按钮在第一个按钮的右下角来判断
 而后是左下角判断
 */
-(BOOL)canPassFromLastButton:(UIButton *)lastButton ToCurrentButton:(UIButton *)currentButton
{
    //在这里要根据tag值得到两点击点的坐标。
    int x1 = [self getXFromButtonTag:lastButton.tag];
    int y1 = [self getYFromButtonTag:lastButton.tag];//第一个点的横纵坐标。
    int x2 = [self getXFromButtonTag:currentButton.tag];
    int y2 = [self getYFromButtonTag:currentButton.tag];//第二个点的横纵坐标。
 
    //判断是不是同一个点
    if (x1==x2&&y1==y2) {  //同一个点当然不能消掉。
        return NO;
    }else if (y1 == y2) {  //如果同一行。
        if ((y1 == 0) || (y1 == Row-1)) {  //第一行或是最后一行的可以消除
            return YES;
        }else {
            //判断这一行的这两个点之间有没有别的button；需要写一个方法。
            if ([self checkPathWithX1:x1 andX2:x2 throughY:y1]) {
                //不是第一行或最后一行
                //但是同一行且中间没有别的按钮则可以消除
                return YES;
            }
            //判断两个拐点的情形。
            for (int i=0; i<Row; i++) {
                //第一次选中的按钮的y坐标
                if (i<y1) {
                    //检查的方法里会加1，所以这里输入的坐标要减1
                    
                    //在同一行上，x1列上，从0到此按钮的路径上没有别的按钮
                    //并且，x2列上，从0到此按钮的路径上没有别的按钮
                    //则两个按钮在同一行且上方都没有按钮，满足消除条件
                    /**
                      c   - - - - - -   c
                      c  |  c c c c  |  c
                      c  a  c c c c  b  c
                     */
                    if ([self checkPathWithY1:-1 andY2:y1 throughX:x1]&&[self checkPathWithY1:-1 andY2:y2 throughX:x2]) {
                        return YES;
                    }
                    //同一行上，第一个按钮到当前按钮右侧那个按钮的中间路径上没有别的按钮存在，也就是第一个按钮能到第二个按钮
                    //某一行上的y能够到达第一个按钮与第二个按钮
                    //灵魂图示：
                    /**
                     c c c c c c c c c
                    c  - - - - - - -  c
                    c | c c c c c c | c
                    c | c c c c c c | c
                    c a c c c c c c b c

                     */
                    if ([self checkPathWithX1:x1-1 andX2:x2+1 throughY:i]&&[self checkPathWithY1:i-1 andY2:y1 throughX:x1]&&[self checkPathWithY1:i-1 andY2:y2 throughX:x2]) {
                        return YES;
                    }
                }else if(i>y1){
                    /**
                    c a  c c c c  b c
                    c |  c c c c  | c
                    c  - - - - - -  c
                     只是反了过来
                     */
                    
                    if ([self checkPathWithY1:y1 andY2:Row throughX:x1]&&[self checkPathWithY1:y2 andY2:Row throughX:x2]) {
                        return YES;
                    }
                    /**
                     c a c c c c c c b c
                     c | c c c c c c | c
                     c | c c c c c c | c
                     c  - - - - - - -  c
                      c c c c c c c c c
                     同上
                     */
                    
                    if ([self checkPathWithY1:y1 andY2:i+1 throughX:x1]&&[self checkPathWithY1:y2 andY2:i+1 throughX:x2]&&[self checkPathWithX1:x1-1 andX2:x2+1 throughY:i]) {
                        return YES;
                    }
                }
            }
            
        }
        
        
    }
    else if (x1 == x2) {   //如果同一列。
        if ((x1==0)||(x1==Colum-1)) {  //第一列或是最后一列的。
            return YES;
        }else {
            //判断这一列的这两个点之间有没有别的button;这里就是没有拐点，直连得的情况。
            if ([self checkPathWithY1:y1 andY2:y2 throughX:x1]) {
                //y1小于y2总是成立的。
                return YES;
            }
            //判断两个拐点的情形。
            for (int i=0; i<Colum; i++) {
                if (i<x1) {
                    
                    //如灵魂画手的图示：
                    /**
                        c c c
                         -a c
                        | c c
                        | c c
                        | c c
                         -b c
                        c c c
                     */
                    
                    
                    if ([self checkPathWithX1:-1 andX2:x1 throughY:y1]&&[self checkPathWithX1:-1 andX2:x2 throughY:y2]) {
                        return YES;
                    }
                    
                    /**
                     
                    c c  c c c
                    c  - a c c
                    c |  c c c
                    c |  c c c
                    c |  c c c
                    c  - b c c
                    c c  c c c
                     
                     */
                    
                    if ([self checkPathWithX1:i-1 andX2:x1 throughY:y1]&&[self checkPathWithX1:i-1 andX2:x2 throughY:y2]&&[self checkPathWithY1:y1-1 andY2:y2+1 throughX:i]) {
                        return YES;
                    }
                }else if(i>x1){
                    
                    /**
                        上面的图左右翻过来
                     
                     */
                    
                    
                    if ([self checkPathWithX1:x1 andX2:Colum throughY:y1]&&[self checkPathWithX1:x2 andX2:Colum throughY:y2]) {
                        return YES;
                    }
                    if ([self checkPathWithY1:y1-1 andY2:y2+1 throughX:i]&&[self checkPathWithX1:x1 andX2:i+1 throughY:y1]&&[self checkPathWithX1:x2 andX2:i+1 throughY:y2]) {
                        return YES;
                    }
                }
            }
        }
        
    }
    else {  //既不同一行也不是同一列，这样就得分为一个拐点跟两个拐点来考虑。
        //如果第二个点在第一个点的右下角。
        if (x1<x2) {
            /**
             两种情况：
             
              c  a - - -   c c c c
              c  c c c c | c c c c
              c  c c c c | c c c c
              c  c c c c  - - -b c
               
              c c c c c c c
              c c a c c c c
              c c | c c c c
              c c | c c c c
              c c  - - - -
              c c  c c c  |
              c c  c c c  |
              c c  c c c  b
             */
            
            if (([self checkPathWithY1:y1-1 andY2:y2 throughX:x2]&&[self checkPathWithX1:x1 andX2:x2+1 throughY:y1])||([self checkPathWithY1:y1 andY2:y2+1 throughX:x1]&&[self checkPathWithX1:x1-1 andX2:x2 throughY:y2])) {
                return YES;
            }
            //第一种情况是：第一个点位于第1行第1列
            if (x1==0 && y1==0) {
                /**
                 - a c c c
                |  c c c c
                |  c c c c
                |  c c c c
                 - - b c c
                 c c c c c
                 */
                if ([self checkPathWithX1:x1-1 andX2:x2 throughY:y2]) {
                    return YES;
                }
                /**
                
                 a -   c c
                 c c | c c
                 c c | c c
                 c c b c c
                 c c c c c
                 
                 */
                if ([self checkPathWithY1:y1-1 andY2:y2 throughX:x2]) {
                    return YES;
                }
                
            }else if (x1 == 0){  //第一个点位于第1列
                //同上
                if ([self checkPathWithX1:x1-1 andX2:x2 throughY:y2]) {
                    return YES;
                }
            }else if (y1 == 0){  //第一个点位于第1行
                //同上
                if ([self checkPathWithY1:y1-1 andY2:y2 throughX:x2]) {
                    return YES;
                }
            }
            if (x2==Colum-1&&y2==Row-1) { //判断第二个点的位置为最后一行最后一列
                /**
                c c c c c
                c c a c c
                c c | c c
                c c | c c
                c c | c b
                      -
                 */
                
                if ([self checkPathWithY1:y1 andY2:y2+1 throughX:x1]) {
                    return YES;
                }
                
                /**
                 c c c c c
                 c c a - - -
                 c c c c c  |
                 c c c c c  |
                 c c c c b -
                 */
                
                
                if ([self checkPathWithX1:x1 andX2:x2+1 throughY:y1]) {
                    return YES;
                }
            }else if (x2==Colum-1){
                /**
                 c c c c c
                 c c a - - -
                 c c c c c  |
                 c c c c c  |
                 c c c c b -
                 c c c c c
                 */
                
                if ([self checkPathWithX1:x1 andX2:x2+1 throughY:y1]) {
                    return YES;
                }
            }else if (y2==Row-1){
                
                /**
                 c c c c c c
                 c c a c c c
                 c c | c c c
                 c c | c c c
                 c c | c b c
                     |   |
                       -
                 */
                
                if ([self checkPathWithY1:y1 andY2:y2+1 throughX:x1]) {
                    return YES;
                }
            }
            //两个按钮都不在最后一行或最后一列
            //下面进行两个拐点的判断的写法。
            for (int i=0; i<Colum; i++) {  //横向的比较。
                if (i<x1) {
                    /**
                     c c  c c c
                       -  a c c
                    |c c  c c c
                    |c c  c c c
                    |c c  c c c
                       -  b c c
                     c c  c c c
                     
                     */
                    if ([self checkPathWithX1:-1 andX2:x1 throughY:y1]&&[self checkPathWithX1:-1 andX2:x2 throughY:y2]) {
                        return YES;
                    }
            
                    
                    /**
                     c c c c c
                     c a c c c
                     c | _   c
                     c c c | c
                     c c c b c
                     c c c c c
                     */
                    
                    if ([self checkPathWithX1:i-1 andX2:x1 throughY:y1]&&[self checkPathWithX1:i-1 andX2:x2 throughY:y2]&&[self checkPathWithY1:y1-1 andY2:y2+1 throughX:i]) {
                        return YES;
                    }
                }else if (i>x1&&i<x2){
                    
                    
                    /**
                     c c c c c
                     c a -   c
                     c c c | c
                     c c c | c
                     c c c b c
                     c c c c c
                     */
                    if ([self checkPathWithX1:x1 andX2:i+1 throughY:y1]&&[self checkPathWithX1:i-1 andX2:x2 throughY:y2]&&[self checkPathWithY1:y1-1 andY2:y2+1 throughX:i]) {
                        return YES;
                    }
                }else if (i>x2){
                    /**
                     
                     c c c c c
                     c c a - -
                     c c c c c |
                     c c c b -
                     c c c c c
                     */
                    if ([self checkPathWithX1:x1 andX2:Colum throughY:y1]&&[self checkPathWithX1:x2 andX2:Colum throughY:y2]) {
                        return YES;
                    }
                    
                    /**
                     
                     c c c c c c c
                     c c a - -   c
                     c c c c c | c
                     c c c b -   c
                     c c c c c c c
                     */
                    if ([self checkPathWithX1:x1 andX2:i+1 throughY:y1]&&[self checkPathWithX1:x2 andX2:i+1 throughY:y2]&&[self checkPathWithY1:y1-1 andY2:y2+1 throughX:i]) {
                        return  YES;
                    }
                }
            }
            //下面进行纵向的比较。
            for (int i = 0; i<Row; i++) {
                if (i<y1) {
                    /**    
                             -
                     c c c | c | c
                     c c c a c | c
                     c c c c c | c
                     c c c c c b c
                     
                     */
                    if ([self checkPathWithY1:-1 andY2:y1 throughX:x1]&&[self checkPathWithY1:-1 andY2:y2 throughX:x2]) {
                        return YES;
                    }
                    /**
                     c c c   -   c
                     c c c | c | c
                     c c c a c | c
                     c c c c c | c
                     c c c c c b c
                     
                     */
                    
                    if ([self checkPathWithY1:i-1 andY2:y1 throughX:x1]&&[self checkPathWithY1:i-1 andY2:y2 throughX:x2]&&[self checkPathWithX1:x1-1 andX2:x2+1 throughY:i]) {
                        return YES;
                    }
                }else if (i>y1&&i<y2){
                    
                    /**
                     c c c c c c
                     c c a c c c
                     c c | c c c
                     c c | _   c
                     c c c c | c
                     c c c c b c
                     c c c c c c
                     */
                    
                    if ([self checkPathWithY1:y1 andY2:i+1 throughX:x1]&&[self checkPathWithY1:i-1 andY2:y2 throughX:x2]&&[self checkPathWithX1:x1-1 andX2:x2+1 throughY:i]) {
                        return YES;
                    }
                }else if(i>y2){
                    /**
                     c c c c c c
                     c c a c c c
                     c c | c c c
                     c c | c c c
                     c c | c c c
                     c c | c b c
                     c c | c | c
                     c c  - -  c
                     */
                    if ([self checkPathWithY1:y1 andY2:Row throughX:x1]&&[self checkPathWithY1:y2 andY2:Row throughX:x2]) {
                        return YES;
                    }
                    /**
                     c c c c c c
                     c c a c c c
                     c c | c c c
                     c c | c c c
                     c c | c c c
                     c c | c b c
                     c c | c | c
                     c c  - -  c
                     c c c c c c
                     */
                    
                    if ([self checkPathWithY1:y1 andY2:i+1 throughX:x1]&&[self checkPathWithY1:y2 andY2:i+1 throughX:x2]&&[self checkPathWithX1:x1-1 andX2:x2+1 throughY:i]) {
                        return YES;
                    }
                }
            }
        }
        //第二个点在第一个点的左下角
        //y1小于y2总是成立的。
        if (x1>x2) {
            //到这里不用再画了吧。。
            if (([self checkPathWithY1:y1 andY2:y2+1 throughX:x1]&&[self checkPathWithX1:x2 andX2:x1+1 throughY:y2])||([self checkPathWithY1:y1-1 andY2:y2 throughX:x2]&&[self checkPathWithX1:x2-1 andX2:x1 throughY:y1])) {
                return YES;
            }
            if (x1==Colum-1&&y1==0) {
                if ([self checkPathWithX1:x2 andX2:x1+1 throughY:y2]) {
                    return YES;
                }
                if ([self checkPathWithY1:y1-1 andY2:y2 throughX:x2]) {
                    return YES;
                }
            }else if (x1==Colum-1){
                if ([self checkPathWithX1:x2 andX2:x1+1 throughY:y2]) {
                    return YES;
                }
            }else if (y1==0){
                if ([self checkPathWithY1:y1-1 andY2:y2 throughX:x2]) {
                    return YES;
                }
            }
            if (x2==0&&y2==Row-1) {
                if ([self checkPathWithY1:y1 andY2:y2+1 throughX:x1]) {
                    return YES;
                }
                if ([self checkPathWithX1:x2-1 andX2:x1 throughY:y1]) {
                    return YES;
                }
            }else if(x2==0) {
                if ([self checkPathWithX1:x2-1 andX2:x1 throughY:y1]) {
                    return YES;
                }
            }else if(y2==Row-1) {
                if ([self checkPathWithY1:y1 andY2:y2+1 throughX:x1]) {
                    return YES;
                }
            }
            //判断两个拐点的情形。
            for (int i=0; i<Colum; i++) {
                if (i<x2) {
                    if ([self checkPathWithX1:-1 andX2:x1 throughY:y1]&&[self checkPathWithX1:-1 andX2:x2 throughY:y2]) {
                        return YES;
                    }
                    if ([self checkPathWithX1:i-1 andX2:x1 throughY:y1]&&[self checkPathWithX1:i-1 andX2:x2 throughY:y2]&&[self checkPathWithY1:y1-1 andY2:y2+1 throughX:i]) {
                        return YES;
                    }
                }else if(i>x2&&i<x1){
                    if ([self checkPathWithX1:x2 andX2:i+1 throughY:y2]&&[self checkPathWithX1:i-1 andX2:x1 throughY:y1]&&[self checkPathWithY1:y1-1 andY2:y2+1 throughX:i]) {
                        return YES;
                    }
                }else if(i>x1){
                    if ([self checkPathWithX1:x1 andX2:Colum throughY:y1]&&[self checkPathWithX1:x2 andX2:Colum throughY:y2])
                    {
                        return YES;
                    }
                    if ([self checkPathWithY1:y1-1 andY2:y2+1 throughX:i]&&[self checkPathWithX1:x1 andX2:i+1 throughY:y1]&&[self checkPathWithX1:x2 andX2:i+1 throughY:y2]) {
                        return YES;
                    }
                }
            }
            //在进行纵向判断。
            for (int i = 0; i<Row; i++) {
                if (i<y1) {
                    if ([self checkPathWithY1:-1 andY2:y1 throughX:x1]&&[self checkPathWithY1:-1 andY2:y2 throughX:x2]) {
                        return YES;
                    }
                    if ([self checkPathWithY1:i-1 andY2:y2 throughX:x2]&&[self checkPathWithY1:i-1 andY2:y1 throughX:x1]&&[self checkPathWithX1:x2-1 andX2:x1+1 throughY:i]) {
                        return YES;
                    }
                }else if(i>y1&&i<y2){
                    if ([self checkPathWithY1:i-1 andY2:y2 throughX:x2]&&[self checkPathWithY1:y1 andY2:i+1 throughX:x1]&&[self checkPathWithX1:x1-1 andX2:x2+1 throughY:i]) {
                        return YES;
                    }
                }else if (i>y2){
                    if ([self checkPathWithY1:y1 andY2:Row throughX:x1]&&[self checkPathWithY1:y2 andY2:Row throughX:x2]) {
                        return YES;
                    }
                    if ([self checkPathWithY1:y2 andY2:i+1 throughX:x2]&&[self checkPathWithY1:y1 andY2:i+1 throughX:x1]&&[self checkPathWithX1:x1-1 andX2:x2+1 throughY:i]) {
                        return YES;
                    }
                }
            }
            
        }
    }
    
    return NO;
}
#pragma mark - selector Methods;
//此方法用来触发当点击到水果时的方法。
//先判断图片相等后判断路径是否相等
-(void)buttonClicked:(UIButton *)sender{
    if (_currentButton == nil) {
        //第一次点击
        _currentButton = sender;
        _currentButton.backgroundColor = [UIColor orangeColor];
    }else {
        _lastButton = _currentButton;
        _currentButton = sender;
        if ([_currentButton.currentBackgroundImage isEqual:_lastButton.currentBackgroundImage]) {
            //判断这次跟上次点击的是不是同一种水果
            //如果是，就判断两者之间是否走得通
            UIButton *firstButton;
            UIButton *secondButton;
            if (_lastButton.tag < _currentButton.tag) {
                //在这里限定通过tag值小的到tag值大的找路径
                //也就是保证上面代码中所说的y1<y2
                firstButton = _lastButton;
                secondButton = _currentButton;
            }else {
                firstButton = _currentButton;
                secondButton = _lastButton;
            }
            //判断消除路径是否正确
            if ([self canPassFromLastButton:firstButton ToCurrentButton:secondButton]) {
                //如果消除路径正确
                //根据tag值得到两点击点的坐标
                int x1 = [self getXFromButtonTag:_lastButton.tag];
                int y1 = [self getYFromButtonTag:_lastButton.tag];//第一个点的横纵坐标
                
                int x2 = [self getXFromButtonTag:_currentButton.tag];
                int y2 = [self getYFromButtonTag:_currentButton.tag];//第二个点的横纵坐标
                
                _map[y1][x1] = 0;
                _map[y2][x2] = 0;
                
                [_lastButton removeFromSuperview];
                [_currentButton removeFromSuperview];
                _lastButton = nil;
                _currentButton = nil;
            }else {
                //如果不正确
                _lastButton.backgroundColor = [UIColor clearColor];
                _lastButton = nil;
                _currentButton.backgroundColor = [UIColor orangeColor];
            }
        }else {
            //如果两个图片不相等
            _lastButton.backgroundColor = [UIColor clearColor];
            _lastButton = nil;
            _currentButton.backgroundColor = [UIColor orangeColor];
        }
    }
}

#pragma mark - View lifecycle

//为保证图片生成是偶数，则限制总共有48张图片，8种图片每种6个即可。
-(void)loadView {
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    [aView setBackgroundColor:[UIColor greenColor]];
    self.view = aView;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(260, 548, 50, 18);
    [back setTitle:@"back" forState:UIControlStateNormal];
    back.titleLabel.font = [UIFont systemFontOfSize:20];
    [back setBackgroundColor:[UIColor blackColor]];
    [back addTarget:self action:@selector(anniu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    //所有的图片都要用button来表示，下面将界面搭建好
    for (int i = 0; i< Row; i++) {
        for (int  j =0; j < Colum; j++) {
            _map[i][j] = 1;//初始化数组，刚开始为1，如果点击消失后，都变成0
            UIButton *animalButton = [UIButton buttonWithType:UIButtonTypeCustom];
            animalButton.frame = CGRectMake(10+j*Width, 10+i*Width, Width, Width);
            //当前行乘总列+当前列+1，避免tag为0的尴尬
            animalButton.tag = i*Colum + j+1;
            [self.view addSubview:animalButton];
            [animalButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //大体框架弄好了，还需要考虑的是每种水果的数量必需是偶数的，这样才能保证到最后所有的水果都能消掉。
    //因为简单系统中水果的名称是从0到7,所以我们可以弄一个随机数随机产生0－7之间的数，用来表示水果。
    int randomNumber;
    int animal[8];
    //默认初始值都是0
    for (int i = 0; i<8; i++) {
        animal[i] = 0;
    }
    //设置按钮内容
    for (int i = 1; i <= Row*Colum; i++) {
        randomNumber = arc4random()%8;//这样的话，不能保证每种图片都是偶数。所以用一个数组来记录每种图片已经摆放了几个。
        animal[randomNumber]++;//每生成一个随机数，该数组加1，然后判断是否超过了最大数六个
        if (animal[randomNumber] < 7) {
            [((UIButton *)[self.view viewWithTag:i]) setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"bg%d",randomNumber]] forState:UIControlStateNormal];
        }else {
            i--;//如果这轮产生的图片超出了原定的数量则还需要重复。
        }
    }
    _lastButton = nil;
}




-(void)anniu:(id)sender{
    CATransition *transion = [CATransition animation];
    transion.type = kCATransitionMoveIn;
    transion.duration = 2.0;
    _set = [self.storyboard instantiateViewControllerWithIdentifier:@"aaa"];
    [self.view addSubview:_set.view];
    [self.view.layer addAnimation:transion forKey:@""];
}

@end
