//
//  MainVc.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 16/06/21.
//

import UIKit

class MainVc: UIViewController{

    @IBOutlet weak var topSwitch: UISwitch!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var subContentsHeightAnchor: NSLayoutConstraint!
    
    
    let transparentView = UIView()
    let dropDownTableView = UITableView()
    let checkBoxView = CheckBoxView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
    
    
    
    let contents = ["1 min","10 min","5 min","1 hr","When App Closed"]
    var dropDownTableViewDelegateAndDataSource: DropDownTableViewProperties!
    var isPasswordAlreadySet:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startingAlignments()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        startingAlignments()
    }
    
    func startingAlignments(){
        navigationController?.navigationBar.isHidden = true
        
        mainTableView.register(UINib(nibName: Constants.AppLockMainPageCellNibName, bundle: nil), forCellReuseIdentifier: Constants.AppLockMainPageCellID)
        mainTableView.dataSource = self
        mainTableView.isScrollEnabled = false
        mainTableView.delegate = self
        
        checkBtnState()
    }
    
    func checkBtnState(){
        let passWordExists = UserDefaults.standard.bool(forKey: Constants.PasswordExists)
        if passWordExists{
            let alreadyHavePIN = UserDefaults.standard.string(forKey: Constants.PIN)
            if alreadyHavePIN != nil {
                topSwitch.setOn(true, animated: true)
            }
        } else {
            topSwitch.setOn(false, animated: true)
        }
        initialState()
    }
    
    //MARK:- DropDownView
    
    func addTransparentView(){
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        dropDownTableView.frame = CGRect(x: self.view.frame.maxX - view.frame.width , y: self.view.frame.maxY, width: self.view.frame.width, height: 0)
        self.view.addSubview(dropDownTableView)
        dropDownTableView.layer.cornerRadius = 5
        
        transparentView.backgroundColor = .black.withAlphaComponent(0.6)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut) { [self] in
            self.transparentView.alpha = 0.5
            self.dropDownTableView.frame = CGRect(x: self.view.frame.maxX - view.frame.width , y: self.view.frame.maxY, width: self.view.frame.width, height: -CGFloat(contents.count * 50))
            self.view.addSubview(dropDownTableView)
        }

    }

    @objc func removeTransparentView(){
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseIn) { [self] in
            self.transparentView.alpha = 0
            self.dropDownTableView.frame = CGRect(x: self.view.frame.maxX - view.frame.width , y: self.view.frame.maxY, width: self.view.frame.width, height: 0)
            self.view.willRemoveSubview(dropDownTableView)
        }
    }
    
    
    func initialState(){
        if topSwitch.isOn {
            subContentsHeightAnchor.constant = 300
            mainTableView.isUserInteractionEnabled = true
            
        } else {
            subContentsHeightAnchor.constant = 0
            mainTableView.isUserInteractionEnabled = false
        }
        
        if UserDefaults.standard.bool(forKey: Constants.IsBioMtricLockActivated){
            checkBoxView.backgroundColor = .systemGreen
        } else {
            checkBoxView.backgroundColor = .red
        }
        
    }
    
    @IBAction func topSwitchToggled(_ sender: UISwitch) {
        let alreadyHavePIN = UserDefaults.standard.string(forKey: Constants.PIN)
        if sender.isOn {
            subContentsHeightAnchor.constant = 300
            mainTableView.isUserInteractionEnabled = true
            if alreadyHavePIN != nil {
                UserDefaults.standard.set(true, forKey: Constants.PasswordExists)
            }
        } else {
            initialState()
            UserDefaults.standard.set(false, forKey: Constants.PasswordExists)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.goToPINPage {
            let destination = segue.destination as! PINPageVc
            destination.PINState = .Update
        }
    }
    
    @objc func clickBoxTapped(){
        
        let changeValue = UserDefaults.standard.bool(forKey: Constants.IsBioMtricLockActivated)
        
        if changeValue{
            UserDefaults.standard.set(false, forKey: Constants.IsBioMtricLockActivated)
        } else {
            UserDefaults.standard.set(true, forKey: Constants.IsBioMtricLockActivated)
        }
        initialState()
    }
    
    func checkClickBtn() -> Bool{
        return UserDefaults.standard.bool(forKey: Constants.IsBioMtricLockActivated)
    }
    
    func addFielsInTableViewCells(indexPath: IndexPath, tableView: UITableView) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.AppLockMainPageCellID, for: indexPath) as! AppLockMainPageCell
        if indexPath.row != 1 {
            cell.titleLabelArea.text = Constants.AppLockMainPageCellTitles[indexPath.row]
            cell.subTitleLabelArea.text = Constants.AppLockMainPageCellSubTitles[indexPath.row]
        } else {
            cell.titleLabelArea.text = Constants.AppLockMainPageCellTitles[indexPath.row]
            cell.subTitleLabelArea.text = Constants.AppLockMainPageCellSubTitles[indexPath.row]
            cell.imageViewArea.alpha = 1
            cell.imageViewArea.isUserInteractionEnabled = true
            cell.imageViewArea.addSubview(checkBoxView)
            cell.imageViewArea.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickBoxTapped)))
            
        }
        return cell
    }
    
  
}

extension MainVc: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addFielsInTableViewCells(indexPath: indexPath, tableView: tableView)
        return cell
    }
    
    
}

extension MainVc: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: Constants.goToPINPage, sender: self)
        } else if indexPath.row == 2 {
            addTransparentView()
            
            dropDownTableView.register(CellClass.self, forCellReuseIdentifier: "customCell")
            dropDownTableViewDelegateAndDataSource = DropDownTableViewProperties(elements: contents,vc: self)
            dropDownTableView.dataSource = dropDownTableViewDelegateAndDataSource
            dropDownTableView.delegate = dropDownTableViewDelegateAndDataSource
        }
    }
    
   
}

