//
//  AppLockMainPageCell.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 16/06/21.
//

import UIKit

class AppLockMainPageCell: UITableViewCell {

    @IBOutlet weak var titleLabelArea: UILabel!
    @IBOutlet weak var subTitleLabelArea: UILabel!
    @IBOutlet weak var imageViewArea: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewArea.alpha = 0
        imageViewArea.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
