//
//  Questions.swift
//  Stick-Hero
//
//  Created by Muhammad Noor Ansyari on 24/07/21.
//  Copyright © 2021 koofrank. All rights reserved.
//

import Foundation


struct Question {
    let message: String
    let answer: String
}

struct Kanji {
    let name: String
}

var questionList: [Question] = [
    Question(message: "Which one of the kanji means meeting?", answer: "会"),
    Question(message: "Which one of the kanji means music?", answer: "楽"),
    
]


var kanjiList: [Kanji] = [
    Kanji(name: "会"),
    Kanji(name: "楽"),
    Kanji(name: "同"),
    Kanji(name: "事"),
    Kanji(name: "自"),
    Kanji(name: "者"),
    Kanji(name: "発"),
    Kanji(name: "社"),
    Kanji(name: ""),
]

func stage1() {
    
//    var kanjiStage1 = [kanjiLevel1, kanjiLevel2!, kanjiLevel3!, kanjiLevel4!] as [Any]
}

let kanji1 = [["楽","Which one of the \n kanji means meeting?"],["楽","Which one of the kanji means music?"]]


let level1 = ["楽", "同", "事", "自","者", "発", "社"]
let answer1: String = "会"

var kanjiLevel1 = answer1
var kanjiLevel2 = level1.randomElement()
var kanjiLevel3 = level1.randomElement()
var kanjiLevel4 = level1.randomElement()

//var kanjiText1 = kanjiLevel1
//var kanjiText2 = kanjiLevel2
//var kanjiText3 = kanjiLevel3
//var kanjiText4 = kanjiLevel4

let kanjiLevel5 = level1.randomElement()

var question1 = "Which one of the kanji means meeting?"

//if kanjiLevel1 == kanjiLevel2 || kanjiLevel3 || kanjiLevel4 {
//
//}

// 1. random nilai dari kanji
// 2. tambahkan kedalam array
// 3. jika kanji sudah ada maka kanji di random ulang
