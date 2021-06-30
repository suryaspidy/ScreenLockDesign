//
//  DropDownTableViewProperties.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 21/06/21.
//

import Foundation
import UIKit

class CellClass: UITableViewCell{
    
}
class DropDownTableViewProperties: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    let millsecondsConstantValues = [60000,300000,600000,3600000,0]
    var contents:[String]
    var parentVc:MainVc
    init(elements: [String],vc: MainVc) {
        self.contents = elements
        self.parentVc = vc
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        cell.textLabel?.text = contents[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(millsecondsConstantValues[indexPath.row], forKey: Constants.UserGivenTimeDuration)
        parentVc.removeTransparentView()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
