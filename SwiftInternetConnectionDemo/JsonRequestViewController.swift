//
//  JsonRequestViewController.swift
//  SwiftInternetConnectionDemo
//
//  Created by lokizero00 on 2017/11/20.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit

class JsonRequestViewController: UIViewController {
    
    @IBOutlet weak var label_id:UILabel?
    @IBOutlet weak var label_userName:UILabel?
    @IBOutlet weak var label_password:UILabel?
    @IBOutlet weak var buttonRequestSync:UIButton?
    @IBOutlet weak var buttonRequestAsync:UIButton?
    @IBOutlet weak var text_userName:UITextField?
    @IBOutlet weak var text_password:UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title="Json请求"
        self.view.backgroundColor=UIColor.white
        
        buttonRequestSync?.addTarget(self, action: #selector(self.httpSyncRequest), for: .touchUpInside)
        buttonRequestAsync?.addTarget(self, action: #selector(self.httpAsyncRequest), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //同步请求，使用post方式
    @objc func httpSyncRequest(){
        let strUrl="http://127.0.0.1:8080/ios-server-web/user/addUserMobile"
        let userName=text_userName!.text
        let password=text_password!.text
        let strBody="userName=\(userName!)&password=\(password!)"
        let postNSData=strBody.data(using: .utf8)
        let url=URL(string: strUrl)
        
        var request=URLRequest(url: url!)
        request.httpMethod="POST"
        request.httpBody=postNSData
        
        //用于同步操作的信号量
        let semaphore=DispatchSemaphore(value: 0)
        
        //初始化请求
        let dataTask=URLSession.shared.dataTask(with: request, completionHandler: {
            (data,response,error) in
            
            if(error != nil){
                print(error.debugDescription)
            }else{
                let responseStr=String(data:data!,encoding:.utf8)
                //包体数据
                print(responseStr!)
                
                //URLResponse类里没有http返回值， 需要先强制转换！
                let httpResponse=response as? HTTPURLResponse
                if(httpResponse != nil){
                    if(httpResponse!.statusCode==200){
                        if let json=try? JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:Any] {
                             /* 返回json数据格式      {"status":"ok","msg":"welcome","data":["100","220","300","400"]} ，具体看Server端定义的返回格式    */
//                            //读取普通数据
//                            let strMsg2 = json["msg"] as! String
//                            print(strMsg2)
//
//                            //读取数组
//                            var array: [String] = json["data"] as! [String]
//                            for index in 0..<array.count{
//                                print( array[index])
//                            }
                            
                            let status=json["status"] as! String
                            let msg = json["msg"] as! String
                            if(status != "ok"){
                                let error=json["error"] as! String
                                //通知UI接口,服务器错误
                                print("服务器错误：\(error)")
                            }else{
                                print("调用成功，返回信息：\(msg)")
                            }
                        }
                    }else{
                         //通知UI接口执行失败
                        print("网络请求失败，错误代码：\(httpResponse!.statusCode)")
                    }
                }
            }
            semaphore.signal()
        }) as URLSessionTask
        dataTask.resume()
        
        //信号量等待状态
        _=semaphore.wait(timeout: .distantFuture)
        print("执行完毕")
    }
    
    //异步请求，使用get方式
    @objc func httpAsyncRequest(){
        buttonRequestAsync?.isEnabled=false
        let strUrl="http://127.0.0.1:8080/ios-server-web/user/getUserInJson?id=6"
        let url=URL(string: strUrl)
        
        var request=URLRequest(url: url!)
        request.httpMethod="GET"
        
        //初始化请求
        let dataTask=URLSession.shared.dataTask(with: request, completionHandler: {
            (data,response,error) in
            if error != nil {
                print(error.debugDescription)
            }else{
                //URLResponse类里没有http返回值， 需要先强制转换！
                let httpResponse=response as? HTTPURLResponse
                if (httpResponse != nil) {
                    if (httpResponse!.statusCode==200) {
                        if let json=try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]{
                            /* 返回json数据格式      {"status":"ok","msg":"welcome","data":["100","220","300","400"]} ，具体看Server端定义的返回格式    */
//                            //读取普通数据
//                            let strMsg2 = json["msg"] as! String
//                            print(strMsg2)
//
//                            //读取数组
//                            var array: [String] = json["data"] as! [String]
//                            for index in 0..<array.count{
//                                print( array[index])
//                            }

                            let id=json["id"] as! Int
                            let userName = json["userName"] as! String
                            let password=json["password"] as! String
                            
                            //更新UI需要在主线程中执行
                            DispatchQueue.main.async {
                                self.label_id?.text="\(id)"
                                self.label_userName?.text=userName
                                self.label_password?.text=password
                                
                                self.buttonRequestAsync?.isEnabled=true
                            }
                        }
                    }else{
                        //通知UI接口执行失败
                        print("网络请求失败，错误代码：\(httpResponse!.statusCode)")
                    }
                }
            }
        }) as URLSessionTask
        
        dataTask.resume()
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
