//
//  CheckBoxView.swift
//  ScreenLockDesign
//
//  Created by surya-zstk231 on 22/06/21.
//

import UIKit

class CheckBoxView: UIView {
    
    let imageView: UIImageView = {
        let imageArea = UIImageView()
        imageArea.isHidden = false
        imageArea.isUserInteractionEnabled = true
        imageArea.contentMode = .scaleAspectFit
        imageArea.tintColor = .systemBlue
//        imageArea.image = UIImage(systemName: "checkmark")
        return imageArea
    }()
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGreen
        addSubview(imageView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
