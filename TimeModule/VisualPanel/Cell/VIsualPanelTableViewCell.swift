//
//  VIsualPanelTableViewCell.swift
//  WenoiUI
//
//  Created by Roushil Singla on 08/09/21.
//  Copyright © 2021 Arpana. All rights reserved.
//

import UIKit

class VIsualPanelTableViewCell: UITableViewCell {

    @IBOutlet weak var panelImage: UIImageView!
    @IBOutlet weak var panelLabel: UILabel!
    
    
    var panelModel: WenoiVisualPanelModel? {
        didSet {
            configureModels()
        }
    }
    
    var defaultImageName: String?
    var loadImageFromAssets = false
    var needToShowImage = true
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        panelImage.layer.cornerRadius = 5
    }

    
    private func configureModels() {
        if needToShowImage {
            panelImage.isHidden = false
            if panelModel?.image == "" || panelModel?.image == nil {
                panelImage.image = UIImage(named: defaultImageName ?? "defaultImage")
            } else {
                if loadImageFromAssets {
                    panelImage.image = UIImage(named: panelModel?.image ?? "none")
                } else {
                    panelImage.loadImageUsingCache(image: panelModel?.image ?? "")
                }
            }
        } else {
            panelImage.isHidden = true
        }
        panelLabel.text = panelModel?.name
    }
    
}
