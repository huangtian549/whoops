//
//  SearchResultCell.swift
//  Whoops
//
//  Created by Li Jiatan on 3/5/15.
//  Copyright (c) 2015 Li Jiatan. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
    var isHighLighted = Bool()
    var currentIndex = Int()
    var favorite = []
    @IBOutlet weak var frontImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeBtnSelected(sender: UIButton) {
        
        dispatch_async(dispatch_get_main_queue(),{
            if self.isHighLighted == false
            {
                self.isHighLighted = true
                self.likeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)
            }
            else
            {
                self.isHighLighted = false
                self.likeButton.setImage(UIImage(named: "115"), forState: UIControlState.Normal)
            }
        })
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
