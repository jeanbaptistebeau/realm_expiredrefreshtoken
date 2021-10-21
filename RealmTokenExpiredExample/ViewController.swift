//
//  ViewController.swift
//  RealmTokenExpiredExample
//
//  Created by Jean-Baptiste Beau on 30/09/2021.
//

import UIKit
import RealmSwift

/*
 
 Issue 1: Realm folder doesn't get deleted after user.remove
 Issue 2: After getting `expired refresh token`, it's not possible to log back the user in without getting this error again and again
 
 Steps to reproduce:
 
 1. Change the realm app ID in Authentication.swift
 2. Run the app
 3. Press register to create the user
 4. Press sign in
 5. Now the app should be working fine, you can add objects, log out and login again
 6. Quit the app
 7. Now go to the device settings > General > Date and time and set it manually to 2 months in the future
 8. Run the app again
 9. You should get the "expired refresh token" error and thus be logged out of your account
 10. Try pressing sign in: from now on, you should get the same error everytime you log in
 
 */

class ViewController: UIViewController {
    
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var registerButton: UIButton!

    @IBOutlet var numberObjectsLabel: UILabel!
    @IBOutlet var loginStateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLoginStateLabelAndButton()
        updateNumberObjectsLabel()
    }

    @IBAction func signInWasPressed(_ sender: Any) {
        if Authentication.isLoggedIn {
            Authentication.logout {
                self.updateLoginStateLabelAndButton()
                self.updateNumberObjectsLabel()
            }
        }
        else {
            Authentication.login {
                self.updateLoginStateLabelAndButton()
                self.updateNumberObjectsLabel()
            }
        }
    }
    
    @IBAction func registerWasPressed(_ sender: Any) {
        Authentication.register()
    }

    @IBAction func addObjectWasPressed(_ sender: Any) {
        guard let realm = getRealm() else { return }

        try! realm.write {
            realm.add(RealmObject())
        }
        
        updateNumberObjectsLabel()
    }
    
    func updateLoginStateLabelAndButton() {
        let isLoggedIn = Authentication.isLoggedIn
        loginStateLabel.text = isLoggedIn ? "Login state: logged in ✅" : "Login state: not logged in ❌"
        signInButton.setTitle(isLoggedIn ? "Sign out" : "Sign in", for: .normal)
        registerButton.isHidden = isLoggedIn
    }
    
    func updateNumberObjectsLabel() {
        guard let realm = getRealm() else {
            numberObjectsLabel.text = "Number of objects in Realm: ❌"
            return
        }
                
        numberObjectsLabel.text = "Number of objects in Realm: \(realm.objects(RealmObject.self).count)"
    }
    
    func getRealm() -> Realm? {
        guard let user = Authentication.realmApp.currentUser else { return nil }

        var config = user.configuration(partitionValue: user.id)
        config.objectTypes = [RealmObject.self]

        guard let realm = try? Realm(configuration: config) else { return nil }
        return realm
    }
    
}

// just reusing an object type I had in my database, no particular meaning
class RealmObject: Object {

    @objc dynamic var _id: String = UUID().uuidString
    override class func primaryKey() -> String? { return "_id" }

    @objc dynamic var date: NSDate = NSDate()
}
