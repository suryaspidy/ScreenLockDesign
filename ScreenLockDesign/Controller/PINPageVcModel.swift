//
//  PINPageVc.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 16/06/21.
//

import UIKit

class PINPageVcModel: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightAnchor: NSLayoutConstraint!
    @IBOutlet weak var fillViewOne: UIView!
    @IBOutlet weak var fillViewTwo: UIView!
    @IBOutlet weak var fillViewThree: UIView!
    @IBOutlet weak var fillViewFour: UIView!
    
    var countOfTappedPIN:Int = 0
    
    var password:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialAlignments()
        fixHeight()
//        collectionView.register(UINib(nibName: Constants.oneAndNinezBtnNibName, bundle: nil), forCellWithReuseIdentifier: Constants.oneAndNinezBtnID)
//        collectionView.register(UINib(nibName: Constants.twoToNineBtnsNibName, bundle: nil), forCellWithReuseIdentifier: Constants.twoToNineBtnsID)
//        collectionView.register(UINib(nibName: Constants.deleteBtnNibName, bundle: nil), forCellWithReuseIdentifier: Constants.deleteBtnID)
        collectionView.register(collCell.self, forCellWithReuseIdentifier: "ModelCollCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
    }
    
    func initialAlignments(){
        fillViewOne.layer.borderColor = UIColor.systemGreen.cgColor
        fillViewTwo.layer.borderColor = UIColor.systemGreen.cgColor
        fillViewThree.layer.borderColor = UIColor.systemGreen.cgColor
        fillViewFour.layer.borderColor = UIColor.systemGreen.cgColor
        
        fillViewOne.backgroundColor = .systemGray
        fillViewTwo.backgroundColor = .systemGray
        fillViewThree.backgroundColor = .systemGray
        fillViewFour.backgroundColor = .systemGray
        
        fillViewOne.layer.borderWidth = 2
        fillViewTwo.layer.borderWidth = 2
        fillViewThree.layer.borderWidth = 2
        fillViewFour.layer.borderWidth = 2
        
        fillViewOne.layer.cornerRadius = fillViewOne.frame.height/2
        fillViewTwo.layer.cornerRadius = fillViewTwo.frame.height/2
        fillViewThree.layer.cornerRadius = fillViewThree.frame.height/2
        fillViewFour.layer.cornerRadius = fillViewFour.frame.height/2
    }
    
    
    func fixHeight(){
        print(collectionView.frame.width)
        let originalHeight = collectionView.frame.width / 3
        let updatedHeight = originalHeight * 4
        collectionViewHeightAnchor.constant = updatedHeight
        print(collectionView.frame.height)
    }
    
    func changeIndicatorColour(indexPath: IndexPath){
        if countOfTappedPIN < 0{
            countOfTappedPIN = 0
        }
        if countOfTappedPIN > 0{
            fillViewOne.backgroundColor = .systemGreen
            if countOfTappedPIN > 1 {
                fillViewTwo.backgroundColor = .systemGreen
                if countOfTappedPIN > 2 {
                    fillViewThree.backgroundColor = .systemGreen
                    if countOfTappedPIN > 3 {
                        fillViewFour.backgroundColor = .systemGreen
                        initialAlignments()
                        countOfTappedPIN = 0
                        let alert = UIAlertController(title: "Youe PIN update succesfully", message: "", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Done", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    
    func seperateCollectionViewCell(indexPath: IndexPath, collectionView: UICollectionView) ->UICollectionViewCell{
        print(indexPath.row)
//        if indexPath.row == 0 || indexPath.row == 10{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.oneAndNinezBtnID, for: indexPath) as! OneAndZeroBtn
//            cell.numberLabelArea.text = Constants.collectionViewNumberValues[indexPath.row]
//            cell.viewHeightValue.constant = collectionView.frame.height/4 - 1
//            cell.viewWidthValue.constant = collectionView.frame.width/3 - 1
//            return cell
//        } else if indexPath.row == 11 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.deleteBtnID, for: indexPath) as! DltBtn
//            cell.viewHeightValue.constant = collectionView.frame.height/4 - 1
//            cell.viewWidthValue.constant = collectionView.frame.width/3 - 1
//            return cell
//        } else if indexPath.row == 9{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.oneAndNinezBtnID, for: indexPath) as! OneAndZeroBtn
//            cell.viewHeightValue.constant = collectionView.frame.height/4 - 1
//            cell.viewWidthValue.constant = collectionView.frame.width/3 - 1
//            cell.numberLabelArea.text = ""
//            cell.alpha = 0
//            cell.isUserInteractionEnabled = false
//            return cell
//        }
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.twoToNineBtnsID, for: indexPath) as! TwoToNineBtn
//            cell.viewHeightValue.constant = collectionView.frame.height/4 - 1
//            cell.viewWidthValue.constant = collectionView.frame.width/3 - 1
//            cell.numericLabelArea.text = Constants.collectionViewNumberValues[indexPath.row]
//            cell.alphLabelArea.text = Constants.collectionViewAlphValues[indexPath.row-1]
//            print(collectionView.frame.height)
//            return cell
//        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModelCollCell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
}

extension PINPageVcModel: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = seperateCollectionViewCell(indexPath: indexPath, collectionView: collectionView)
//        return cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModelCollCell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    
}
extension PINPageVcModel: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 11 {
            countOfTappedPIN -= 1
            if countOfTappedPIN >= 0 {
                password.remove(at: password.count-1)
            }
            print(password)
            initialAlignments()
        } else {
            countOfTappedPIN += 1
            password.append(Constants.collectionViewNumberValues[indexPath.row])
            print(password)
        }
        changeIndicatorColour(indexPath: indexPath)
    }
}

extension PINPageVcModel: UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width/3 - 1
//        let height = collectionView.frame.height/4 - 1
//
//        return CGSize(width: width, height: height)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(100)
    }
}


class collCell: UICollectionViewCell{
    
}
