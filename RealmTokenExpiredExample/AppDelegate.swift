//
//  AppDelegate.swift
//  RealmTokenExpiredExample
//
//  Created by Jean-Baptiste Beau on 30/09/2021.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        Authentication.realmApp.syncManager.errorHandler = { error, session in
            let syncError = error as! SyncError
            
            print("SYNC ERROR: \(syncError)")
            
            switch syncError.code {
            case .clientResetError:
                break // here, handle client reset error
                
            case .clientUserError: // "expired refresh token" error, after 30 days
                Authentication.logout {
                    print("—————————————————————————————")
                    print("ISSUE 2:")
                    print("Now that we got the `expired refresh token` error and that we logged out the user, if you try to press `sign in` again, you will get the same error and be automatically logged out.")
                    print("—————————————————————————————")

                    if let window = application.windows.first,
                       let vc = window.rootViewController as? ViewController {
                        vc.updateLoginStateLabelAndButton()
                        vc.updateNumberObjectsLabel()
                    }
                }

            default:
                print("Non-recoverable realm sync error — \(syncError)")
            }

        }
        
        return true
    }

}

