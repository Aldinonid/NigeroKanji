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
	
]
