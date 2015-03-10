//
//  MyPostCommentViewController.swift
//  Whoops
//
//  Created by Li Jiatan on 3/8/15.
//  Copyright (c) 2015 Li Jiatan. All rights reserved.
//

import UIKit

class MyPostCommentViewController: UITableViewController, YRRefreshViewDelegate {
    
    let identifier = "cell"
    var dataArray = NSMutableArray()
    var page :Int=1
    var refreshView:YRRefreshView?
    var jokeId:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comments"
        self.tableView.backgroundColor = UIColor(red: 0.173, green: 0.133, blue: 0.361, alpha: 1.0)
        setupViews()
        loadData()
    }
    
    func setupViews()
    {
        var nib = UINib(nibName: "YRCommnentsCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: identifier)
        var arr =  NSBundle.mainBundle().loadNibNamed("YRRefreshView" ,owner: self, options: nil) as Array
        self.refreshView = arr[0] as? YRRefreshView
        self.refreshView!.delegate = self
        self.tableView.tableFooterView = self.refreshView
    }
    
    func loadData()
    {
        //var url = "http://m2.qiushibaike.com/article/\(self.jokeId)/comments?count=20&page=\(self.page)"
        //var url = FileUtility.getUrlDomain() + "post/get?id=\(self.jokeId)"
        var url = "http://104.131.91.181:8080/whoops/comment/getCommentByPostId?postId=\(self.jokeId)"
        self.refreshView!.startLoading()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                UIView.showAlertView("Oops!",message:"Refresh Failed")
                return
            }
            
            var arr = data["data"] as NSArray
            if arr.count  == 0
            {
                UIView.showAlertView("Oops",message:"No more Comments T_T")
                self.tableView!.tableFooterView = nil
            }
            for data : AnyObject  in arr
            {
                self.dataArray.addObject(data)
            }
            self.tableView!.reloadData()
            self.refreshView!.stopLoading()
            self.page++
        })
    }
    
    func refreshView(refreshView:YRRefreshView,didClickButton btn:UIButton)
    {
        //refreshView.startLoading()
        loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as YRCommnentsCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var index = indexPath.row
        var data = self.dataArray[index] as NSDictionary
        cell.data = data
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        var index = indexPath.row
        var data = self.dataArray[index] as NSDictionary
        return  YRCommnentsCell.cellHeightByData(data)
    }
    

}
