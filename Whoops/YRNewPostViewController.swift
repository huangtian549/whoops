//
//  YRNewPostViewController.swift
//  Whoops
//
//  Created by huangyao on 15-2-26.
//  Copyright (c) 2015年 Li Jiatan. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreLocation



class YRNewPostViewController: UIViewController, UIImagePickerControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,CLLocationManagerDelegate{
    
   

    @IBOutlet weak var contentTextView: UITextView!
 
    @IBOutlet weak var sendItem: UIBarButtonItem!

    @IBOutlet weak var nickName: UITextField!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var nickNameText: UITextField!
    
    let locationManager = CLLocationManager()
 
    
    var imgView = UIImageView()
    var img = UIImage()
    
    var schoolId:String = "0"
    
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    let pickerViewArray = ["相机","图片库","取消"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.frame = CGRectMake(100, 240, 100, 100)
        self.view.addSubview(imgView)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.startUpdatingLocation()
        }

        
    }
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        
        var location:CLLocation = locations[locations.count-1] as CLLocation
        
        if (location.horizontalAccuracy > 0) {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            
            self.locationManager.stopUpdatingLocation()
            println(location.coordinate)
            
            println("latitude \(location.coordinate.latitude) longitude \(location.coordinate.longitude)")
        }
    }

    
    
    @IBAction func photoButtonClick(sender: AnyObject) {
        var actionSheet = UIActionSheet()
        actionSheet.addButtonWithTitle("取消")
        actionSheet.addButtonWithTitle("打开照相机")
        actionSheet.addButtonWithTitle("从手机相册选择")
        actionSheet.cancelButtonIndex = 0
        actionSheet.delegate = self
        
        actionSheet.showInView(self.view)
        
        
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        var sourceType = UIImagePickerControllerSourceType.Camera
        if buttonIndex == actionSheet.cancelButtonIndex {
            return
        }else if buttonIndex == 1{
            sourceType = UIImagePickerControllerSourceType.Camera
        }else{
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        
        self.presentViewController(picker, animated: true, completion: nil)//进入照相界面
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        
        img = info[UIImagePickerControllerEditedImage] as UIImage
        imgView.image = img
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    //cancel后执行的方法
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "sendSegue" {
            var content:String = contentTextView!.text
            println(content)
            if countElements(content) == 0 {
                UIView.showAlertView("提示",message:"内容不能为空")
                
                
            }else{
                if imgView.image == nil {
                    createNewPost()
                }else{
                    postWithPic()
                }
            }
            
        }
        
    }
    
    func updateLocation(latitude:Double, longitude:Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createNewPost(){
        var content = contentTextView.text;
        var url = FileUtility.getUrlDomain() + "post/addNoPic?"
        var paraData = "content=\(content)"
        var nickName:String = nickNameText.text
        if countElements(nickName) > 0{
            paraData += "&nickName=\(nickName)"
        }
        
        if schoolId == "0" {
            paraData += "&latitude=\(latitude)&longitude=\(longitude)"
        }else{
            paraData += "&schoolId=\(schoolId)"
        }
        
        
        
        var data:NSMutableArray = YRHttpRequest.postWithURL(urlString: url, paramData: paraData)

    }
    func postWithPic(){
        var content = contentTextView.text;
        var nickName:String = nickNameText.text
        var request = createRequest(content: content, nickName: nickName)
        NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)

        
//        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
//            data, response, error in
//            
//            if error != nil {
//                // handle error here
//                return
//            }
//            
//            // if response was JSON, then parse it
//            
//            var parseError: NSError?
//            let responseObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError)
//            
//            if let responseDictionary = responseObject as? NSDictionary {
//                // handle the parsed dictionary here
//            } else {
//                // handle parsing error here
//            }
//            
//            // if response was text or html, then just convert it to a string
//            //
//            // let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//            // println("responseString = \(responseString)")
//            
//            // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
//            //
//            // dispatch_async(dispatch_get_main_queue()) {
//            //     // update your UI and model objects here
//            // }
//        })
//        task.resume()
        
    }
    
    func createRequest (#content: String, nickName: String) -> NSURLRequest {
        var param = [
            "content"  : content,
            "nickName" : nickName
            ]  // build your dictionary however appropriate
        if schoolId == "0" {
            param["latitude"] = toString(self.latitude)
            param["longitude"] = toString(self.longitude)
        }else{
            param["schoolId"] = toString(self.schoolId)
        }
        
        let boundary = generateBoundaryString()
        
        let url:String = FileUtility.getUrlDomain() + "post/add?"
//        let url:String = "http://192.168.1.4:8080/whoops/" + "post/add?"
        let nsurl = NSURL(string: url)
        let request = NSMutableURLRequest(URL: nsurl!)
        request.HTTPMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
//        let path1 = NSBundle.mainBundle().pathForResource("image1", ofType: "png") as String!
//        let path2 = NSBundle.mainBundle().pathForResource("image2", ofType: "jpg") as String!
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", boundary: boundary)
        
        return request
    }
    
    /// Create body of the multipart/form-data request
    ///
    /// :param: parameters   The optional dictionary containing keys and values to be passed to web service
    /// :param: filePathKey  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
    /// :param: paths        The optional array of file paths of the files to be uploaded
    /// :param: boundary     The multipart/form-data boundary
    ///
    /// :returns:            The NSData of the body of the request
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, boundary: String) -> NSData {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
//        if paths != nil {
//            for path in paths! {
                let filename = "file"
                let data:NSData = UIImageJPEGRepresentation(imgView.image, 0.3)
//                let mimetype = mimeTypeForPath(path)
        
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
                body.appendString("Content-Type: application/octet-stream\r\n\r\n")
                body.appendData(data)
                body.appendString("\r\n")
//            }
//        }
        
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    /// Create boundary string for multipart/form-data request
    ///
    /// :returns:            The boundary string that consists of "Boundary-" followed by a UUID string.
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    /// Determine mime type on the basis of extension of a file.
    ///
    /// This requires MobileCoreServices framework.
    ///
    /// :param: path         The path of the file for which we are going to determine the mime type.
    ///
    /// :returns:            Returns the mime type if successful. Returns application/octet-stream if unable to determine mime type.
    
    func mimeTypeForPath(path: String) -> String {
        let pathExtension = path.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as NSString
            }
        }
        return "application/octet-stream";
    }
    
    
    func uploadImageOne(){
        var imageData = UIImageJPEGRepresentation(imgView.image, 0.3)
        
        if imageData != nil{
            var url:String = FileUtility.getUrlDomain() + "post/add?"
            var nsurl = NSURL(string: url)
            var request = NSMutableURLRequest(URL:nsurl!)
            request.HTTPMethod = "POST"
            
            var bodyData = "content="+contentTextView.text
            
            
//            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
//            request.HTTPBody = NSData(data: UIImagePNGRepresentation(imgView.image))
//            println("miraqui \(request.debugDescription)")
//            var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
//            var HTTPError: NSError? = nil
//            var JSONError: NSError? = nil
//            
//            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: {
//                data, response, error in
//                
//                if error != nil {
//                    // handle error here
//                    return
//                }
//                
//                // if response was JSON, then parse it
//                
//                var parseError: NSError?
//                let responseObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &parseError)
//                
//                if let responseDictionary = responseObject as? NSDictionary {
//                    // handle the parsed dictionary here
//                } else {
//                    // handle parsing error here
//                }
//                
//                // if response was text or html, then just convert it to a string
//                //
//                // let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
//                // println("responseString = \(responseString)")
//                
//                // note, if you want to update the UI, make sure to dispatch that to the main queue, e.g.:
//                //
//                // dispatch_async(dispatch_get_main_queue()) {
//                //     // update your UI and model objects here
//                // }
//            })
//            task.resume()
            
//            var dataVal: NSData? =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &HTTPError)
//            
//            if ((dataVal != nil) && (HTTPError == nil)) {
//                var jsonResult = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: &JSONError)
//                
//                if (JSONError != nil) {
//                    println("Bad JSON")
//                } else {
//                    println("Synchronous\(jsonResult)")
//                }
//            } else if (HTTPError != nil) {
//                println("Request failed")
//            } else {
//                println("No Data returned")
//            }
            
//            var url:String = FileUtility.getUrlDomain() + "post/add?content=\(contentTextView.text)"
//            var nsurl = NSURL(fileURLWithPath: url)
//            var request = NSMutableURLRequest(URL: nsurl!)
            var session = NSURLSession.sharedSession()
            
            request.HTTPMethod = "POST"
            
            var boundary = NSString(format: "---------------------------14737809831466499882746641449")
            var contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            //  println("Content Type \(contentType)")
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            
            var body = NSMutableData.alloc()
            
            // Title
            body.appendData(NSString(format: "\r\n--%@\r\n",boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"title\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData("Hello World".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!)
            
            // Image
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format:"Content-Disposition: form-data; name=\"profile_img\"; filename=\"img.jpg\"\\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            body.appendData(imageData)
            body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
            
            
            
            request.HTTPBody = body
            
            let task = NSURLSession.sharedSession().uploadTaskWithRequest(request, fromData: imageData, completionHandler: {data, response, error -> Void in
                
                println(request)
                println(response)
                // println(payload)
                
            })
            task.resume()
            
//            var returnData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
//            
//            if returnData != nil{
//                var returnString = NSString(data: returnData!, encoding: NSUTF8StringEncoding)
//            
//                println("returnString \(returnString)")
//            }
        }
        
        
    }

    
    
}