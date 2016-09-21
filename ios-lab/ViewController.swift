//
//  ViewController.swift
//  ios-lab
//
//  Created by Junjun Deng on 20/09/2016.
//  Copyright © 2016 Junjun Deng. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func viewTapped(sender: UIButton) {
        let controller = PhotoListController.init(nibName: "SharePhoto", bundle: NSBundle.mainBundle())
        
        controller.assets = Array(ViewController.getAssets().prefix(3))
        self.navigationController?.presentViewController(controller, animated: true, completion: nil)
    }
    
    class func getAssets() -> [PHAsset] {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let fetchResult = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        var assets: [PHAsset] = []
        
        fetchResult.enumerateObjectsUsingBlock({ (object, _, _) in
            if let asset = object as? PHAsset {
                assets.append(asset)
            }
        })
        return assets
    }
    
}

