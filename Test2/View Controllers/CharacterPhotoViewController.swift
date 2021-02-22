//
//  CharacterPhotoViewController.swift
//  Test2
//
//  Created by NASTUSYA on 2/19/21.
//

import UIKit
import AVFoundation
import AVKit

class CharacterPhotoViewController: UIViewController {

    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photos: Array<String>?
    var videos: Array<String>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        photoCollectionView.delegate=self
        photoCollectionView.dataSource=self
        
        
    }
    
    func openVideoPlayer(_ ref: String){
        
        let url=URL(string: ref)
        let player = AVPlayer(url: url!)
        
        let vc = AVPlayerViewController()
        vc.player = player
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    
    

}

extension CharacterPhotoViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row>=photos!.count{
            let index=indexPath.row-photos!.count
            openVideoPlayer(videos![index])
        }
       
        
        collectionView.deselectItem(at: indexPath, animated: true)
        print("You tapped me")
    }
}

extension CharacterPhotoViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getNumberOfCells(photos, videos: videos)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Storyboard.collectionViewCell, for: indexPath) as! CharacterPhotoCell
        let border=photos!.count
        if indexPath.row<border{
            let url=photos![indexPath.row]
            downloadImage(url, image: cell.photoImageView)
        }
        else{
            let index=indexPath.row-photos!.count
            let url=URL(string: videos![index])
            createThumbnailOfVideoFromFileURL(videoURL: url!){
                (completion) in
                if completion==nil{
                    
                }
                else{
                    cell.photoImageView.image=completion
                }
                   
            }
        }
        return cell
    }
}

extension CharacterPhotoViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 3

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.estimatedItemSize = .zero

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
}

class CharacterPhotoCell: UICollectionViewCell{
    
    @IBOutlet weak var photoImageView: UIImageView!
    
}

func createThumbnailOfVideoFromFileURL(videoURL: URL, completion: ((_ image: UIImage?) -> Void)) {
        let asset = AVAsset(url: videoURL)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 7, timescale: 1)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            completion(thumbnail)
        } catch {
            print(error.localizedDescription)
            completion(nil)
        }
}

func getNumberOfCells(_ photos: Array<String>?, videos: Array<String>?)->Int{
        return photos!.count+videos!.count
}




