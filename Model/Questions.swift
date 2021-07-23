//
//  Questions.swift
//  NigeroKanji
//
//  Created by Aldino Efendi on 2021/07/23.
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
