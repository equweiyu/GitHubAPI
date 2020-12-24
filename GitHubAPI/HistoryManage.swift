//
//  HistoryManage.swift
//  GitHubAPI
//
//  Created by 白天伟 on 2020/12/24.
//

import Foundation

class HistoryManage {
    static let shared = HistoryManage()
    private init() {}
    
    private let ud = UserDefaults.init(suiteName: "GitHubAPI")
    private let udKey = "history"
    
     var history: [(String, Data)] {
        get {
            return self.list.map { (e) -> (String, Data) in
                return (e["Date"] as! String, e["Data"] as! Data)
            }
        }
    }
    private var list: [[String: Any]] {
        get {
            return ud?.array(forKey: udKey) as? [[String: Any]] ?? []
        }
        set {
            ud?.setValue(newValue, forKey: udKey)
        }
    }
    func add(date:String, data: Data)  {
        
        let res = [["Date":date,"Data":data]] + list
        ud?.setValue(Array(res.suffix(100)), forKey: udKey)
    }
    
}
