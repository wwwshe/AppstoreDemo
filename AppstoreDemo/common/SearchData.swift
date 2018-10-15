//
//  SearchData.swift
//  AppstoreDemo
//
//  Created by 서비스앱개발팀 on 2018. 10. 11..
//  Copyright © 2018년 junjungwook. All rights reserved.
//

import Foundation

@objcMembers
class SearchData : NSObject{
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "description"{
            super.setValue(value, forKey: "des")
        }else{
            let copy = Mirror(reflecting: self)
            for child in copy.children.makeIterator(){
                if let label = child.label, label == key{
                    super.setValue(value, forKey: key)
                }
            }
        }
        
    }
    var screenshotUrls = [String]() // 아이폰 스크린샷
    var artworkUrl60 = ""     //아이콘 60
    var artworkUrl512 = ""    //아이콘 512
    var artworkUrl100 = ""     //아이콘 100
    var artistViewUrl = ""     //개발자 정보 페이지
    var ipadScreenshotUrls = [String]() // 아이패드 스크린샷
    var advisories = [String]()         // 앱 성격(에 : 드문/경미한 욕설 또는 저질의 유머) 없을수도 있음
    var averageUserRatingForCurrentVersion = 0.0 // 현재버전 평점
    var trackCensoredName = ""  // 앱 이름
    var fileSizeBytes = 0      // 앱 사이즈
    var sellerUrl = ""          // 회사 사이트
    var userRatingCountForCurrentVersion = 0 // 현재 버전의 평가 갯수
    var trackContentRating = ""    // 콘텐츠 등급
    var trackViewUrl = ""         // 현재 앱 url
    var contentAdvisoryRating = ""    // 콘텐츠 자문 등급
    var primaryGenreId = 0        // 기본 아이디
    var sellerName = ""          // 회사 이름
    var releaseNotes = ""        // 현재 버전 개발 내용
    var minimumOsVersion = ""    // 지원 os 최소 버전
    var trackName = ""  // 앱 이름
    var releaseDate = ""    //업로드 날짜
    var primaryGenreName = "" //장르
    var formattedPrice = "" // 원래 가격
    var currency = "" // 화페 종류
    var version = "" // 앱 버전
    var des = ""     //설명
    var artistName = "" //개발자 이름
    var genres = [String]() // 장르
    var price = 0.0 // 가격
    var bundleId = "" // 번들아이디
    var currentVersionReleaseDate = "" //현재버전 업로드 날짜
    var averageUserRating = 0.0 //평점
    var userRatingCount = 0 //유저 평가갯수
    var languageCodesISO2A = [String]()    // 언어 코드
}
