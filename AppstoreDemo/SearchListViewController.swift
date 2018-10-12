//
//  SearchListViewController.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 11..
//  Copyright © 2018년 junjungwook. All rights reserved.
//
// 검색 히스토리 페이지

import UIKit
import FloatRatingView
import Kingfisher

class SearchListViewController : UIViewController{
    static func storyboardInstance() -> SearchListViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchListViewController") as! SearchListViewController
        return controller
    }
    
    @IBOutlet weak var searchTable: UITableView!
    var historyKeywords = [String]()
    var parentView : SearchViewController!
    var isResult = false
    var resultDatas = [SearchData]()
    var keyword = ""
    
    override func viewDidLoad() {
        searchTable.delegate = self
        searchTable.dataSource = self
        searchTable.tableFooterView = UIView()

    }

    //히스토리 페이지에서 결과 페이지로 변경
    func viewResultChange(_ word : String){
        parentView.searchController?.searchBar.text = word
        parentView.searchController?.searchBar.endEditing(true)

        self.keyword = word
        self.isResult = true
        self.getSearchData()
        self.searchTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //apple search api
    func getSearchData(){
        let path = "https://itunes.apple.com/search?term=\(keyword)&country=KR&entity=software"
        let url = URL(string : path.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
                print("통신 실패")
                Util.alertMsg(viewController: self, msg: "네크워크 상태가 불안정합니다.\n다시 한번 시도해주세요.")
                return
            }
            guard let returnString = String(data : data!, encoding : .utf8) else{
                return
            }
            self.resultDatas.removeAll()
            let dic = Util.convertToDictionary(text: returnString)
            let result = dic?["results"] as! [[String:Any]]
            
            for data in result{
                let d = SearchData()
                d.setValuesForKeys(data)
                self.resultDatas.append(d)
            }
            DispatchQueue.main.async {
                self.searchTable.reloadData()

            }
            
        }
        task.resume()
    }
}
extension SearchListViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isResult == false {
            if historyKeywords.count != 0{
                return historyKeywords.count
            }else{
                return 1
            }
        }else{
            return resultDatas.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isResult == false {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchHistoryTableCell") as! SearchHistoryTableCell
            if historyKeywords.count > 0 {
                cell.searchWord.text = historyKeywords[indexPath.row]
            }else{
                cell.searchWord.text = "검색 결과가 없습니다."
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableCell") as! SearchResultTableCell
            if resultDatas.count > 0 {
                let data = resultDatas[indexPath.row]
                cell.appIcon.kf.setImage(with: URL(string : data.artworkUrl60))
                cell.appName.text = data.trackName
                cell.genreText.text = data.genres[0]
                cell.rating.rating = data.averageUserRating
                cell.ratingText.text = Util.changeUnitNumber(num: data.userRatingCount)
            
                cell.screenshot1.kf.setImage(with: URL(string : data.screenshotUrls[0]))
                cell.screenshot2.kf.setImage(with: URL(string : data.screenshotUrls[1]))
                cell.screenshot3.kf.setImage(with: URL(string : data.screenshotUrls[2]))
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isResult == false {
            if historyKeywords.count > 0 {
                
               viewResultChange(self.historyKeywords[indexPath.row])
            }
        }else{
            parentView.moveDetailPage(resultDatas[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isResult == true {
            return 350
        }else{
            return 44
        }
    }
    
    
}

class SearchHistoryTableCell : UITableViewCell{
    @IBOutlet weak var searchWord: UILabel!
}


class SearchResultTableCell : UITableViewCell{
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var installBtn: UIButton!
    @IBOutlet weak var genreText: UILabel!
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var ratingText: UILabel!
    
    @IBOutlet weak var screenshot1: UIImageView!
    @IBOutlet weak var screenshot2: UIImageView!
    @IBOutlet weak var screenshot3: UIImageView!
    
    override func awakeFromNib() {
        self.installBtn.layer.masksToBounds = false
        self.installBtn.layer.cornerRadius =  self.installBtn.frame.height/2
        self.installBtn.clipsToBounds = true
        self.appIcon.layer.masksToBounds = false
        self.appIcon.layer.cornerRadius =  10
        self.appIcon.clipsToBounds = true
        
        self.screenshot1.layer.masksToBounds = false
        self.screenshot1.layer.cornerRadius =  10
        self.screenshot1.clipsToBounds = true
        self.screenshot2.layer.masksToBounds = false
        self.screenshot2.layer.cornerRadius =  10
        self.screenshot2.clipsToBounds = true
        self.screenshot3.layer.masksToBounds = false
        self.screenshot3.layer.cornerRadius =  10
        self.screenshot3.clipsToBounds = true
    }
    
}
