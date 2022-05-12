//
//  Hospital.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/04.
//

import Foundation

struct Hospital: Codable {
    var bsn_nm: String // 상호명
    var road_nm_addr: String // 도로명 주소
    var rep_person: String // 대표자
    var tel_no: String // 전화번호
    var lat: String // 위도
    var lot: String // 경도
}
