//
//  PageCollectionViewCell.swift
//  TabbarPaging
//
//  Created by 박상우 on 2022/01/23.
//

import UIKit

class PageCollectionViewCell: UICollectionViewCell {
    static let identier = "PageCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(color: UIColor) {
        self.backgroundColor = color
    }
}
