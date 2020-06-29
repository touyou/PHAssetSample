//
//  ViewController.swift
//  PHAssetSample
//
//  Created by 藤井陽介 on 2020/06/29.
//  Copyright © 2020 touyou. All rights reserved.
//

import UIKit
import Photos

//
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //
    @IBOutlet var collectionView: UICollectionView!
    //
    @IBOutlet var startTextField: UITextField!
    //
    @IBOutlet var endTextField: UITextField!

    //
    var assetResult: PHFetchResult<PHAsset>!
    //
    var assets: [PHAsset] = []

    //
    let imageManager = PHImageManager.default()

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        //
        collectionView.dataSource = self
        //
        collectionView.delegate = self
    }

    //
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //
        PHPhotoLibrary.requestAuthorization { status in
            //
            if status == .authorized {
                //
                self.assetResult = PHAsset.fetchAssets(with: .image, options: nil)
                //
                DispatchQueue.main.async {
                    //
                    self.reloadImages(startAt: 0, endAt: 100)
                }
            }
        }
    }

    //
    func reloadImages(startAt: Int, endAt: Int) {
        //
        let endAt = endAt > assetResult.count ? assetResult.count : endAt
        //
        let indexSet = IndexSet(integersIn: startAt..<endAt)
        //
        assets = assetResult.objects(at: indexSet)

        //
        collectionView.reloadData()
    }

    func getCellSize() -> CGSize {
        //
        let viewWidth = collectionView.frame.width
        //
        let cellWidth = (viewWidth - 8.0) / 4.0
        //
        return CGSize(width: cellWidth, height: cellWidth)
    }

    //
    @IBAction func touchUpInsideReloadButton() {
        // 
        startTextField.resignFirstResponder()
        endTextField.resignFirstResponder()
        //
        guard let startText = startTextField.text,
            let startAt = Int(startText) else {
                return
        }
        //
        guard let endText = endTextField.text,
            let endAt = Int(endText) else {
                return
        }

        //
        if startAt >= endAt {
            //
            let alertController = UIAlertController(title: "入力値エラー", message: "入力値が不正です。", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
            return
        }

        //
        reloadImages(startAt: startAt, endAt: endAt)
    }

    //
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }

    //
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell

        //
        if let requestId = cell.requestId {
            imageManager.cancelImageRequest(requestId)
        }

        //
        cell.imageView.image = UIImage(named: "placeholder")
        //
        let item = assets[indexPath.row]
        //
        cell.requestId = imageManager.requestImage(
            for: item,
            targetSize: CGSize(width: 480, height: 480),
            contentMode: .aspectFill,
            options: nil) { image, _ in
                // 
                if image != nil {
                    cell.imageView.image = image
                }
        }

        return cell
    }

    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCellSize()
    }

    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }

    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }

    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}

