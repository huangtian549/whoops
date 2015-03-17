//
//  SearchViewController.swift
//  Whoops
//
//  Created by Li Jiatan on 3/5/15.
//  Copyright (c) 2015 Li Jiatan. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating,YRRefreshViewDelegate,YRRefreshSearchViewDelegate{
    
    
    @IBOutlet weak var searchTableView: UITableView!
    var _db = NSMutableArray()
    var myFavorite = NSMutableArray()
    var nearby = NSMutableArray()
    var filteredTableData = []
    var dbUrl = String()
    var nearbyUrl = String()
    var myFavoriteUrl = String()
    var resultSearchController = UISearchController()
    var refreshView: YRRefreshView?
    //var sendFavorite:YRSendComment?

    var uid = String()
    var lat = Double()
    var lng = Double()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.searchBar.backgroundColor = UIColor.clearColor()
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.placeholder = "Search your School"
            self.searchTableView.tableHeaderView = controller.searchBar
            return controller
        })()
        self.lat = 37.9
        self.lng = -122.4
        
        //self.sendFavorite?.delegate = self
        self.uid = FileUtility.getUserId()
        self.dbUrl = "http://104.131.91.181:8080/whoops/school/getAll"
        self.nearbyUrl = "http://104.131.91.181:8080/whoops/school/listSchoolByLocation?latitude=\(self.lat)&longitude=\(self.lng)"
        self.myFavoriteUrl = "http://104.131.91.181:8080/whoops/favorSchool/listByUid?uid=\(self.uid)"
        
        self.searchTableView.reloadData()
        loadDB(nearbyUrl, target: nearby)
        loadDB(dbUrl, target: _db)
        loadDB(myFavoriteUrl, target: myFavorite)
        
        
        var arr =  NSBundle.mainBundle().loadNibNamed("YRRefreshView" ,owner: self, options: nil) as Array
        self.refreshView = arr[0] as? YRRefreshView
        self.refreshView?.delegate = self
//        self.addRefreshControl()
        
    }
    
    func addRefreshControl(){
        
        
        var refresh = UIRefreshControl()
        refresh.addTarget(self, action: "actionRefreshHandler:", forControlEvents: UIControlEvents.ValueChanged)
        refresh.tintColor = UIColor.whiteColor()
        self.searchTableView.addSubview(refresh)
    }
    
    func actionRefreshHandler(sender: UIRefreshControl)
    {

        var url = "http://104.131.91.181:8080/whoops/favorSchool/listByUid?uid=\(self.uid)"
        self.myFavorite.removeAllObjects()
        self.refreshView!.startLoading()
        
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                UIView.showAlertView("Opps",message:"Loading Failed")
                return
            }
            
            var arr = data["data"] as NSArray
            
            self.myFavorite = NSMutableArray()
            for data : AnyObject  in arr
            {
                self.myFavorite.addObject(data)
                
            }
            self.searchTableView.reloadData()
        })
        
        /*self.refreshView?.startLoading()
        self.myFavorite.removeAllObjects()
        self.nearby.removeAllObjects()
        let nearbyUrl = "http://104.131.91.181:8080/whoops/school/listSchoolByLocation?latitude=\(self.lat)&longitude=\(self.lng)"
        let myFavoriteUrl = "http://104.131.91.181:8080/whoops/favorSchool/listByUid?uid=\(self.uid)"
        loadDB(myFavoriteUrl, target: self.myFavorite)
        loadDB(nearbyUrl, target: self.nearby)*/
        
        //self.searchTableView.reloadData()
        self.refreshView!.stopLoading()
        
        sender.endRefreshing()

    }
    
    
    func refreshSearchView(){
        var url = "http://104.131.91.181:8080/whoops/favorSchool/listByUid?uid=\(self.uid)"
        self.myFavorite.removeAllObjects()
        self.refreshView!.startLoading()
        
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                UIView.showAlertView("Opps",message:"Loading Failed")
                return
            }
            
            var arr = data["data"] as NSArray
            
            self.myFavorite = NSMutableArray()
            for data : AnyObject  in arr
            {
                self.myFavorite.addObject(data)
                
            }
            self.searchTableView.reloadData()
        })
        
        /*self.refreshView?.startLoading()
        self.myFavorite.removeAllObjects()
        self.nearby.removeAllObjects()
        let nearbyUrl = "http://104.131.91.181:8080/whoops/school/listSchoolByLocation?latitude=\(self.lat)&longitude=\(self.lng)"
        let myFavoriteUrl = "http://104.131.91.181:8080/whoops/favorSchool/listByUid?uid=\(self.uid)"
        loadDB(myFavoriteUrl, target: self.myFavorite)
        loadDB(nearbyUrl, target: self.nearby)*/
        
        //self.searchTableView.reloadData()
        self.refreshView!.stopLoading()
        
        

    }
    
    func refreshView(refreshView:YRRefreshView,didClickButton btn:UIButton)
    {

    }
    
    func refreshCommentView(refreshView:YRSendComment,didClickButton btn:UIButton){
        loadDB(myFavoriteUrl, target: myFavorite)
    }
    
    func loadDB(var url:String, var target: NSMutableArray)
    {
        //if target === self.myFavorite {self.myFavorite.removeAllObjects()}
        YRHttpRequest.requestWithURL(url,completionHandler:{ data in
            
            if data as NSObject == NSNull()
            {
                let myAltert=UIAlertController(title: "Alert", message: "No Network Access", preferredStyle: UIAlertControllerStyle.Alert)
                myAltert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(myAltert, animated: true, completion: nil)
                return
            }
            
            var arr = data["data"] as NSArray
            
            for data : AnyObject  in arr
            {
                target.addObject(data)
            }
            self.searchTableView.reloadData()
            // self.refreshView!.stopLoading()
            //self.page++
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.resultSearchController.active
        {
            return 1
        }else
        {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultSearchController.active
        {
            return self.filteredTableData.count
        }
        else
        {
            switch (section){
            case 0: return self.myFavorite.count
            case 1: return self.nearby.count
            default: return 0
            }
        }
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headCell = tableView.dequeueReusableCellWithIdentifier("headCell") as SearchHeadCell
        headCell.backgroundView = nil
        
        if self.resultSearchController.active
        {
            return headCell
        }
        else
        {
            switch (section){
            case 0: headCell.header.text = "我喜欢的"
            case 1: headCell.header.text = "附近的"
            default: headCell.header.text = nil
            }
            
            switch (section){
            case 0: headCell.headImg.image = UIImage(named: "unlike")
            case 1: headCell.headImg.image = UIImage(named: "Nearby")
            default: headCell.headImg.image = nil
            }
        }
        return headCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  self.resultSearchController.active {return 0}
        else { return 50}
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("searchResult") as SearchResultCell
        var row = indexPath.row
        cell.currentIndex = indexPath.row
        cell.delegate = self
        
        if self.resultSearchController.active
        {
            //let myFavoriteUrl = "http://104.131.91.181:8080/whoops/favorSchool/listByUid?uid=\(self.uid)"
            //loadDB(myFavoriteUrl, target: self.myFavorite)
            var data = self.filteredTableData[row] as NSDictionary
            cell.title.text = data.stringAttributeForKey("nameCn")
            //cell.title.text = self.filteredTableData[row]
            cell.data = data
            cell.uid = self.uid
                
            cell.isHighLighted = false
            cell.backgroundView = nil
            cell.backgroundColor = UIColor.clearColor()
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.likeButton.setImage(UIImage(named: "115"), forState: UIControlState.Normal)
            return cell
        }
        else
        {
            if indexPath.section == 0
            {
                cell.favorite = self.myFavorite
                //cell.title.text = self.myFavorite[row]
                var data = self.myFavorite[row] as NSDictionary
                cell.title.text = data.stringAttributeForKey("nameCn")
                cell.data = data
                //cell.uid = FileUtility.getUserId()
                cell.uid = self.uid
                
                cell.isHighLighted = true
                cell.backgroundView = nil
                cell.backgroundColor = UIColor.clearColor()
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                //if cell.flag {
                //    loadDB(myFavoriteUrl, target: myFavorite)
                //    self.searchTableView.reloadData()
                //    cell.flag = false
                //}
                
                cell.likeButton.setImage(UIImage(named: "Like"), forState: UIControlState.Normal)

                return cell
            }
            
            if indexPath.section == 1
            {
                //cell.title.text = self.nearby[row]
                var data = self.nearby[row] as NSDictionary
                cell.title.text = data.stringAttributeForKey("nameCn")
                cell.data = data
                //cell.uid = FileUtility.getUserId()
                cell.uid = self.uid
                
                //if cell.flag{
                //    self.searchTableView.reloadData()
                //    cell.flag = false
                //}
                
                cell.isHighLighted = false
                cell.backgroundView = nil
                cell.backgroundColor = UIColor.clearColor()
                //cell.tailImg.image = UIImage(named: "115")
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.likeButton.setImage(UIImage(named: "115"), forState: UIControlState.Normal)
                return cell
            }
        }
        return cell
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        
        let searchPredicate = NSPredicate(format: "nameCn contains[cd] %@", searchController.searchBar.text)
        //var searchPredicate = NSPredicate(format: ("nameEn contains[cd] %@" || "nameCn contains[cd] %@"), searchController.searchBar.text)
        let array = _db.filteredArrayUsingPredicate(searchPredicate!)
        
        filteredTableData = array
        self.searchTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var university = segue.destinationViewController as UniversityViewController
        if let indexPath = self.searchTableView.indexPathForSelectedRow() {
            if self.resultSearchController.active
            {
                self.resultSearchController.resignFirstResponder()
                var data = self.filteredTableData[indexPath.row] as NSDictionary
                let selectedUniversity = data.stringAttributeForKey("nameCn")
                university.schoolId = data.stringAttributeForKey("id")
                university.currentUniversity = selectedUniversity
                self.resultSearchController.active = false
            }
            else
            {
                if indexPath.section == 0{
                    var data = self.myFavorite[indexPath.row] as NSDictionary
                    let selectedUniversity = data.stringAttributeForKey("nameCn")
                    university.schoolId = data.stringAttributeForKey("schoolId")
                    university.currentUniversity = selectedUniversity
                }
                if indexPath.section == 1{
                    var data = self.nearby[indexPath.row] as NSDictionary
                    let selectedUniversity = data.stringAttributeForKey("nameCn")
                    university.schoolId = data.stringAttributeForKey("id")
                    university.currentUniversity = selectedUniversity
                }
            }
        }
    }


}
