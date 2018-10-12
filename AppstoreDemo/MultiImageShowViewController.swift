//
//  MultiImageShowViewController.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 12..
//  Copyright © 2018년 junjungwook. All rights reserved.
//
// 스크린샷 상세 페이지


import UIKit

class MultiImageShowViewController : UIViewController{
    
    static func storyboardInstance() -> MultiImageShowViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MultiImageShowViewController") as! MultiImageShowViewController
        return controller
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var screenshots = [String]()
    var idx = 0
    
    override func viewDidLoad() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.scrollToItem(at: IndexPath(row: idx, section: 0), at: .left, animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func doneBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MultiImageShowViewController :  UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshots.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScreenshotCell", for: indexPath) as! ScreenshotCell
        cell.imageView.kf.setImage(with: URL(string : screenshots[indexPath.row]))
     
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:  UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.height - 90)
    }
    
   
    
}
