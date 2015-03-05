//
//  MyPostsViewController.swift
//  Whoops
//
//  Created by Li Jiatan on 2/27/15.
//  Copyright (c) 2015 Li Jiatan. All rights reserved.
//

import UIKit
import Foundation

class MyPostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var myPosts = NSMutableArray()
    let identifier = "myPost"
    var page:Int = 1
    
    @IBOutlet weak var PostTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func loadData(){
        var url = urlString()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                //UIView.showAlertView("Alert",message:"Refresh failed")
                let myAltert=UIAlertController(title: "Alert", message: "Refresh Failed", preferredStyle: UIAlertControllerStyle.Alert)
                myAltert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(myAltert, animated: true, completion: nil)
                return
            }
            
            var arr = data["items"] as NSArray
            
            for data : AnyObject  in arr
            {
                self.myPosts.addObject(data)
            }
            self.PostTableView.reloadData()
           // self.refreshView!.stopLoading()
           // self.page++
        })
    }
    
    func urlString() ->String{
        return "http://m2.qiushibaike.com/article/list/latest?count=20&page=\(page)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myPosts.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? PostTableViewCell
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as PostTableViewCell
        
        var data = self.myPosts[indexPath.row] as NSDictionary
        cell.data = data
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var index = indexPath.row
        var data = self.myPosts[index] as NSDictionary
        return  PostTableViewCell.cellHeightByData(data)
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
