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
        
        /*let url: URL?
        url=URL(string: "https://r8---sn-cxauxaxjvh-hn9z.googlevideo.com/videoplayback?expire=1613856852&ei=9CsxYOS-OYqzyQWMupOIBg&ip=178.121.81.197&id=o-AOyi1Rfy95PdlN-CEeIbqYoPsX57NW2Yaq07ZSxTYPnZ&itag=22&source=youtube&requiressl=yes&mh=8x&mm=31,26&mn=sn-cxauxaxjvh-hn9z,sn-4g5e6nzy&ms=au,onr&mv=m&mvi=8&pcm2cms=yes&pl=22&initcwndbps=896250&vprv=1&mime=video/mp4&ns=ZCrtgt2L1YGBNYRjbzmrRnEF&cnr=14&ratebypass=yes&dur=87.655&lmt=1573122925285686&mt=1613834923&fvip=8&c=WEB&txp=1306222&n=6IASvQO3Lb3HbTfz&sparams=expire,ei,ip,id,itag,source,requiressl,vprv,mime,ns,cnr,ratebypass,dur,lmt&sig=AOq0QJ8wRQIgIeFHYWMRWMoLNTel2-jFV8OrmS9LnbnNowItA5oHARcCIQD6sS5AkvKzDPuJDtz0IGRlc9rZTaT9KgOz5K7ZaUOqbQ==&lsparams=mh,mm,mn,ms,mv,mvi,pcm2cms,pl,initcwndbps&lsig=AG3C_xAwRAIgLPOpQqocJGBcUxyet75nudYD-Y54KnqHVZ0PDqegPzQCIAQNnIaCEVK2fVBtuT0o_suLcBCYus33jDqZwq_m0GUk")!
    
        let player = AVPlayer(url: url!)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }*/
        
        photoCollectionView.delegate=self
        photoCollectionView.dataSource=self
        
        
        
    }
    

}

extension CharacterPhotoViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        if indexPath.row<photos!.count{
            let url=photos![indexPath.row]
            downloadImage(url, image: cell.photoImageView)
        }
        else{
            let url=URL(string:videos![indexPath.row])
            if let thumbnailImage = getThumbnailImage(forUrl: url!) {
                cell.photoImageView.image = thumbnailImage
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

func getThumbnailImage(forUrl url: URL) -> UIImage? {
    let asset: AVAsset = AVAsset(url: url)
    let imageGenerator = AVAssetImageGenerator(asset: asset)

    do {
        let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
        return UIImage(cgImage: thumbnailImage)
    } catch let error {
        print(error)
    }

    return nil
}

func getNumberOfCells(_ photos: Array<String>?, videos: Array<String>?)->Int{
    if photos==nil && videos==nil{
        return 0
    }
    else if videos==nil{
        return photos!.count
    }
    else if photos==nil{
        return videos!.count
    }
    else{
        return photos!.count+videos!.count
    }
}



