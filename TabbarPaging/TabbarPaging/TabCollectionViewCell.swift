//
//  TabCollectionViewCell.swift
//  TabbarPaging
//
//  Created by 박상우 on 2022/01/23.
//

import UIKit

class TabCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func configureCell(_ title: String) {
        self.title.text = title
    }

}
