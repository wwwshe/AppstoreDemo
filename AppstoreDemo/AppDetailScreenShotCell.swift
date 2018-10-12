//
//  AppDetailScreenShotCell.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 12..
//  Copyright © 2018년 junjungwook. All rights reserved.
//
// 앱 스크린샷 컬렉션뷰 셀 in 테이블 셀


import UIKit

class AppDetailScreenShotCell : UITableViewCell{
    var screenshots = [String]()
    var parentView : AppDetailViewController!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
   
   
    func collectionViewSet(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}


extension AppDetailScreenShotCell :  UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
       
        return CGSize(width:  UIScreen.main.bounds.width / 1.5, height: self.frame.height - 61)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = MultiImageShowViewController.storyboardInstance()
        controller.screenshots = self.screenshots
        controller.idx = indexPath.row
        self.parentView.present(controller,animated: true)
    }
    
}


class ScreenshotCell : UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        self.imageView.layer.masksToBounds = false
        self.imageView.layer.cornerRadius =  10
        self.imageView.clipsToBounds = true
    }
}
