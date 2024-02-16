//
//  AppDelegate.h
//  Weedalyzer
//
//  Created by Griffin Freudenberg on 2/15/24.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

