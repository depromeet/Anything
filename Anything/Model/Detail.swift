//
//  Detail.swift
//  Anything
//
//  Created by Soso on 2020/11/29.
//  Copyright © 2020 Soso. All rights reserved.
//

import Foundation

struct Detail: Decodable {
    let isMapUser, isExist: Bool
    let basicInfo: BasicInfo?
    let s2Graph: S2Graph?
    let blogReview: BlogReview?
    let kakaoStory: KakaoStory?
    let comment: Comment
    let findway: Findway?
    let companyInfo: CompanyInfo?
    let menuInfo: MenuInfo?
    let photo: Photo?
}

// MARK: - BasicInfo

struct BasicInfo: Decodable {
    let cid: Int?
    let placenamefull: String?
    let mainphotourl: String?
    let phonenum: String?
    let address: Address?
    let homepage: String?
    let homepagenoprotocol: String?
    let wpointx, wpointy: Int?
    let roadview: Roadview?
    let cateid, catename, cate1Name, englishname: String?
    let feedback: [String: Int]?
    let openHour: OpenHour?
    let communityList: [CommunityList]?
    let metaKeywordList: [String]?
    let source: Source?
    let isStation: Bool?
}

// MARK: - Address

struct Address: Decodable {
    let newaddr: Newaddr?
    let region: Region?
    let addrbunho, addrdetail: String?
}

// MARK: - Newaddr

struct Newaddr: Decodable {
    let newaddrfull, bsizonno: String?
}

// MARK: - Region

struct Region: Decodable {
    let name3, fullname, newaddrfullname: String?
}

// MARK: - CommunityList

struct CommunityList: Decodable {
    let communitynoprotocol: String?
    let community: String?
}

// MARK: - OpenHour

struct OpenHour: Decodable {
    let periodList: [PeriodList]?
    let offdayList: [OffdayList]?
    let realtime: Realtime?
}

// MARK: - OffdayList

struct OffdayList: Decodable {
    let holidayName: String?
}

// MARK: - PeriodList

struct PeriodList: Decodable {
    let periodName: String?
    let timeList: [TimeList]?
}

// MARK: - TimeList

struct TimeList: Decodable {
    let timeName, timeSE, dayOfWeek: String?
}

// MARK: - Realtime

struct Realtime: Decodable {
    let holiday, breaktime, realtimeOpen, moreOpenOffInfoExists: String?
    let datetime: String?
    let currentPeriod: PeriodList?
}

// MARK: - Roadview

struct Roadview: Decodable {
    let panoid, tilt, pan, wphotox: Int?
    let wphotoy, rvlevel: Int?
}

// MARK: - Source

struct Source: Decodable {
    let date: String?
}

// MARK: - BlogReview

struct BlogReview: Decodable {
    let placenamefull: String?
    let blogrvwcnt: Int
    let moreID: Int?
    let list: [BlogReviewList]?
}

// MARK: - BlogReviewList

struct BlogReviewList: Decodable {
    let blogname: String?
    let blogurl: String?
    let contents: String?
    let outlink: String?
    let date, reviewid, title: String?
    let photoList: [ListPhotoList]?
    let isMy: Bool?
}

// MARK: - ListPhotoList

struct ListPhotoList: Decodable {
    let orgurl: String?
}

// MARK: - Comment

struct Comment: Decodable {
    let allComntcnt, kamapComntcnt, kaplaceComntcnt, daumComntcnt: Int?
    let scoresum, scorecnt: Int
    let currentPage, nextPage: Int?
    let pageList: [Int]?
    let list: [CommentList]?
}

// MARK: - CommentList

struct CommentList: Decodable {
    let commentid, contents: String?
    let point: Int?
    let username: String?
    let profile: String?
    let profileStatus: String?
    let photoCnt, likeCnt: Int?
    let kakaoMapUserID, platform, date: String?
    let isMy, isBlock, isEditable, isMyLike: Bool?
    let thumbnail: String?
    let photoList: [String]?
}

// MARK: - CompanyInfo

struct CompanyInfo: Decodable {
    let companyCommentList: [CompanyCommentList]?
}

// MARK: - CompanyCommentList

struct CompanyCommentList: Decodable {
    let cilink: String?
    let list: [CompanyCommentListList]?
    let companyCommentType: String?
}

// MARK: - CompanyCommentListList

struct CompanyCommentListList: Decodable {
    let title, desc: String?
}

// MARK: - Findway

struct Findway: Decodable {
    let x, y: Int?
    let subway: [Subway]?
    let busstop: [Busstop]?
    let busDirectionCheck: Bool?
}

// MARK: - Busstop

struct Busstop: Decodable {
    let busStopID, busStopName, busStopDisplayID: String?
    let toBusstopDistance, wpointx, wpointy: Int?
    let busInfo: [BusInfo]?
}

// MARK: - BusInfo

struct BusInfo: Decodable {
    let busType: String?
    let busTypeCode: String?
    let busList: [BusList]?
    let busNames: String?
}

// MARK: - BusList

struct BusList: Decodable {
    let busID, busName: String?
    let busTextName: String?
}

// MARK: - Subway

struct Subway: Decodable {
    let stationSimpleName, stationID, exitNum: String?
    let toExitDistance: Int?
    let subwayList: [SubwayList]?
    let toExitMinute: Int?
}

// MARK: - SubwayList

struct SubwayList: Decodable {
    let subwayID, subwayName: String?
}

// MARK: - KakaoStory

struct KakaoStory: Decodable {
    let placenamefull: String?
    let kascnt: Int?
    let list: [KakaoStoryList]?
}

// MARK: - KakaoStoryList

struct KakaoStoryList: Decodable {
    let storyid, creator: String?
    let outlink: String?
    let image: String?
    let imgcnt: Int?
    let body, date: String?
}

// MARK: - MenuInfo

struct MenuInfo: Decodable {
    let menucount: Int?
    let menuList: [MenuList]?
    let productyn: String?
    let menuboardphotourlList: [String]?
    let menuboardphotocount: Int?
    let timeexp: String?
}

// MARK: - MenuList

struct MenuList: Decodable {
    let price, menu: String?
}

// MARK: - Photo

struct Photo: Decodable {
    let photoList: [PhotoPhotoList]?
}

// MARK: - PhotoPhotoList

struct PhotoPhotoList: Decodable {
    let photoCount: Int?
    let categoryName: String?
    let list: [PhotoListList]?
}

// MARK: - PhotoListList

struct PhotoListList: Decodable {
    let photoid: String?
    let orgurl: String?
}

// MARK: - S2Graph

struct S2Graph: Decodable {
    let status: String?
    let day: Day?
    let gender, age: Age?
}

// MARK: - Age

struct Age: Decodable {
    let labels: [String]?
    let data: [Int]?
    let max: Int?
}

// MARK: - Day

struct Day: Decodable {
    let initData: [Int]?
    let labels: [String]?
    let avg, sunday, monday, tuesday: [Int]?
    let wednesday, thursday, friday, saturday: [Int]?
    let max: Int?
}
