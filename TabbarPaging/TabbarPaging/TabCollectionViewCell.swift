//
//  TabCollectionViewCell.swift
//  TabbarPaging
//
//  Created by 박상우 on 2022/01/23.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {

    static let identifier = "TabCollectionViewCell"
    @IBOutlet private weak var title: UILabel!
    
    override var isSelected: Bool {
        willSet {
            self.title.textColor = newValue ? .black : .lightGray
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        isSelected = false
    }
    
    func configureCell(_ title: String) {
        self.title.text = title
    }

}
