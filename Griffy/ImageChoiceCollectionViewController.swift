//
//  ImageChoiceCollectionViewController.swift
//  Griffy
//
//  Created by Sam Goldstein on 12/6/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation
import UIKit

class ImageChoiceCollectionViewController: UICollectionViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.backgroundColor = UIColor.lightText
    view.backgroundColor = UIColor.lightText
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageChoiceCell", for: indexPath) as? ImageChoiceCell else {
      assertionFailure("ImageChoiceCell not found")
      return UICollectionViewCell()
    }
    let griff = GriffyImageGetter.getAllImages()[indexPath.row]
    cell.setupWithGriffy(griffy: griff)
    return cell
  }
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return GriffyImageGetter.getAllImages().count
  }
}

extension ImageChoiceCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let yourWidth = (collectionView.bounds.width-20)/2.0
    let yourHeight = CGFloat(230)
    
    return CGSize(width: yourWidth, height: yourHeight)
  }
}
