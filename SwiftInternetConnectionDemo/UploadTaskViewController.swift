//
//  UploadTaskViewController.swift
//  SwiftInternetConnectionDemo
//
//  Created by lokizero00 on 2017/11/24.
//  Copyright © 2017年 lokizero00. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices

class UploadTaskViewController: UIViewController {
    @IBOutlet weak var buttonUpload:UIButton?
    @IBOutlet weak var imagePreview:UIImageView?
    @IBOutlet weak var buttonPick:UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title="上传"
        self.view.backgroundColor=UIColor.white
        
        buttonUpload?.addTarget(self, action: #selector(self.sessionUpload), for: .touchUpInside)
        buttonPick?.addTarget(self, action: #selector(self.pickFromAlbum), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func sessionUpload(){
        if let uploadImage=imagePreview?.image{
            let imagedata=UIImagePNGRepresentation(uploadImage)
            let uploadUrl="http://127.0.0.1:8080/ios-server-web/common/upload"
            UploadDataManager.share.uploadLocalData(data: imagedata!, parameters: ["id":"12345"], hostUrl: uploadUrl, withName: "file", fileName: "barIcon.png", type: uploadType.png
                , comparBlock: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON(completionHandler: {
                            response in
                            if response.result.isSuccess{
                                if let json=response.result.value{
                                    let result = json as! [String:String]
                                    if result["status"]=="ok"{
                                        print(result["status"]!)
                                        print(result["msg"]!)
                                        //成功后要干什么
                                    }else{
                                        print(result["status"]!)
                                        print(result["error"]!)
                                        //失败要干什么
                                    }
                                }
                            }
                        })
                    case .failure(let encodingError):
                        print(encodingError)
                        //失败要干什么
                    }
                    
            })
        }else{
            //弹窗提示选择图片
            NOPictureAlert()
        }
    }
    
    @objc func pickFromAlbum(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let picker=UIImagePickerController()
            picker.delegate=self
            
            picker.mediaTypes=[kUTTypeImage as String,kUTTypeVideo as String]
            picker.allowsEditing=true
            picker.sourceType=UIImagePickerControllerSourceType.photoLibrary
            self.present(picker, animated: true, completion: nil)
        }else{
            print("相机读取错误")
        }
    }
    
    func NOPictureAlert() {
        let alertVC = UIAlertController(title: " 警告", message: "请先选择需要上传的照片", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
//            (action: UIAlertAction) -> Void in
//            /**
//             写取消后操作
//             */
//        })
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {
            (action: UIAlertAction) -> Void in
            /**
             写确定后操作
             */
        })
//        alertVC.addAction(cancelAction)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
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

extension UploadTaskViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        
        let image=info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePreview?.image=image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
