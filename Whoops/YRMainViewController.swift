//
//  MainViewController.swift
//  Whoops
//
//  Created by huangyao on 15-2-26.
//  Copyright (c) 2015年 Li Jiatan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation



class YRMainViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, CLLocationManagerDelegate, YRRefreshViewDelegate{

    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    let identifier = "cell"
//    var tableView:UITableView?
    var dataArray = NSMutableArray()
    var page :Int = 1
    var refreshView:YRRefreshView?
    let locationManager: CLLocationManager = CLLocationManager()
    
    var lat:Double = 0
    var lng:Double = 0
    var school:Int = 0
    var userId:String = "0"
    
    var type:String = "new"
    
 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if(ios8()){
            if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            }
        }
        locationManager.startUpdatingLocation()
        userId = FileUtility.getUserId()
        setupViews()
        
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "imageViewTapped", object:nil)
        
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "imageViewTapped:", name: "imageViewTapped", object: nil)
    }
    
    
    
    func setupViews()
    {
        var width = self.view.frame.size.width
        var height = self.view.frame.size.height
//        self.tableView = UITableView(frame:CGRectMake(0,0,width,height-49))
        self.tableView!.delegate = self;
        self.tableView!.dataSource = self;
        //self.tableView!.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        //self.tableView.separatorColor = UIColor.redColor()
        
        var nib = UINib(nibName:"YRJokeCell", bundle: nil)
        
        self.tableView?.registerNib(nib, forCellReuseIdentifier: identifier)
        // self.tableView?.registerClass(YRJokeCell.self,
        //forCellReuseIdentifier: identifier)
        var arr =  NSBundle.mainBundle().loadNibNamed("YRRefreshView" ,owner: self, options: nil) as Array
        self.refreshView = arr[0] as? YRRefreshView
        self.refreshView!.delegate = self
        
        self.tableView!.tableFooterView = self.refreshView
        self.view.addSubview(self.tableView!)
        
        self.addRefreshControl()
    }
    
    
    func addRefreshControl(){
        var fresh:UIRefreshControl = UIRefreshControl()
        fresh.addTarget(self, action: "actionRefreshHandler:", forControlEvents: UIControlEvents.ValueChanged)
        fresh.tintColor = UIColor.redColor()
        fresh.attributedTitle = NSAttributedString(string: "reloading")
        self.tableView?.addSubview(fresh)
    }
    
    func actionRefreshHandler(sender:UIRefreshControl){
        page = 1
        var url = urlString(self.type)
        self.refreshView!.startLoading()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                UIView.showAlertView("Alert",message:"Loading Failed")
                return
            }
            
            var arr = data["data"] as NSArray
            
            self.dataArray = NSMutableArray()
            for data : AnyObject  in arr
            {
                self.dataArray.addObject(data)
                
            }
            self.page++
            self.tableView!.reloadData()
            self.refreshView!.stopLoading()
            
            sender.endRefreshing()
        })
        
    }
    
    func loadData(type:String)
    {
        var url = urlString(type)
        self.refreshView!.startLoading()
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                UIView.showAlertView("Alert",message:"Loading Failed")
                return
            }
            
            var arr = data["data"] as NSArray
            
            if self.page == 1 {
                self.dataArray = NSMutableArray()
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
    
    
    func urlString(typeString:String)->String
    {
        var url:String = FileUtility.getUrlDomain()
        if(school == 0){
            if typeString == "new"{
                url += "post/listNewByLocation?latitude=\(lat)&longitude=\(lng)&pageNum=\(page)"
            }else{
                url += "post/listHotByLocation?latitude=\(lat)&longitude=\(lng)&pageNum=\(page)"
            }
        }else{
            if typeString == "new" {
                url += "post/listNewBySchool?schoolId=\(school)&pageNum=\(page)"
            }else{
                url += "post/listHotBySchool?schoolId=\(school)&pageNum=\(page)"
            }
        }
        
        return url
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.dataArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as? YRJokeCell
        var index = indexPath.row
        var data = self.dataArray[index] as NSDictionary
        cell!.data = data
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat
    {
        var index = indexPath!.row
        var data = self.dataArray[index] as NSDictionary
        return  YRJokeCell.cellHeightByData(data)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!)
    {
        var index = indexPath!.row
        var data = self.dataArray[index] as NSDictionary
        var commentsVC = YRCommentsViewController(nibName :nil, bundle: nil)
        commentsVC.jokeId = data.stringAttributeForKey("id")
        commentsVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentsVC, animated: true)
    
//    self.performSegueWithIdentifier("showComment", sender:data.stringAttributeForKey("id"))
    
    }

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        var postId:String = sender as String;
//        
//        var commentViewController:YRCommentsViewController =  segue.destinationViewController as YRCommentsViewController;
//        commentViewController.postId = postId
//    }

    


    func refreshView(refreshView:YRRefreshView,didClickButton btn:UIButton)
    {
        //refreshView.startLoading()
        loadData(self.type)
    }
    
    func imageViewTapped(noti:NSNotification)
    {
        
        var imageURL = noti.object as String
        var imgVC = YRImageViewController(nibName: nil, bundle: nil)
        imgVC.imageURL = imageURL
        self.navigationController?.pushViewController(imgVC, animated: true)
        
        
    }
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
   
        var location:CLLocation = locations[locations.count-1] as CLLocation
        
        if (location.horizontalAccuracy > 0) {
            lat = location.coordinate.latitude
            lng = location.coordinate.longitude
            loadData(self.type)
            self.locationManager.stopUpdatingLocation()
            
          
        }
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
        //        self.textLabel.text = "get location error"
    }
    
   

    @IBAction func hotClick(){
        var selectIndex = segmentedControl.selectedSegmentIndex
        if selectIndex == 1{
            self.type = "hot"
            page = 1
            self.dataArray = NSMutableArray()
            loadData("hot")
        }else{
            self.type = "new"
            page = 1
            self.dataArray = NSMutableArray()
            loadData("new")
        }
    }
    
    func ios8()->Bool{
        let version:NSString = UIDevice.currentDevice().systemVersion
        let bigVersion = version.substringToIndex(1)
        let intBigVersion = bigVersion.toInt()
        if intBigVersion >= 8 {
            return true
        }else {
            return false
        }
        
    }

    
}
