//
//  AppleLoginManager.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/09.
//

import Foundation
import AuthenticationServices

final class AppleLoginManager: NSObject {
    
    weak var viewController: UIViewController?
    
    private var userID: String?
    
    func setAppleLoginPresentationAnchorView(_ view: UIViewController) {
        self.viewController = view
    }
}

extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return viewController!.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            
            userID = userIdentifier
            
            let userFirstName = appleIDCredential.fullName?.givenName
            let userLastName = appleIDCredential.fullName?.familyName
            let userEmail = appleIDCredential.email
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            let username = passwordCredential.user
            let password = passwordCredential.password
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\(error) 가입이 안되었음")
    }
    
   // applicationDidBecomeActive
    func applicationDidBecomeActive(_ application: UIApplication) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        if let id = userID {
            appleIDProvider.getCredentialState(forUserID: id) { credentialState, error in
                switch credentialState {
                case .revoked:
                    print("인증 만료")
                case .authorized:
                    print("인증 성공")
                case .notFound:
                    print("인증 불가")
                default:
                    print("디폴트")
                }
            }
        }
    }
    
}
