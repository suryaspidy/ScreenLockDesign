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
    
    var selectedCell = UITableViewCell()
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        initialState()
        mainTableView.register(UINib(nibName: Constants.AppLockMainPageCellNibName, bundle: nil), forCellReuseIdentifier: Constants.AppLockMainPageCellID)
        mainTableView.dataSource = self
        mainTableView.isScrollEnabled = false
        mainTableView.delegate = self
        
        
    }

    
    let datePicker = UIDatePicker()
    let typePicker = UIPickerView()
    
    
    func createTypePicker(){
        typePicker.delegate = self
        typePicker.dataSource = self
        selectedCell.addSubview(typePicker)
    }
    
    func initialState(){
        topSwitch.setOn(false, animated: true)
        subContentsHeightAnchor.constant = 0
        mainTableView.isUserInteractionEnabled = false
    }
    
    @IBAction func topSwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
                subContentsHeightAnchor.constant = 300
                mainTableView.isUserInteractionEnabled = true

        } else {
                initialState()
            
        }
    }
    
  
}

extension MainVc: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.AppLockMainPageCellID, for: indexPath) as! AppLockMainPageCell
        cell.titleLabelArea.text = Constants.AppLockMainPageCellTitles[indexPath.row]
        cell.subTitleLabelArea.text = Constants.AppLockMainPageCellSubTitles[indexPath.row]
        return cell
    }
    
    
}

extension MainVc: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: Constants.goToPINPage, sender: self)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: Constants.goToFingerPrintLockPage, sender: self)
        } else if indexPath.row == 2 {
            selectedCell = tableView.cellForRow(at: indexPath)!
            dataSource = ["Apple", "Mango", "Orange"]
            createTypePicker()
            mainTableView.layer.masksToBounds = false
        }
    }
}



extension MainVc: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var selectedStr = dataSource[row]

        
    }
}
