//
//  SharePhotoController.swift
//  ActorSDK
//
//  Created by Ivy on 11/09/2016.
//  Copyright © 2016 SameMo. All rights reserved.
//

import UIKit
import Photos

public class PhotoListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var photosView: UITableView!
    @IBOutlet weak var labelView: UILabel!
    
    public var assets: [PHAsset] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.title = "Photos" // NSLocalizedString("SharePhoto", comment: "share photo")
        let cancelButtonItem = UIBarButtonItem(
            title: "Cancel", // NSLocalizedString("NativagtionCancel", comment: "cancel"), //("NavigationCancel"),
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: #selector(cancel)
        )
        self.navigationItem.setLeftBarButtonItem(cancelButtonItem, animated: false)
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        photosView.dataSource = self
        photosView.rowHeight = UITableViewAutomaticDimension
        photosView.estimatedRowHeight = 360
        
        view.addConstraint(NSLayoutConstraint(item: labelView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 8))
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let reuseId = "ImageCell"
        photosView.registerClass(ImageCell.self, forCellReuseIdentifier: reuseId)
        let cell: ImageCell = tableView.dequeueReusableCellWithIdentifier(reuseId, forIndexPath: indexPath) as! ImageCell
        let asset = assets[indexPath.row]
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFit, options: PHImageRequestOptions(), resultHandler: { (image, _) in
            cell.updateImage(image)
        })
        return cell
    }
    
    //    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //        let asset = assets[indexPath.row]
    //        let ratio: CGFloat = CGFloat(asset.pixelHeight) / CGFloat(asset.pixelWidth)
    //        let height = tableView.size.width * ratio
    //        return height
    //    }
    
    func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

class ImageCell: UITableViewCell {
    var ratio: CGFloat = 1
    let photoView: UIImageView = UIImageView()
    
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            //            oldValue?.active = false
            //            aspectConstraint?.active = true
            if oldValue != nil {
                photoView.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                //                self.contentView.bounds = CGRectMake(0, 0, 99999, 99999);
                //                self.bounds = CGRectMake(0, 0, 99999, 99999);
//                aspectConstraint?.priority = 999
                photoView.addConstraint(aspectConstraint!)
                //                setNeedsLayout()
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        photoView.contentMode = UIViewContentMode.ScaleAspectFit
        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.setContentCompressionResistancePriority(UILayoutPriorityFittingSizeLevel, forAxis: UILayoutConstraintAxis.Vertical)
//        photoView.setContentCompressionResistancePriority(UILayoutPriorityRequired, forAxis: .Horizontal)
        contentView.setContentHuggingPriority(UILayoutPriorityDefaultHigh, forAxis: .Vertical)
        //        contentView.translatesAutoresizingMaskIntoConstraints = false
        //        self.bounds = CGRectMake(0, 0, 99999, 99999);
        
        // fixes an iOS 8 issue with UIViewEncapsulated height 44 bug
        //        self.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight;
        //        self.frame = CGRectMake(0, 0, self.frame.size.width, 300);
        //        self.translatesAutoresizingMaskIntoConstraints = false
        
        //        self.contentView.bounds = CGRectMake(0, 0, 99999, 99999);
        //        self.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        self.contentView.addSubview(photoView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        let view = photoView
        //        self.contentView.bounds = CGRectMake(0, 0, 99999, 99999);
        //        self.bounds = CGRectMake(0, 0, 99999, 99999);
        //        contentView.removeConstraints(contentView.constraints)
        
        contentView.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view.superview, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
        //        contentView.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view.superview, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 8))
        let bottomConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -8)
        bottomConstraint.priority = 999
        contentView.addConstraint(bottomConstraint)
        //        view.removeConstraints(view.constraints)
        contentView.addConstraint(NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: view.superview, attribute: .Width, multiplier: 1, constant: 0))
        //        let aspectConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Width, multiplier: ratio, constant: 0)
        //        aspectConstraint.priority = UILayoutPriorityDefaultHigh
        //        contentView.addConstraint(aspectConstraint)
        //        aspectConstraint.active = true
        
        super.updateConstraints()
    }
    //    override func layoutSubviews() {
    //        if let image = photoView.image {
    //            ratio = image.size.height / image.size.width
    //            let height = self.bounds.width * ratio
    //            photoView.frame = CGRectMake(0.0, 0.0, self.bounds.width, height)
    //        }
    //    }
    
    internal func updateImage(image: UIImage?) {
        // imageView?.image = image
        photoView.image = image
        if let image = image {
            ratio = image.size.height / image.size.width
        }
        let height = photoView.bounds.width * ratio
//        aspectConstraint = NSLayoutConstraint(item: photoView, attribute: NSLayoutAttribute.Height, relatedBy: .Equal, toItem: photoView, attribute: NSLayoutAttribute.Width, multiplier: ratio, constant: 0)
        aspectConstraint = NSLayoutConstraint(item: photoView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 0, constant: height)
        //        setNeedsUpdateConstraints()
        //        setNeedsLayout()
        //        layoutIfNeeded()
    }
    
    //    override func intrinsicContentSize() -> CGSize {
    //        let width = contentView.bounds.width
    //        let height = width * ratio
    //        return CGSize(width: width, height: height)
    //    }
}
