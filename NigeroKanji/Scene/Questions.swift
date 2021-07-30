//
//  Questions.swift
//  Stick-Hero
//
//  Created by Muhammad Noor Ansyari on 24/07/21.
//  Copyright © 2021 koofrank. All rights reserved.
//

import Foundation


struct Khanji {
    var urutan: String
    var karakter: String
    var arti: String
    
    init(urutan: String, karakter: String, arti: String){
        self.urutan = urutan;
        self.karakter = karakter;
        self.arti = arti;
        
    }
    
}

class Question{
    var dictioKanji = [
        Khanji(urutan:"1", karakter:"会", arti:"Meeting"),
        Khanji(urutan:"2", karakter:"同", arti:"Agree"),
        Khanji(urutan:"3", karakter:"事", arti:"Business"),
        Khanji(urutan:"4", karakter:"自", arti:"Oneself"),
        Khanji(urutan:"5", karakter:"社", arti:"Company"),
        Khanji(urutan:"6", karakter:"発", arti:"Departure"),
        Khanji(urutan:"7", karakter:"者", arti:"Someone"),
        Khanji(urutan:"8", karakter:"地", arti:"Earth"),
        Khanji(urutan:"9", karakter:"業", arti:"Performance"),
        Khanji(urutan:"10", karakter:"方", arti:"Person"),
        Khanji(urutan:"11", karakter:"新", arti:"New"),
        Khanji(urutan:"12", karakter:"場", arti:"Place"),
        Khanji(urutan:"13", karakter:"員", arti:"Member"),
        Khanji(urutan:"14", karakter:"立", arti:"Stand up"),
        Khanji(urutan:"15", karakter:"開", arti:"Open"),
        Khanji(urutan:"16", karakter:"手", arti:"Hand"),
        Khanji(urutan:"17", karakter:"力", arti:"Strength"),
        Khanji(urutan:"18", karakter:"問", arti:"Question"),
        Khanji(urutan:"19", karakter:"代", arti:"Replace"),
        Khanji(urutan:"20", karakter:"明", arti:"Light"),
        Khanji(urutan:"21", karakter:"動", arti:"Motion"),
        Khanji(urutan:"22", karakter:"京", arti:"Capital"),
        Khanji(urutan:"23", karakter:"目", arti:"Look"),
        Khanji(urutan:"24", karakter:"通", arti:"Traffic"),
        Khanji(urutan:"25", karakter:"言", arti:"Word"),
        Khanji(urutan:"26", karakter:"理", arti:"Reason"),
        Khanji(urutan:"27", karakter:"体", arti:"Body"),
        Khanji(urutan:"28", karakter:"田", arti:"Rice Field"),
        Khanji(urutan:"29", karakter:"主", arti:"Master"),
        Khanji(urutan:"30", karakter:"題", arti:"Topic"),
        Khanji(urutan:"31", karakter:"意", arti:"Idea"),
        Khanji(urutan:"32", karakter:"不", arti:"Negative"),
        Khanji(urutan:"33", karakter:"作", arti:"Production"),
        Khanji(urutan:"34", karakter:"用", arti:"Service"),
        Khanji(urutan:"35", karakter:"度", arti:"Degree"),
        Khanji(urutan:"36", karakter:"強", arti:"Strong"),
        Khanji(urutan:"37", karakter:"公", arti:"Official"),
        Khanji(urutan:"38", karakter:"持", arti:"Hold"),
        Khanji(urutan:"39", karakter:"野", arti:"Field"),
        Khanji(urutan:"40", karakter:"以", arti:"Because"),
        Khanji(urutan:"41", karakter:"思", arti:"Think"),
        Khanji(urutan:"42", karakter:"家", arti:"World"),
        Khanji(urutan:"43", karakter:"世", arti:"Generation"),
        Khanji(urutan:"44", karakter:"多", arti:"Frequent"),
        Khanji(urutan:"45", karakter:"正", arti:"Correct"),
        Khanji(urutan:"46", karakter:"安", arti:"Safe"),
        Khanji(urutan:"47", karakter:"院", arti:"Institution"),
        Khanji(urutan:"48", karakter:"心", arti:"Mind"),
        Khanji(urutan:"49", karakter:"界", arti:"Boundary"),
        Khanji(urutan:"50", karakter:"教", arti:"Faith"),
    ]
    
    
    var screenKanji1 = Khanji(urutan: "", karakter: "", arti: "")
    var screenKanji2 = Khanji(urutan: "", karakter: "", arti: "")
    var screenKanji3 = Khanji(urutan: "", karakter: "", arti: "")
    var screenKanji4 = Khanji(urutan: "", karakter: "", arti: "")
    var kanjiArti = ""
    var kanjiKarakter = ""
    
    
    func showKanji() {
        
        let answerKanji = dictioKanji.randomElement()!
        dictioKanji = dictioKanji.filter() {$0.urutan != answerKanji.urutan}
        let decoyKanji1 = dictioKanji.randomElement()!
        dictioKanji = dictioKanji.filter() {$0.urutan != decoyKanji1.urutan}
        let decoyKanji2 = dictioKanji.randomElement()!
        dictioKanji = dictioKanji.filter() {$0.urutan != decoyKanji2.urutan}
        let decoyKanji3 = dictioKanji.randomElement()!
        dictioKanji = dictioKanji.filter() {$0.urutan != decoyKanji3.urutan}
        
        //Tampilkan (spit) Kanji2 kedalam layar secara acak
        var regatherKanji = [answerKanji, decoyKanji1, decoyKanji2, decoyKanji3]
        
        screenKanji1 = regatherKanji.randomElement()!
        regatherKanji = regatherKanji.filter() {$0.urutan != screenKanji1.urutan}
        screenKanji1.urutan = "a"
        
        screenKanji2 = regatherKanji.randomElement()!
        regatherKanji = regatherKanji.filter() {$0.urutan != screenKanji2.urutan}
        screenKanji2.urutan = "b"
        
        
        screenKanji3 = regatherKanji.randomElement()!
        regatherKanji = regatherKanji.filter() {$0.urutan != screenKanji3.urutan}
        screenKanji3.urutan = "c"
        
        screenKanji4 = regatherKanji.randomElement()!
        regatherKanji = regatherKanji.filter() {$0.urutan != screenKanji4.urutan}
        screenKanji4.urutan = "d"
        
        kanjiArti = answerKanji.arti
        kanjiKarakter = answerKanji.karakter
        
        
        // Fungsi Tampilkan interface
//        print("\ncoba tebak kanji mana yang artinya : \n\(answerKanji.arti)??")
//        
//        print ("\npilihannya adalah \n \n a.\(screenKanji1.karakter) \n b.\(screenKanji2.karakter) \n c.\(screenKanji3.karakter) \n d.\(screenKanji4.karakter)")
//        
//        //print jawaban
//        
//        print("\n sssttt jawabannya adalah : \(answerKanji.karakter)")
        
        
        
        //dump(screenKanji1)
        //        showKanji()
        
    }
}


//
//
//let model = KanjiModel()
//model.showKanji()
//
//
//
//
//var kanjiBallon1 = model.screenKanji1.karakter
//var kanjiBallon2 = model.screenKanji2.karakter
//var kanjiBallon3 = model.screenKanji3.karakter
//var kanjiBallon4 = model.screenKanji4.karakter
//var question = answerKanji.arti
//var answer = answerKanji.karakter
//
//var send = [kanjiBallon1, kanjiBallon2, kanjiBallon3, kanjiBallon4, question, answer]


//struct Question {
//    let message: String
//    let answer: String
//}
//
//struct Kanji {
//    let name: String
//}
//
//var questionList: [Question] = [
//    Question(message: "Which one of the kanji means meeting?", answer: "会"),
//    Question(message: "Which one of the kanji means music?", answer: "楽"),
//]
//
//
//var kanjiList: [Kanji] = [
//    Kanji(name: "会"),
//    Kanji(name: "楽"),
//    Kanji(name: "同"),
//    Kanji(name: "事"),
//    Kanji(name: "自"),
//    Kanji(name: "者"),
//    Kanji(name: "発"),
//    Kanji(name: "社"),
//    Kanji(name: ""),
//]





//func stage1() {
//
////    var kanjiStage1 = [kanjiLevel1, kanjiLevel2!, kanjiLevel3!, kanjiLevel4!] as [Any]
//}
//
//let kanji1 = [["楽","Which one of the \n kanji means meeting?"],["楽","Which one of the kanji means music?"]]
//
//
//let level1 = ["楽", "同", "事", "自","者", "発", "社"]
//let answer1: String = "会"
//
//
//
////var kanjiText1 = kanjiLevel1
////var kanjiText2 = kanjiLevel2
////var kanjiText3 = kanjiLevel3
////var kanjiText4 = kanjiLevel4
//
//let kanjiLevel5 = level1.randomElement()
//
//var question1 = "Which one of the kanji means meeting?"
//
////if kanjiLevel1 == kanjiLevel2 || kanjiLevel3 || kanjiLevel4 {
////
////}
//
//// 1. random nilai dari kanji
//// 2. tambahkan kedalam array
//// 3. jika kanji sudah ada maka kanji di random ulang

