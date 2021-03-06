//
//  AppDelegate.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/17/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    RealmMigrations().handle()
    Fabric.with([Crashlytics.self])
    
    RootRouter().showAdminScreen()
    /*if let _ = BetaUser.me {
      RootRouter().showBetaLoggedInScreen()
      Shift.endCurrentShift(usingTime: nil) // Just in case the app crashed or something
    } else {
      RootRouter().showBetaLaunchScreen()
    }*/
    
//    DropboxClientsManager.setupWithAppKey("t0phm00v4im3xah")
//    secret: ae2heu8094z7juj
//    key: t0phm00v4im3xah
//    token: ZyAGRv-nREEAAAAAAACVRXmPf0uESzSfB9loGgPK7EYYAuc_ZDM3T7UlGTYKpwAm
    
    //full access app
    DropboxClientsManager.setupWithAppKey("x6ej5ws9kbt0u8g")
    
    crashlyticsSetupUser()
    
    return true
  }

  func crashlyticsSetupUser() {
    // You can call any combination of these three methods
    Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
    Crashlytics.sharedInstance().setUserIdentifier("12345")
    Crashlytics.sharedInstance().setUserName("Test User")
  }

  func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    if let authResult = DropboxClientsManager.handleRedirectURL(url) {
      switch authResult {
      case .success:
        print("Success! User is logged into Dropbox.")
      case .cancel:
        print("Authorization flow was manually canceled by user!")
      case .error(_, let description):
        print("Error: \(description)")
      }
    }
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    self.saveContext()
  }

  // MARK: - Split view

//  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
//      guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
//      guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
//      if topAsDetailController.detailItem == nil {
//          // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//          return true
//      }
//      return false
//  }
  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
      */
      let container = NSPersistentContainer(name: "Griffy")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
          if let error = error as NSError? {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               
              /*
               Typical reasons for an error here include:
               * The parent directory does not exist, cannot be created, or disallows writing.
               * The persistent store is not accessible, due to permissions or data protection when the device is locked.
               * The device is out of space.
               * The store could not be migrated to the current model version.
               Check the error message to determine what the actual problem was.
               */
              fatalError("Unresolved error \(error), \(error.userInfo)")
          }
      })
      return container
  }()

  // MARK: - Core Data Saving support

  func saveContext () {
      let context = persistentContainer.viewContext
      if context.hasChanges {
          do {
              try context.save()
          } catch {
              // Replace this implementation with code to handle the error appropriately.
              // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
      }
  }

}

