//
//  Authentication.swift
//  RealmTokenExpiredExample
//
//  Created by Jean-Baptiste Beau on 30/09/2021.
//

import UIKit
import RealmSwift

class Authentication {
    
    static let realmAppID = "INSERT_APP_ID"
    static let realmApp = App(id: realmAppID)

    private static let email = "test"
    private static let password = "12345678"
    
    static var isLoggedIn: Bool {
        return realmApp.currentUser != nil
    }
    
    static func register() {
        realmApp.emailPasswordAuth.registerUser(email: email, password: password) { error in
            if error != nil {
                print("Error while registering user: \(error!)")
            }
            else {
                print("Register successful!")
            }

        }
    }
    
    static func login(successCompletion: @escaping () -> ()) {
        realmApp.login(credentials: Credentials.emailPassword(email: email, password: password)) { result in
            do {
                _ = try result.get()
                print("Login successful!")
                DispatchQueue.main.async {
                    successCompletion()
                }
            }
            catch {
                print("Error while login: \(error)")
            }
        }
    }
    
    static func logout(successCompletion: @escaping () -> ()) {
        guard let user = realmApp.currentUser else {
            return print("No need to log out: no user is connected.")
        }
        
        let userID = user.id
        
        user.remove { error in
            if error != nil {
                print("Error while logout: \(error!)")
            }
            else {
                print("Logout successful!")
                
                print("—————————————————————————————")
                print("ISSUE 1:")
                print("Here, after removing the user, the realm directory should be deleted. So \"\(userID)\" should't appear in the list below.")
                print(getRealmFolders())
                print("—————————————————————————————")

                DispatchQueue.main.async {
                    successCompletion()
                }
            }
        }
    }
    
    private static func getRealmFolders() -> [String] {
        guard let documentFolder = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return [] }
        
        let realmFolder = documentFolder.appendingPathComponent("mongodb-realm").appendingPathComponent(realmAppID)
        let directoryContents = try! FileManager.default.contentsOfDirectory(at: realmFolder, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: [])

        let subdirs = directoryContents.filter{ $0.hasDirectoryPath }
        return subdirs.map{ $0.lastPathComponent }
    }
    
}
