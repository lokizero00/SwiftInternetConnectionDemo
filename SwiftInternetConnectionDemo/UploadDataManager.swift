//
//  UploadDataManager.swift
//  SwiftInternetConnectionDemo
//
//  Created by lokizero00 on 2017/11/28.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import Foundation
import Alamofire

enum uploadType:String{
    //纯文本
    case textOnly="text/plain"
    //HTML文档
    case html="text/html"
    //XHTML文档
    case xhtml="application/xhtml+xml"
    //gif图片
    case gif="image/gif"
    //jpeg图片
    case jpeg="image/jpeg"
    //png图片
    case png="image/png"
    // mpeg动画
    case mpeg="video/mpeg"
    //任意二进制数据
    case any="application/octet-stream"
    //PDF文档
    case pdf="application/pdf"
    //Word文档
    case word="application/msword"
    //RFC 822形式
    case rfc822 = "message/rfc822"
    //HTML邮件的HTML形式和纯文本形式，相同内容使用不同形式表示
    case alternative = "multipart/alternative"
    //使用HTTP的POST方法提交的表单
    case urlencoded = "application/x-www-form-urlencoded"
    //使用HTTP的POST方法提交的表单,但主要用于表单提交时伴随文件上传的场合
    case formdata = "multipart/form-data"
}

class UploadDataManager:NSObject{
    public static let share=UploadDataManager()
    
    private override init() {}
    
    // 上传文件
    //
    // - Parameters:
    //   - data: 二进制流
    //   - parameters: 参数字典数组
    //   - hostUrl: 服务器地址
    //   - withName: 与后台协商的名字,服务器端获取文件：multipartHttpServletRequest.getFile(withName)
    //   - fileName: 文件名
    //   - type: 上传文件类型
    //   - comparBlock: 将结果返回的闭包
    public func uploadLocalData(data:Data,parameters:[String:String]?,hostUrl:String,withName:String,fileName:String,type:uploadType,comparBlock:@escaping (SessionManager.MultipartFormDataEncodingResult)->Void){
            let headers = ["content-type":"multipart/form-data"]
            Alamofire.upload(multipartFormData: {multipartFormData in multipartFormData.append(data, withName: withName, fileName: fileName, mimeType: type.rawValue)
                if (parameters != nil) {
                    for parameter in parameters! {
                        multipartFormData.append(parameter.value.data(using: .utf8)!, withName: parameter.key)
                    }
                }
            }, to: hostUrl,headers: headers, encodingCompletion: {
                encodingResult in
                comparBlock(encodingResult)
                
            })
    }
}
