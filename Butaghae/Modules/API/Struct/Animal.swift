//
//  Animal.swift
//  Butaghae
//
//  Created by MacBookPro on 2022/05/04.
//

import Foundation

struct Animal: Codable {
    var name: String          // 강아지 이름
    var age: Int             // 강아지 나이
    var breed: Breed         // 강이지 종류
    var beauty: [Beauty]     // 강아지 미용
    var work: [Work]        // 강아지 산책
    var checkup: [Checkup]  // 강아지 건강검진
    var vaccination: [Vaccination] // 강아지 예방접종
}

struct Beauty: Codable {
    var date: Date
    var price: Int
    var shopName: String
}

struct Work: Codable {
    var date: Date
    var time: Int
    var distance: Int
}

struct Checkup: Codable {
    var date: Date
    var price: Int
    var drugEndDate: Date
    var drugName: String
    var checkupMemo: String
    var hospitalName: String
}

struct Vaccination: Codable {
    var date: Date
    var price: Int
    var vaccinationMemo: String
    var hospitalName: String
    var vaccinationCase: VaccinationCase
}
