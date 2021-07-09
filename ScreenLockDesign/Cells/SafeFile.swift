//
//  SafeFile.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 09/07/21.
//
/*
import UIKit
import SSOKit
import ZohoDeskSDKInhouse
import ZohoDeskSDK

class ZDRAppLockPinView: UIView {
    
    

    @IBOutlet weak var contentViewAreaHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var buttonViewAreaHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var contentViewImageAreaHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var contentAreaStackViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var contentViewInnerTopHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var contentViewInnerMiddleHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var contentViewInnerBottomHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var visibleViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var visibleViewWidthAnchor: NSLayoutConstraint!
    @IBOutlet weak var contentViewTextLabelHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var topStackViewArea: UIStackView!
    
    
    @IBOutlet weak var left1Constraint: NSLayoutConstraint!
    @IBOutlet weak var right1Constraint: NSLayoutConstraint!
    @IBOutlet weak var middleLeft1Constraint: NSLayoutConstraint!
    @IBOutlet weak var middleRight1Constraint: NSLayoutConstraint!
    @IBOutlet weak var btnWidthAnchor: NSLayoutConstraint!
    @IBOutlet weak var btnHeightAnchor: NSLayoutConstraint!
    
    @IBOutlet weak var buttonVerticalHeight1Constraint: NSLayoutConstraint!
    
    @IBOutlet weak var buttonVerticalHeight2Constraint: NSLayoutConstraint!
    @IBOutlet weak var buttonVerticalHeight3Constraint: NSLayoutConstraint!
    @IBOutlet weak var buttonVerticalHeight4Constraint: NSLayoutConstraint!
    @IBOutlet weak var buttonVerticalHeight5Constraint: NSLayoutConstraint!
    @IBOutlet weak var navViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    @IBOutlet weak var btn9: UIButton!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var forgetBtn: UIButton!
    @IBOutlet weak var dltBtn: UIButton!
    
    
    @IBOutlet weak var innerStackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var topViewArea: UIView!
    @IBOutlet weak var fillViewOne: UIView!
    @IBOutlet weak var fillViewTwo: UIView!
    @IBOutlet weak var fillViewThree: UIView!
    @IBOutlet weak var fillViewFour: UIView!
    @IBOutlet weak var pwdCheckViewsStackView: UIView!
    
    
    @IBOutlet weak var pinLabelArea: UILabel!
    
    var isUnlock: ((_ isUpdated: Bool) -> Void)?

    var countOfTappedPIN:Int = 0
    
    var PINState:PINVerifyState = .Update
    
    var password:[String] = []
    
    var confirmPassword:[String] = []
    
    var attemptOfPINChageOperation = 1
    
    var wrongAttempt = 0
    
    var activeVc: UIViewController?
    let storyBoard = UIStoryboard(name: ZDRAppLockConstants.storyBoardID, bundle: nil)
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addInitialAllignments()
        self.addFontAndTheme()
        self.initialAlignments()
        
        if UserDefaultsManager.Configuration.IsUserSpamed{
            Utility.showOkAlertController(title: "deskmanager.common.errortext".getLocalize(), message: "ZDRAppLock.user.wrongattemp.count6.alert.msg".getLocalize()) { [weak self] in
                guard let self = self else { return }
                self.logoutFunc()
                self.wrongAttempt = 0
            }
        }
    }
    var heightValue:CGFloat = 0
    
    fileprivate func addInitialAllignments(){
        
        switch PINState{
        case .Check:
            heightValue = self.frame.height
            self.forgetBtn.isUserInteractionEnabled = true
            self.forgetBtn.alpha = 1
            self.forgetBtn.backgroundColor = .none
            self.forgetBtn.setTitleColor(ZDRTheme.Text.primary, for: .normal)
            self.forgetBtn.titleLabel?.font = ZDRFontStyles.primary.font
            
            self.topViewArea.isUserInteractionEnabled = false
            self.topViewArea.alpha = 0
            
        case .Update:
            self.addTopNavBar()
            heightValue = self.frame.height - 50
            break
        }
        
        let contentViewHeight = heightValue * 0.3
        let buttonViewHeight = heightValue * 0.7
        contentViewAreaHeightAnchor.constant = contentViewHeight
        buttonViewAreaHeightAnchor.constant = buttonViewHeight
        
        contentAreaStackViewHeightAnchor.constant = contentViewHeight * 0.40
        contentViewImageAreaHeightAnchor.constant = contentViewHeight * 0.20
        
        visibleViewHeightAnchor.constant = contentAreaStackViewHeightAnchor.constant * 0.2
        visibleViewWidthAnchor.constant = contentAreaStackViewHeightAnchor.constant * 0.2
        innerStackViewHeight.constant = contentAreaStackViewHeightAnchor.constant * 0.2
        
        contentViewTextLabelHeightAnchor.constant = contentAreaStackViewHeightAnchor.constant * 0.4
        topStackViewArea.spacing = self.frame.height * 0.02
        
        let spaceConstraints = [left1Constraint,right1Constraint,middleRight1Constraint,middleLeft1Constraint]
        for i in 0..<spaceConstraints.count {
            spaceConstraints[i]?.constant = self.frame.width * 0.1
        }
        
        btnWidthAnchor.constant = self.frame.width * 0.2
        btnHeightAnchor.constant = self.frame.width * 0.2
        
        let btnArr = [btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9,btn0,dltBtn]
        
        for i in 0..<btnArr.count{
            btnArr[i]?.layer.cornerRadius = (self.frame.width * 0.2) / 2
        }
        
        let verticalHeight = [buttonVerticalHeight1Constraint,buttonVerticalHeight2Constraint,buttonVerticalHeight3Constraint,buttonVerticalHeight4Constraint,buttonVerticalHeight5Constraint]
        for i in 0..<verticalHeight.count {
            verticalHeight[i]?.constant = (buttonViewHeight - (btnHeightAnchor.constant * 4)) / 10
        }
        
        
    }
    
    fileprivate func logoutFunc(){
        NotificationRegisterAPIHandler.resetBadgeCount {
            UIApplication.shared.applicationIconBadgeNumber = 0
            UserPresenceHandler.destroy()
            AgentCollisionHandler.destroy()
            CoreDataManager.destroy()
            self.deregisterNotification { (status) in
                
                if status {
                    DispatchQueue.main.async {
                        UserDefaultConfiguration.resetNotification()
                    }
                }
                
                ZSSOKit.revokeAccessToken { (_) in
                    DispatchQueue.main.async {
                        ZSSOKit.clearSSODetailsForFirstLaunch()
                        SyncEngine.currentProgress = 0
                        ZohoDeskSDK.delegete = nil
                        
                        var analitcalURL = ZohoDeskSDK.configuration?.baseURL ?? ZDRadarEnv.getDomainURL()
                        analitcalURL = analitcalURL.replacingOccurrences(of: "https://desk.", with: "")
                        let userEmail = ZSSOKitUserHandler.shared.getUserProfile().email ?? ""
                        Apptics.trackLogOut(userEmail, withBaseDomain: analitcalURL)
                        Analytics.shared.addTrackEvent(AnalyticsConstantString.SignOutScreen.SignOutTapped)
                        GlobalConstant.isSyncStarted = false
                        StoredDataManager.removeData()
                        
                        (UIApplication.shared.delegate as! AppDelegate).showOnboardingScreen()
                        
                    }
                }
            }
        }
    }
    
    fileprivate func addTopNavBar(){
        
        let navigationView: ZDRNavigationView = ZDRNavigationView.loadFromXib()
        let navigationTitleView: ZDRNavigationTitleView = ZDRNavigationTitleView.loadFromXib()
        
        
        topViewArea.backgroundColor = ZDRTheme.Background.primary
        topViewArea.addSubview(navigationView)
        navigationView.g_pinEdges()
               
        navigationView.backButtonClicked = { [weak self] () in
            guard let selfObject = self?.activeVc else { return }
                   selfObject.navigationController?.popViewController(animated: true)
            
        }
               
        navigationView.rightHolderView.addSubview(navigationTitleView)
        navigationTitleView.g_pinEdges()
               
        navigationTitleView.setTitle(title: "ZDRAppLock.pinpage.titlename".getLocalize(), font: .primary, color: .themeColor)
    }
    
    
    
    fileprivate func addFontAndTheme(){
        self.backgroundColor = ZDRTheme.Background.primary
        
        let btnArr = [btn1,btn2,btn3,btn4,btn5,btn6,btn7,btn8,btn9,btn0,dltBtn]
        
        pinLabelArea.textColor = ZDRTheme.Static.themeColor
        
        for i in 0..<btnArr.count {
            btnArr[i]?.backgroundColor = ZDRTheme.Background.secondary
            btnArr[i]?.setTitleColor(ZDRTheme.Text.primary, for: .normal)
            btnArr[i]?.titleLabel?.font = ZDRFontStyles.primary.font
        }
        
    }
    
    fileprivate func initialAlignments(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let viewArr:[UIView] = [self.fillViewOne,self.fillViewTwo,self.fillViewThree,self.fillViewFour]
            
            for i in 0...viewArr.count-1{
                viewArr[i].layer.borderColor = ZDRTheme.Static.themeColor.cgColor
                viewArr[i].backgroundColor = ZDRTheme.Background.primary
                viewArr[i].layer.borderWidth = 2
                viewArr[i].layer.cornerRadius = self.fillViewFour.frame.height / 2
            }
        }
        
    }
    
    
    fileprivate func changeIndicatorColour(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if self.countOfTappedPIN < 0{
                self.countOfTappedPIN = 0
            }
            if self.countOfTappedPIN > 0{
                self.fillViewOne.backgroundColor = ZDRTheme.Static.themeColor
                if self.countOfTappedPIN > 1 {
                    self.fillViewTwo.backgroundColor = ZDRTheme.Static.themeColor
                    if self.countOfTappedPIN > 2 {
                        self.fillViewThree.backgroundColor = ZDRTheme.Static.themeColor
                        if self.countOfTappedPIN > 3 {
                            self.fillViewFour.backgroundColor = ZDRTheme.Static.themeColor
                            self.initialAlignments()
                            self.countOfTappedPIN = 0
                            switch self.PINState {
                            case .Check:
                                self.verifySamePassword(pwdArr: self.password)
                            case .Update:
                                self.toAllowGiveEnterSecondPIN()
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    
    
    fileprivate func verifySamePassword(pwdArr: [String]){
        var arrToStr:String = ""
        for i in 0...pwdArr.count-1 {
            arrToStr += pwdArr[i]
        }
        
        if arrToStr == UserDefaultsManager.Configuration.PIN {
            DispatchQueue.main.async { [weak self] in
                self?.isUnlock?(true)
            }
        } else {
            enterWrongLogicOrPwd()
            wrongAttempt += 1
            if wrongAttempt == 6 {
                UserDefaultsManager.Configuration.IsUserSpamed = true
                Utility.showOkAlertController(title: "deskmanager.common.errortext".getLocalize(), message: "ZDRAppLock.user.wrongattemp.count6.alert.msg".getLocalize()) { [weak self] in
                    guard let self = self else { return }
                    self.logoutFunc()
                    self.wrongAttempt = 0
                }
                
            }
        }
        password = []
    }
    fileprivate func cancelBtnTapped(){
        activeVc?.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func deregisterNotification(onComplition:@escaping ((_ status: Bool)->Void)) {
        NotificationRegisterAPIHandler.deRegisterNotification(onComplition: onComplition)
    }
    
    fileprivate func enterWrongLogicOrPwd(){
        UIView.animate(withDuration: 0.1, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
            self.pwdCheckViewsStackView.center.x += 10
        }

        UIView.animate(withDuration: 0.1, delay: 0.1, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
            self.pwdCheckViewsStackView.center.x -= 20
        }
        
        UIView.animate(withDuration: 0.1, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn) {
            self.pwdCheckViewsStackView.center.x += 10
        }
        

    }
    
    
    fileprivate func checkPasswordForUpdate(firstPwd: [String], secondPwd: [String]) -> Bool{
        if firstPwd == secondPwd {
            var arrToStr:String = ""
            for i in 0...secondPwd.count-1 {
                arrToStr += secondPwd[i]
            }
            print(arrToStr)
            UserDefaultsManager.Configuration.PIN = arrToStr
            
            return true
        } else {
            enterWrongLogicOrPwd()
            password.removeAll()
            confirmPassword.removeAll()
            attemptOfPINChageOperation = 1
            return false
        }
    }
    
    
    fileprivate func toAllowGiveEnterSecondPIN(){
        if attemptOfPINChageOperation == 2 {
            let toAllow = checkPasswordForUpdate(firstPwd: password, secondPwd: confirmPassword)
            if toAllow{
                UserDefaultsManager.Configuration.PasswordExists = true
                activeVc?.navigationController?.popViewController(animated: true)
                attemptOfPINChageOperation = 1
                
            }
        } else {
            let alert = UIAlertController(title: "ZDRAppLock.pinpage.confirm.second.pin.alert.msg".getLocalize() , message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "deskmanager.common.ok".getLocalize(), style: .default, handler: nil)
            alert.addAction(action)
            activeVc?.present(alert, animated: true, completion: nil)
            attemptOfPINChageOperation = 2
        }
    }
    
    
    @IBAction func numericBtnsTapped(_ sender: UIButton) {
        countOfTappedPIN += 1
        if let n = sender.titleLabel?.text{
            attemptOfPINChageOperation == 1 ? password.append(n) : confirmPassword.append(n)
            changeIndicatorColour()
        }
    }
    @IBAction func dltBtnTapped(_ sender: UIButton) {
        countOfTappedPIN -= 1
        if countOfTappedPIN >= 0 {
            attemptOfPINChageOperation == 1 ? password.remove(at: password.count-1) : confirmPassword.remove(at: confirmPassword.count-1)
            
        }
        initialAlignments()
        changeIndicatorColour()
    }
    @IBAction func forgotBtnTapped(_ sender: UIButton) {
        Utility.showButtonActionSheet(with: ["deskmanager.common.cancel".getLocalize(), "deskmanager.common.ok".getLocalize()], title: "ZDRAppLock.user.wrongattemp.count6.alert.msg".getLocalize()) { [weak self] option, index in
            guard let self = self else { return }
            index == 0 ? self.cancelBtnTapped() : self.logoutFunc()
        }
        
    }
    

}
*/
