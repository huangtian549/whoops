//
//  YRCommnentsCell.swift
//  JokeClient-Swift
//
//  Created by YANGReal on 14-6-7.
//  Copyright (c) 2014年 YANGReal. All rights reserved.
//

import UIKit

class YRCommnentsCell: UITableViewCell {

    
   
    
    var data :NSDictionary!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        // var uid = self.data["id"] as String
                var content = self.data.stringAttributeForKey("content")
        var height = content.stringHeightWith(17,width:300)
//        self.contentLabel!.setHeight(height)
//        self.contentLabel!.text = content
//        self.dateLabel!.setY(self.contentLabel!.bottom())
//        var floor = self.data.stringAttributeForKey("floor")
//        self.floorLabel!.text = "\(floor)楼"
    }

    
    @IBAction func likeImageClick(){
        let myalert = UIAlertView()
        myalert.title = "准备好了吗"
        myalert.message = "准备好开始了吗？"
        myalert.addButtonWithTitle("Ready, go!")
        myalert.show()
    }
    
    @IBAction func unlikeImageClick(){
        let myalert = UIAlertView()
        myalert.title = "准备好了吗"
        myalert.message = "准备好开始了吗？"
        myalert.addButtonWithTitle("Ready, go!")
        myalert.show()
    }

    
    
    class func cellHeightByData(data:NSDictionary)->CGFloat
    {
        var content = data.stringAttributeForKey("content")
        var height = content.stringHeightWith(17,width:300)
        return 53.0 + height + 24.0
    }

    
}
