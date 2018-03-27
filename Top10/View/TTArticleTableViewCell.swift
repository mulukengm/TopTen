//
//  TTArticleTableViewCell.swift
//  Top10
//
//  Created by Muluken Gebremariam on 11/1/17.
//  Copyright © 2017 Keeple. All rights reserved.
//

import UIKit
import QuartzCore

class TTArticleTableViewCell: UITableViewCell {
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var sectionLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var abstractLabel: UILabel!
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.numberLabel.layer.cornerRadius = self.numberLabel.frame.size.width / 2
        self.numberLabel.layer.borderWidth = 2.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.numberLabel.text = nil
        self.sectionLabel.text = nil
        self.titleLabel.text = nil
        self.abstractLabel.text = nil
        
        self.sectionLabel.textColor = TTUtil.colorFor(section: "")
        self.numberLabel.textColor = TTUtil.colorFor(section: "")
        self.numberLabel.backgroundColor = UIColor.clear
        
        self.backgroundColor = UIColor.clear
    }
}
