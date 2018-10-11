//
//  SearchListViewController.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 11..
//  Copyright © 2018년 junjungwook. All rights reserved.
//

import UIKit
class SearchListViewController : UIViewController{
    static func storyboardInstance() -> SearchListViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchListViewController") as! SearchListViewController
        return controller
    }
    
    @IBOutlet weak var searchHistoryTable: UITableView!
    var historyKeywords = [String]()
    var parentView : SearchViewController!
    
    override func viewDidLoad() {
        searchHistoryTable.delegate = self
        searchHistoryTable.dataSource = self
        searchHistoryTable.tableFooterView = UIView()
    }
    
   
}
extension SearchListViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if historyKeywords.count != 0{
            return historyKeywords.count
        }else{
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryTableCell") as! SearchHistoryTableCell
        if historyKeywords.count > 0 {
            cell.searchWord.text = historyKeywords[indexPath.row]
        }else{
            cell.searchWord.text = "검색 결과가 없습니다."
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if historyKeywords.count > 0 {
            self.dismiss(animated: false) {
                self.parentView.moveResultPage(self.historyKeywords[indexPath.row])
            }
        }
    }
    
    
}

class SearchHistoryTableCell : UITableViewCell{
    @IBOutlet weak var searchWord: UILabel!
}
