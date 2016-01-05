//
//  TSAlertView.h
//
//  Created by Nick Hodapp aka Tom Swift on 1/19/11.
//


#import <UIKit/UIKit.h>
#import "appTime.h"

typedef enum 
{
	CHAlertViewButtonLayoutNormal,
	CHAlertViewButtonLayoutStacked
	
} CHAlertViewButtonLayout;

typedef enum
{
	CHAlertViewStyleNormal,
	CHAlertViewStyleInput,
	
} CHAlertViewStyle;

@class CHAlertViewController;
@class CHAlertView;

@protocol CHAlertViewDelegate <NSObject>

@optional
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(CHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)alertView:(CHAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex linkURL:(NSString *)linkURL;
// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(CHAlertView *)alertView;

- (void)willPresentAlertView:(CHAlertView *)alertView;  // before animation and showing view
- (void)didPresentAlertView:(CHAlertView *)alertView;  // after animation

- (void)alertView:(CHAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex; // before animation and hiding view
- (void)alertView:(CHAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation

@end

@interface CHAlertView : UIView<CHAlertViewDelegate>
{
	UIImage*				_backgroundImage;
	UILabel*				_titleLabel;
	UILabel*				_messageLabel;
	UITextView*				_messageTextView;
	UIImageView*			_messageTextViewMaskImageView;
	UITextField*			_inputTextField;
	NSMutableArray*			_buttons;
    appTime*                appActiveCount;
}
@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *message;
@property(nonatomic, assign) id<CHAlertViewDelegate> delegate;
@property(nonatomic) NSInteger cancelButtonIndex;
@property(nonatomic, readonly) NSInteger firstOtherButtonIndex;
@property(nonatomic, readonly) NSInteger numberOfButtons;
@property(nonatomic, readonly, getter=isVisible) BOOL visible;

@property(nonatomic, assign) CHAlertViewButtonLayout buttonLayout;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat maxHeight;
@property(nonatomic, assign) BOOL usesMessageTextView;
@property(nonatomic, retain) UIImage* backgroundImage;
@property(nonatomic, assign) CHAlertViewStyle style;
@property(nonatomic, readonly) UITextField* inputTextField;

@property (nonatomic, retain) NSString *linkUrl;

//- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
//- (NSInteger)addButtonWithTitle:(NSString *)title;
//- (NSString *)buttonTitleAtIndex:(NSInteger)buttonIndex;
//- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;
//- (void)show;
- (void)showAlert:(NSString*)Appidentifier;

@end




