//
//  ViewController.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 10..
//  Copyright © 2018년 junjungwook. All rights reserved.
//
// 검색 첫 페이지

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var beforeSearchWordTable: UITableView!
    
    let db = Database.sharedInstance
    
    var beforeKeywords = [String]()
    
    var searchController: UISearchController?
    var searchListController : SearchListViewController?

    var isSearchActive = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        searchController = ({
            searchListController = SearchListViewController.storyboardInstance()
            let controller = UISearchController(searchResultsController: searchListController)
            controller.searchBar.placeholder = "App Store"
            controller.searchResultsUpdater = self
            controller.searchBar.delegate = self
          
            controller.delegate = self
            controller.searchBar.setValue("취소", forKey: "cancelButtonText")
            return controller
        })()
        
        searchListController?.parentView = self
        self.navigationItem.searchController = searchController
        definesPresentationContext = true
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.shouldRemoveShadow(true)
        
        beforeKeywords = db.selectKeyWordDatabase()
        beforeSearchWordTable.delegate = self
        beforeSearchWordTable.dataSource = self
        beforeSearchWordTable.tableFooterView = UIView()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .never
        beforeKeywords = db.selectKeyWordDatabase()
        beforeSearchWordTable.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 검색 결과 페이지로 이동
    func moveResultPage(_ word : String){
        self.searchController?.searchBar.text = ""
        db.insertKeyWordDatabase(word)
        searchController?.isActive = true 
        searchController?.searchBar.text = word
        searchListController?.viewResultChange(word)
    }
    
    // 상세 페이지로 이동
    func moveDetailPage(_ data : SearchData){
        let controller = AppDetailViewController.storyboardInstance()
        controller.data = data
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    // 키워드 유효성검사
    func isValidKeyword(testStr:String) -> Bool {
        let regEx = "[가-힣ㄱ-ㅎㅏ-ㅣ]"
        
        let text = NSPredicate(format:"SELF MATCHES %@", regEx)
        return text.evaluate(with: testStr)
    }
}


extension SearchViewController :  UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate{
    func didDismissSearchController(_ searchController: UISearchController) {
        self.searchController?.searchBar.showsCancelButton = false
        self.searchListController?.isResult = false
        self.searchListController?.resultDatas.removeAll()
    }
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEmpty || text == "\n" || text == " "{
            return true
        }
        if isValidKeyword(testStr: text){
            return true
        }else {
            return false
        }
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      
        isSearchActive = true
        beforeSearchWordTable.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchActive = false
        beforeSearchWordTable.reloadData()
    }

    
    func updateSearchResults(for searchController: UISearchController) {
        let word = searchController.searchBar.text!
        if word != ""{
            searchListController?.historyKeywords = db.selectKeyWordContainDatabase(word)
            searchListController?.searchTable.reloadData()
        }
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        self.searchListController?.isResult = false
        self.searchListController?.resultDatas.removeAll()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let word = searchBar.text!
        self.db.insertKeyWordDatabase(word)
        searchListController?.viewResultChange(word)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if beforeKeywords.count != 0{
            return beforeKeywords.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeforeSearchTableCell") as! BeforeSearchTableCell
        if beforeKeywords.count > 0 {
            cell.wordText.text = beforeKeywords[indexPath.row]
        }else{
            cell.wordText.text = "최근 검색어가 없습니다."
        }
        if isSearchActive == true{
            cell.wordText.textColor = UIColor.black
        }else{
            cell.wordText.textColor = UIColor.blue
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if beforeKeywords.count > 0 {
            moveResultPage(beforeKeywords[indexPath.row])
        }
    }
    
}

class BeforeSearchTableCell : UITableViewCell{
    
    @IBOutlet weak var wordText: UILabel!
}

