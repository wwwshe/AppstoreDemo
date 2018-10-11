//
//  SearchResultViewController.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 10..
//  Copyright © 2018년 junjungwook. All rights reserved.
//

import UIKit

class SearchResultViewController : UIViewController{
    var keyword = ""
  
    static func storyboardInstance() -> SearchResultViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController
        return controller
    }
    
      @IBOutlet weak var resultTable: UITableView!
    override func viewDidLoad() {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension SearchResultViewController :  UITableViewDelegate, UITableViewDataSource{

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return UITableViewCell()
    }
    
}
