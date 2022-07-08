//
//  Reachability.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/07/08.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa

final class Reachability {
    
    static var shared: Reachability = Reachability()
    
    /// Monitors general network reachability.
    let reachability = NetworkReachabilityManager()
    
    var didBecomeReachable: Signal<Void> { return _didBecomeReachable.asSignal() }
    private let _didBecomeReachable = PublishRelay<Void>()
    
    init() {
        if let reachability = self.reachability {
            reachability.startListening { [weak self] (status) in
                self?.update(status)
            }
        }
    }
    
    private func update(_ status: NetworkReachabilityManager.NetworkReachabilityStatus) {
//        if case .reachable = status {
            _didBecomeReachable.accept(())
//        }
    }
    
}
