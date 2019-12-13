//
//  AuthenticationManager.swift
//  KeyManagerDemo
//
//  Created by ma c on 2019/12/11.
//  Copyright © 2019 ma c. All rights reserved.
//

import UIKit
import LocalAuthentication

class AuthenticationManager: NSObject {

    enum UnLockSupportType {
        case none
        case touchID
        case faceID
    }
    
    enum UnLockResult {
        case fail
        case success
    }
    
    var supportType : UnLockSupportType?
    
    private var context : LAContext?
    
//    typealias UnLockResultBlock = @escaping (_ result : UnLockResult, _ errMessage : String) -> ()
    
    static let shared : AuthenticationManager = {
        
        let shared = AuthenticationManager()
        
        return shared
    }()
    
    override init() {
        super.init()
        
        context = LAContext()
    }
    
    class func checkUnLockSupportType() -> UnLockSupportType {
        
        var unlockType = UnLockSupportType.none
        
        let context = LAContext()
        
        var error : NSError? = nil
        let isCanEvaluatePolicy : Bool = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if error != nil {
            
            print("检测设备是否支持TouchID或者FaceID失败！\n error : == \(error?.localizedDescription ?? "未知错误")")
        }else {
            
            if isCanEvaluatePolicy {
                
                if #available(iOS 11.0, *) {
                    
                    switch context.biometryType {
                    case .none:
                        break
                    case .touchID:
                        unlockType = .touchID
                        break
                    case .faceID:
                        unlockType = .faceID
                        break
                    default:
                        break
                    }
                    
                } else {
                    // Fallback on earlier versions
                    unlockType = .touchID
                }
            }
        }
        
        self.shared.supportType = unlockType
        
        return unlockType
    }
    
    class func unlock(with result : UnLockResult, completion :  @escaping (_ result : UnLockResult, _ errMessage : String) -> ()) {
        
        if self.shared.supportType == AuthenticationManager.UnLockSupportType.none {
            
            return ;
        }
        
        let context : LAContext = self.shared.context!
        context.localizedFallbackTitle = "请输入密码"
        
        var policy : LAPolicy = .deviceOwnerAuthenticationWithBiometrics
        
        var error : NSError?
        
        if #available(iOS 11.0, *) {
            
            policy = .deviceOwnerAuthentication
        }
        
        if context.canEvaluatePolicy(policy, error: &error) {
            
            var str : String! = ""
            
            if self.shared.supportType == AuthenticationManager.UnLockSupportType.touchID {
                
                str = "通过Home键验证已有手机指纹"
            }else if self.shared.supportType == .faceID {
                
                str = "请正对屏幕启动脸部识别"
            }
            
            context.evaluatePolicy(policy, localizedReason: str!) { (success, error) in
                
                if success {
                    
                    let asyncQueue = DispatchQueue.init(label: "com.ed.queue.success")
                    
                    asyncQueue.async {
                        
                        completion(.success, "")
                    }
                }else {
                    
                    let asyncQueue = DispatchQueue.init(label: "com.ed.queue.fail")
                    
                    if error != nil {
                        
                        let laError = error as! LAError
                        
                        switch laError.code {
                        case .authenticationFailed:
                            
                            asyncQueue.async {
                                
                                print("TouchID 验证失败")
                            }
                            break
                        case .userCancel:
                            
                            asyncQueue.async {
                                
                                print("TouchID 验证被用户主动取消")
                            }
                            
                            break
                        case .userFallback:
                            
                            asyncQueue.async {
                                
                                print("用户不使用touchID，请主动输入密码")
                            }
                            
                            break
                        
                        case .systemCancel:
                            
                            asyncQueue.async {
                                
                                print("TouchID 验证被系统取消（遇到来电，锁屏或者按了home键）")
                            }
                            break
                            
                        case .passcodeNotSet:
                            
                            asyncQueue.async {
                                
                                print("TouchID 无法启动,因为用户没有设置密码")
                            }
                            break
                        case .touchIDNotEnrolled:
                            
                            asyncQueue.async {
                                
                                print("TouchID 无法启动,因为用户没有设置TouchID")
                            }
                            break
                        case .touchIDNotAvailable:
                            asyncQueue.async {
                                
                                print("TouchID 不可用")
                            }
                            break
                        case .touchIDLockout:
                            asyncQueue.async {
                                
                                print("TouchID 被锁定(连续多次验证TouchID失败,系统需要用户手动输入密码)")
                            }
                            break
                        case .appCancel:
                            
                            asyncQueue.async {
                                
                                print("当前软件被挂起并取消了授权 (如App进入了后台等)")
                            }
                            break
                        case .invalidContext:
                            
                            asyncQueue.async {
                                
                                print("当前软件被挂起并取消了授权 (LAContext对象无效)")
                            }
                            break
                        default:
                            break
                        }
                    }
                }
            }
        }else {
            
            completion(UnLockResult.fail, "touchID失效")
        }
        
    }
}
