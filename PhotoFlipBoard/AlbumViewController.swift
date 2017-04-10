//
//  AlbumViewController.swift
//  PhotoFlipBoard
//
//  Created by Miltan on 4/8/17.
//  Copyright © 2017 Milton. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var imageAlbumView: UIImageView!
    
    var imageDictionary:Dictionary<Int, Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func loop(){
        for index in 1...(imageDictionary?.count)! {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index)*(0.3)) {
                self.imageAlbumView.image = self.imageDictionary?[index] as? UIImage
//                let imageView: UIImageView = UIImageView(image: self.imageDictionary?[index] as? UIImage)
//                imageView.frame = self.view.frame
//                self.moveImage(view: imageView)
//                self.view.addSubview(imageView as UIView)
            }
        }
    }
//    @IBAction func SwitchToCamera(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "cameraView") as! ViewController
//        self.present(nextViewController, animated:true, completion:nil)
//    }
//
//    func moveImage(view: UIImageView){
//        let toPoint: CGPoint = CGPoint(x: 0.0, y: -10.0)
//        let fromPoint : CGPoint = CGPoint.zero
//        
//        let movement = CABasicAnimation(keyPath: "movement")
//        movement.isAdditive = true
//        movement.fromValue =  NSValue(cgPoint: fromPoint)
//        movement.toValue =  NSValue(cgPoint: toPoint)
//        movement.duration = 0.3
//        
//        view.layer.add(movement, forKey: "move")
//    }
}
