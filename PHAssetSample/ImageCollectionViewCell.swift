//
//  ImageCollectionViewCell.swift
//  PHAssetSample
//
//  Created by 藤井陽介 on 2020/06/29.
//  Copyright © 2020 touyou. All rights reserved.
//

import UIKit
import Photos

//
class ImageCollectionViewCell: UICollectionViewCell {
    //
    @IBOutlet var imageView: UIImageView!
    //
    var requestId: PHImageRequestID?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
