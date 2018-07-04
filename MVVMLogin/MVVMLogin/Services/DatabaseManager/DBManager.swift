//
//  DBManager.swift
//  AidATrade
//
//  Created by Gaurav Rastogi on 2/9/18.
//  Copyright © 2018 Gaurav Rastogi. All rights reserved.
//

import UIKit
import SQLite

class DBManager {
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!
    
    private var database:Connection?
    static let   sharedInstance = DBManager()
    
    private let id = Expression<Int64>("id")
    private let email = Expression<String>("email")
    private let password = Expression<String?>("password")
    
    /**
     Lazy initialization variable for `UserTable`
    */
    private var userTable:Table {
        get {
            let users = Table("users")
            
            do {
                try database?.run(users.create { t in
                    t.column(id, primaryKey: true)
                    t.column(email, unique: true)
                    t.column(password)
                })
            }
            catch{
                print("Unexpected error: \(error).")
            }
            
            return users
        }
    }
    
    /**
     Custom initialization method used to setup database and connection.
    */
    private init() {
        do {
            database = try Connection("\(path)/db.sqlite3")
        }
        catch{
            print("Unexpected error: \(error).")
        }
    }
    
    /**
    This method is used to insert any new entry (user) into the database and return true/false based successfulinsertion.
     
    - parameter user: New user to be inserted into the local database
     */
    func insert(user:User)->Bool{
        let insert = userTable.insert(password <- user.password, email <- user.email)
        do{
            let _ = try database?.run(insert)
            return true
        }
        catch{
            return false
        }
    }
    
    /**
     This method is used to search any existing entry (user) into the database and return true/false based search result.
     
     - parameter user: User to be search into the local database
     */
    func isUserInDatabase(user:User)->Bool{
        do{
            for userInDb in (try database?.prepare(userTable.select(email,password)))! {
                print("email: \(userInDb[email]), password: \(String(describing: userInDb[password]))")
                if userInDb[email] == user.email && userInDb[password] == user.password{
                    return true
                }
            }
        }
        catch{
            return false
        }
        
        return false
    }
    
    /**
     This method is used to search any existing entry (user:email) into the database and return true/false based search result.
     
     - parameter user: User to be search into the local database
     */
    func emailAlreadyRegistered(user:User)->Bool{
        do{
            for userInDb in (try database?.prepare(userTable.select(email)))! {
                print("email: \(userInDb[email])")
                if userInDb[email] == user.email{
                    return true
                }
            }
        }
        catch{
            return false
        }
        return false
    }
}
