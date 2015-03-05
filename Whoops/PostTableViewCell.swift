//
//  PostTableViewCell.swift
//  Whoops
//
//  Created by Li Jiatan on 2/27/15.
//  Copyright (c) 2015 Li Jiatan. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var PostImage: UIImageView!
    @IBOutlet weak var TimePosted: UILabel!    
    @IBOutlet weak var Replies: UILabel!
    @IBOutlet weak var ContentLable: UILabel!
    var data :NSDictionary!
    var imgWidth :CGFloat!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var content = self.data.stringAttributeForKey("content")
        imgWidth = self.PostImage.width()
        var height = content.stringHeightWith(17, width: imgWidth)
        self.ContentLable.setHeight(height)
        self.ContentLable.text = content
   
        //self.ContentLable.numberOfLines = 4
        //self.ContentLable.sizeToFit()
        
        var imgSrc = self.data.stringAttributeForKey("image") as NSString
        if imgSrc.length == 0 {
            self.PostImage.hidden = true
        }
        else
        {
            var imageId = self.data.stringAttributeForKey("id") as NSString
            var prefiximageId = imageId.substringToIndex(5)
            var imagURL = "http://pic.qiushibaike.com/system/pictures/\(prefiximageId)/\(imageId)/small/\(imgSrc)"
            self.PostImage!.hidden = false
            self.PostImage!.setImage(imagURL,placeHolder: UIImage(named: "avatar.jpg"))
            self.PostImage.setY(self.ContentLable.bottom()+5)

        }
        
    }
    
    class func cellHeightByData(data:NSDictionary)->CGFloat
    {
        var content = data.stringAttributeForKey("content")
        var height = content.stringHeightWith(17,width: 462)
        var imgSrc = data.stringAttributeForKey("image") as NSString
        if imgSrc.length == 0
        {
            return 59.0 + height + 150.0
        }
        return 59.0 + height + 5.0 + 112.0 + 150.0
    }

}
