#import <FSSwitchDataSource.h>
#import <FSSwitchPanel.h>

#import <SpringBoard/SpringBoard.h>

@interface RingerSwitch : NSObject <FSSwitchDataSource>
@end

@implementation RingerSwitch

static void RingerSettingsChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    [[FSSwitchPanel sharedPanel] stateDidChangeForSwitchIdentifier:@"com.a3tweaks.switch.ringer"];
}

__attribute__((constructor))
static void constructor(void)
{
    CFNotificationCenterRef center = CFNotificationCenterGetDarwinNotifyCenter();
    CFNotificationCenterAddObserver(center, NULL, RingerSettingsChanged, CFSTR("com.apple.springboard.ringerstate"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	return ![[%c(SBMediaController) sharedInstance] isRingerMuted];
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	if (newState == FSSwitchStateIndeterminate)
		return;
	[[%c(SBMediaController) sharedInstance] setRingerMuted:!newState];
}

@end
