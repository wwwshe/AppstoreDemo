//
//  Database.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 10..
//  Copyright © 2018년 junjungwook. All rights reserved.
//

import Foundation
import SQLite

class Database{
    static let sharedInstance = Database()
    var keywords : Table!
    var db : Connection!
    let id = Expression<Int64>("id")
    let keyword = Expression<String?>("keyword")
    init() {
        createDatabase()
    }
    
    func createDatabase(){
        do {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            db = try Connection("\(documentsPath)/db.sqlite3")
            keywords = Table("keywords")
            
            try db.run(keywords.create(temporary: false, ifNotExists: true, withoutRowid: false) { (t) in
                t.column(keyword, unique : true)
                t.column(id)
            })
            
        } catch {
           print("디비 생성오류")
        }
    }
    
    func insertKeyWordDatabase(_ word : String){
        do {
            let insert = keywords.insert(id <- db.lastInsertRowid + 1 , keyword <- word)
            try db.run(insert)
        } catch let error {
            print(error)
        }
    }
    func selectKeyWordContainDatabase(_ word : String) -> [String]{
        var strings = [String]()
        do {
            for key in try db.prepare(keywords) {
                if key[keyword]?.contains(word) == true {
                    strings.append(key[keyword] ?? "")
                }
            }
        } catch let error {
            print(error)
        }
        return strings
    }
    func selectKeyWordDatabase() -> [String]{
        var strings = [String]()
        do {
            for key in try db.prepare(keywords) {
                if key[id] >= (db.lastInsertRowid - 10){
                    strings.append(key[keyword] ?? "")
                }else{
                    break
                }
            }
        } catch let error {
            print(error)
        }
        return strings
    }
}
