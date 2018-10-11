//
//  SearchResultViewController.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 10..
//  Copyright © 2018년 junjungwook. All rights reserved.
//

import UIKit
import FloatRatingView
import Kingfisher

class SearchResultViewController : UIViewController{
    var keyword = ""
  
    static func storyboardInstance() -> SearchResultViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        return controller
    }
    
    @IBOutlet weak var resultTable: UITableView!
    var resultDatas = [SearchData]()
    
    override func viewDidLoad() {
        getSearchData()
        resultTable.delegate = self
        resultTable.dataSource = self
        resultTable.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
                 self.resultTable.reloadData()
            }
           
        }
        task.resume()
    }
    
}
extension SearchResultViewController :  UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableCell") as! SearchResultTableCell
        let data = resultDatas[indexPath.row]
        cell.appIcon.kf.setImage(with: URL(string : data.artworkUrl60))
        cell.appName.text = data.trackName
        cell.greetingText.text = data.trackCensoredName
        cell.rating.rating = data.averageUserRating
        cell.ratingText.text = String(data.userRatingCount)
        
        cell.screenshot1.kf.setImage(with: URL(string : data.screenshotUrls[0]))
        cell.screenshot2.kf.setImage(with: URL(string : data.screenshotUrls[1]))
        cell.screenshot3.kf.setImage(with: URL(string : data.screenshotUrls[2]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}


class SearchResultTableCell : UITableViewCell{
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var installBtn: UIButton!
    @IBOutlet weak var greetingText: UILabel!
    @IBOutlet weak var rating: FloatRatingView!
    @IBOutlet weak var ratingText: UILabel!
    
    @IBOutlet weak var screenshot1: UIImageView!
    @IBOutlet weak var screenshot2: UIImageView!
    @IBOutlet weak var screenshot3: UIImageView!
}
