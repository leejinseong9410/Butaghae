//
//  UserdefaultsManager.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/04.
//

import Foundation

/**
 * Singletone
 */
class UserdefaultsManager {
    
    private let ud = UserDefaults.standard
    
    static let shared = UserdefaultsManager()
    
    enum ShowChangedFilterType: Int {
        case none
        case show
        case completed
    }
    
    /**
     * MARK: Bool get/set
     */
    private let KEY_IS_SHOW_PERMISSION = "is_seen_permission"
    var isSeenPermission: Bool {
        get {
            return ud.bool(forKey: KEY_IS_SHOW_PERMISSION)
        }
        set {
            ud.set(newValue, forKey: KEY_IS_SHOW_PERMISSION)
            ud.synchronize()
        }
    }
    
    private let KEY_IS_SHOW_AGREEMENT = "is_seen_agreement"
    var isSeenAgreement: Bool {
        get {
            return ud.bool(forKey: KEY_IS_SHOW_AGREEMENT)
        }
        set {
            ud.set(newValue, forKey: KEY_IS_SHOW_AGREEMENT)
            ud.synchronize()
        }
    }
    
    private let KEY_ACCESS_TOKEN = "access_token"
    var accessToken: String? {
        get {
            return ud.string(forKey: KEY_ACCESS_TOKEN)
        }
        set {
            guard let s = newValue else {
                return
            }
            ud.set(s, forKey: KEY_ACCESS_TOKEN)
            ud.synchronize()
        }
    }
    
    private let KEY_DEVICE_TOKEN = "device_token"
    var deviceToken: String? {
        get {
            return ud.string(forKey: KEY_DEVICE_TOKEN)
        }
        set {
            guard let s = newValue else {
                return
            }
            ud.set(s, forKey: KEY_DEVICE_TOKEN)
            ud.synchronize()
        }
    }
    
    private let KEY_SEND_SERVER_DEVICE_TOKEN = "send_server_device_token"
    var isSendServerDeviceToken: Bool {
        get {
            return ud.bool(forKey: KEY_SEND_SERVER_DEVICE_TOKEN)
        }
        set {
            ud.set(newValue, forKey: KEY_SEND_SERVER_DEVICE_TOKEN)
            ud.synchronize()
        }
    }
    
    private let KEY_MEMBERSHIP_CARD = "membership_card"
    var membershipCard: [String]? {
        get {
            return ud.stringArray(forKey: KEY_MEMBERSHIP_CARD)
        }
        set {
            guard let s = newValue else {
                ud.setValue(nil, forKey: KEY_MEMBERSHIP_CARD)
                return
            }
            ud.set(s, forKey: KEY_MEMBERSHIP_CARD)
            ud.synchronize()
        }
    }
    
    private let KEY_FILTER_CHARGER_TYPE = "filter_charger_type"
    var filterChargerType: [String]? {
        get {
            return ud.stringArray(forKey: KEY_FILTER_CHARGER_TYPE)
        }
        set {
            guard let s = newValue else {
                ud.setValue(nil, forKey: KEY_FILTER_CHARGER_TYPE)
                return
            }
            ud.set(s, forKey: KEY_FILTER_CHARGER_TYPE)
            ud.synchronize()
        }
    }
    
    private let KEY_FILTER_OP_ORG = "filter_op_org"
    var filterOpOrg: [String]? {
        get {
            return ud.stringArray(forKey: KEY_FILTER_OP_ORG)
        }
        set {
            guard let s = newValue else {
                ud.setValue(nil, forKey: KEY_FILTER_OP_ORG)
                return
            }
            ud.set(s, forKey: KEY_FILTER_OP_ORG)
            ud.synchronize()
        }
    }
    
    private let KEY_FILTER_IS_FAST = "filter_is_fast"
    var isFastCharger: Bool {
        get {
            return ud.bool(forKey: KEY_FILTER_IS_FAST)
        }
        set {
            ud.set(newValue, forKey: KEY_FILTER_IS_FAST)
            ud.synchronize()
        }
    }
    
    private let KEY_FILTER_IS_SUPPORTED_ONLY = "filter_is_supported_only"
    var isSupportedOnly: Bool {
        get {
            return ud.bool(forKey: KEY_FILTER_IS_SUPPORTED_ONLY)
        }
        set {
            ud.set(newValue, forKey: KEY_FILTER_IS_SUPPORTED_ONLY)
            ud.synchronize()
        }
    }
    
    private let KEY_IS_SHOW_CHANGED_FILTER = "filter_is_changed"
    var isShowChangedFilter: ShowChangedFilterType {
        get {
            if let value = ud.value(forKey: KEY_IS_SHOW_CHANGED_FILTER) as? Int {
                return ShowChangedFilterType(rawValue: value) ?? .none
            }
            
            return .none
        }
        set {
            ud.set(newValue.rawValue, forKey: KEY_IS_SHOW_CHANGED_FILTER)
            ud.synchronize()
        }
    }
    
    private let KEY_IS_SHOW_APPLY_FILTER = "is_seen_apply_filter"
    var isSeenApplyFilter: Bool {
        get {
            if let value = ud.value(forKey: KEY_IS_SHOW_APPLY_FILTER) as? Bool {
                return value
            }
            
            return false
        }
        set {
            ud.set(newValue, forKey: KEY_IS_SHOW_APPLY_FILTER)
            ud.synchronize()
        }
    }
    
    private let KEY_IS_SHOW_CHARGER_INFO = "is_seen_charger_info" // 생애주기 중 처음으로 핀 눌렀는지 여부
    var isSeenChargerInfo: Bool {
        get {
            if let value = ud.value(forKey: KEY_IS_SHOW_CHARGER_INFO) as? Bool {
                return value
            }
            
            return false
        }
        set {
            ud.set(newValue, forKey: KEY_IS_SHOW_CHARGER_INFO)
            ud.synchronize()
        }
    }
    
    private let KEY_IS_SHOW_CHARGER_HELP = "is_seen_charger_help" // 생애주기 중 도움말 말풍선 한번이라도 노출 여부
    var isSeenChargerHelp: Bool {
        get {
            if let value = ud.value(forKey: KEY_IS_SHOW_CHARGER_HELP) as? Bool {
                return value
            }
            
            return false
        }
        set {
            ud.set(newValue, forKey: KEY_IS_SHOW_CHARGER_HELP)
            ud.synchronize()
        }
    }
    
    private let KEY_DEFAULT_SET_NAVI = "default_set_navi" // 기본 설정 내비게이션
    var defaultSetNavi: String? {
        get {
            return ud.string(forKey: KEY_DEFAULT_SET_NAVI)
        }
        set {
            guard let s = newValue else {
                ud.setValue(nil, forKey: KEY_DEFAULT_SET_NAVI)
                return
            }
            
            ud.set(s, forKey: KEY_DEFAULT_SET_NAVI)
            ud.synchronize()
        }
    }
    
    private let KEY_IS_SHOW_NAVI_SET = "is_seen_navi_set"   // 생애주기 중 내비 설정 화면 한번이상 노출 여부
    var isSeenNaviSet: Bool {
        get {
            return ud.bool(forKey: KEY_IS_SHOW_NAVI_SET)
        }
        set {
            ud.set(newValue, forKey: KEY_IS_SHOW_NAVI_SET)
            ud.synchronize()
        }
    }
    
    private let KEY_NAVI_CONNECT_COUNT = "navi_connect_count" // 길 안내 횟수
    var naviConnectCount: Int {
        get {
            return ud.integer(forKey: KEY_NAVI_CONNECT_COUNT)
        }
        set {
            ud.set(newValue, forKey: KEY_NAVI_CONNECT_COUNT)
            ud.synchronize()
        }
    }
    
    private let KEY_FILTER_IS_PART_SHARING = "filter_is_part_sharing"
    var isPartialPublic: Bool {
        get {
            if let value = ud.value(forKey: KEY_FILTER_IS_PART_SHARING) as? Bool {
                return value
            }
            
            return true
        }
        set {
            ud.set(newValue, forKey: KEY_FILTER_IS_PART_SHARING)
            ud.synchronize()
        }
    }
    
    private let KEY_FILTER_IS_UN_SHARING = "filter_is_un_sharing"
    var isNonPublic: Bool {
        get {
            if let value = ud.value(forKey: KEY_FILTER_IS_UN_SHARING) as? Bool {
                return value
            }
            
            return true
        }
        set {
            ud.set(newValue, forKey: KEY_FILTER_IS_UN_SHARING)
            ud.synchronize()
        }
    }
    
    private let KEY_RECOMMEND_CHARGER_MEMBERSHIP_IS_SHOW = "is_seen_recommend_charger_membership_"   // 추천 충전멤버쉽 한번 이상 노출 여부
    var isSeenRecommendChargerMemberShip: Bool {
        get {
            return ud.bool(forKey: KEY_RECOMMEND_CHARGER_MEMBERSHIP_IS_SHOW)
        }
        set {
            ud.set(newValue, forKey: KEY_RECOMMEND_CHARGER_MEMBERSHIP_IS_SHOW)
            ud.synchronize()
        }
    }
    
    /**
        @UserDefaultWrapper(key: "my key", defaultValue: rawValue)
        var myVariable: Int
     */
}
