//
//  CheckActionViewController.swift
//  SwiftInternetConnectionDemo
//
//  Created by lokizero00 on 2017/10/16.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit

class CheckActionViewController: UIViewController {
    @IBOutlet weak var buttonCheck:UIButton?
    @IBOutlet weak var labelResult:UILabel?
    @IBOutlet weak var labelDesc:UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title="检测网络"
        self.view.backgroundColor=UIColor.white
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()
        
        buttonCheck?.addTarget(self, action: #selector(self.checkInternet), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //网络变化通知
    @objc func networkStatusChanged(_ notifiaction:Notification){
        let userInfo=(notifiaction as NSNotification).userInfo
        labelDesc?.text=userInfo?.description
    }
    
    @objc func checkInternet(){
        let status=Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            labelResult?.text="Not connected"
        case .online(.wwan):    //wwan为蜂窝网络
            labelResult?.text="Connected via WWAN，蜂窝"
        case .online(.wiFi):
            labelResult?.text="Connected via WiFi"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
