//
//  Constants.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 16/06/21.
//

import Foundation

struct Constants {
    static let AppLockMainPageCellID = "AppLockMainPageCellID"
    static let AppLockMainPageCellNibName = "AppLockMainPageCell"
    
    
    static let goToPINPage = "goToPINPageVc"
    static let goToFingerPrintLockPage = "goToFingerPrintSetUpPage"
    
    static let PINPageVcID = "PINPageVcID"
    static let MainVcID = "MainVcID"
    static let ParentVcID = "ParentVc"
    static let storyBoardID = "Main"
    static let BioMetricLockVcID = "BioMetricLockVcID"
    
    static let AppLockMainPageCellTitles:[String] = ["Change PIN","Fingerprint Unlock","Ask for PIN"]
    static let AppLockMainPageCellSubTitles:[String] = ["You will be signed out after  6 failed PIN attempts.","Use your fingerprint to unlock your app","Immediately"]
    
    static let collectionViewNumberValues:[String] = ["1","2","3","4","5","6","7","8","9","0","0"]
    static let collectionViewAlphValues:[String] = ["ABC","DEF","GHI","JKL","MNO","PQRS","TUV","WXYZ"]
    
    //MARK:- UserDefaults key values
    static let PIN = "PIN"
    static let UserGivenTimeDuration = "UserGivenTimeDuration"
    static let PasswordExists = "PasswordExists"
    static let IsBioMtricLockActivated = "IsBioMtricLockActivated"
    static let WhenAppGoesToBackground = "WhenAppGoesToBackground"
}

