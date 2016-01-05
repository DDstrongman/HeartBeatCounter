


#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

typedef void (^ZTypewriteEffectBlock)(void);

@interface ZTypewriteEffectLabel : UILabel
{
    SystemSoundID  soundID;
}

/** Z
 *	设置单个字打印间隔时间，默认 0.3 秒
 */
@property (nonatomic) NSTimeInterval typewriteTimeInterval;

/** Z
 *	开始打印的位置索引，默认为0，即从头开始
 */
@property (nonatomic) int currentIndex;

/** Z
 *	输入字体的颜色
 */
@property (nonatomic, strong) UIColor *typewriteEffectColor;

/** Z
 *	是否有打印的声音,默认为 YES
 */
@property (nonatomic) BOOL hasSound;

/** Z
 *	打印完成后的回调block
 */
@property (nonatomic, copy) ZTypewriteEffectBlock typewriteEffectBlock;

/** Z
 *  开始打印
 */
-(void)startTypewrite;

@end
