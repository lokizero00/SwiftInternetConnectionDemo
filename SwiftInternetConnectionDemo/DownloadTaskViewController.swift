//
//  DownloadTaskViewController.swift
//  SwiftInternetConnectionDemo
//
//  Created by lokizero00 on 2017/11/24.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit

class DownloadTaskViewController: UIViewController {
    @IBOutlet weak var imageView:UIImageView?
    @IBOutlet weak var buttonDownloadSimple:UIButton?
    @IBOutlet weak var buttonDownloadAdvance:UIButton?
    @IBOutlet weak var downloadProgress:UILabel?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title="下载"
        self.view.backgroundColor=UIColor.white
        
        buttonDownloadSimple?.addTarget(self, action: #selector(self.downloadSimple), for: .touchUpInside)
        buttonDownloadAdvance?.addTarget(self, action: #selector(self.downloadAdvance), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //简单下载，没有下载进度
    @objc func downloadSimple(){
        downloadProgress?.text="0%"
        let url=URL(string: "http://127.0.0.1:8080/ios-server-web/images/test01.png")
        let request=URLRequest(url: url!)
        
        let session=URLSession.shared
        let downloadTask=session.downloadTask(with: request, completionHandler: {
            (location,response,error)->Void in
            
            //输出下载文件原来的存放目录
            print("location:\(location!)")
            
            //location位置转换
            let locationPath=location?.path
            
            //复制到我们自己的目录中
            let imageSavePath:String = NSHomeDirectory()+"/Documents/1.png"
            
            //创建文件管理器
            let fileManager:FileManager=FileManager.default
            
            do{
                try fileManager.moveItem(atPath: locationPath!, toPath: imageSavePath)
            }catch let error as NSError {
                print("失败：\(error)")
            }
            print("image saved path:\(imageSavePath)")
            
            DispatchQueue.main.async {
                let image=UIImage(named: imageSavePath)
                self.imageView?.image=image
            }
        })
        //使用resume方法启动任务
        downloadTask.resume()
    }
    
    //带进度的下载
    @objc func downloadAdvance(){
        downloadProgress?.text="0%"
        let url=URL(string: "http://127.0.0.1:8080/ios-server-web/images/test01.png")
        let request=URLRequest(url: url!)
        let session=URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let downloadTask=session.downloadTask(with: request)
        downloadTask.resume()
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

//声明实现URLSessionDownloadDelegate代理，用于监听下载进度等
extension DownloadTaskViewController :URLSessionDownloadDelegate{
    //下载结束回调事件
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("下载结束")
        
        print("location:\(location)")
        
        let locationPath=location.path
        
        let imageSavePath:String = NSHomeDirectory()+"/Documents/1.png"
        
        let fileManager:FileManager=FileManager.default
        
        do{
            try fileManager.moveItem(atPath: locationPath, toPath: imageSavePath)
        }catch let error as NSError {
            print("失败：\(error)")
        }
        print("image saved path:\(imageSavePath)")
        
        DispatchQueue.main.async {
            let image=UIImage(named: imageSavePath)
            self.imageView?.image=image
        }
    }
    
    //监听下载进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let written:CGFloat=(CGFloat) (bytesWritten)
        let total:CGFloat=(CGFloat) (totalBytesExpectedToWrite)
        
        let pro:CGFloat=(written/total)*100
        
        DispatchQueue.main.async {
            self.downloadProgress?.text="\(pro)%"
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //下载偏移，主要用于暂停续传
    }
}
