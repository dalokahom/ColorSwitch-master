//
//  ScoreLabelTests.swift
//  ColorSwitch
//
//  Created by Дарья Хомякова on 24/11/19.
//  Copyright © 2019 Дарья Хомякова. All rights reserved.
//

import XCTest
@testable import ColorSwitch

class ScoreLabelTests: XCTestCase {
    
    var scoreLabel: ScoreLabel!
    
    override func setUp() {
        scoreLabel = ScoreLabel(frame: CGRect(x: 9, y: 9, width: 9, height: 0))
    }

    func testInitialAttributes() {
        XCTAssertEqual(scoreLabel.scoreLabelNode.text!, "0")
        XCTAssertEqual(scoreLabel.scoreLabelNode.fontName, "AvenirNext-Bold")
        XCTAssertEqual(scoreLabel.scoreLabelNode.fontSize, 60.0)
        XCTAssertEqual(scoreLabel.scoreLabelNode.position.x, 13.5)
        XCTAssertEqual(scoreLabel.scoreLabelNode.position.y, 9.0)
        XCTAssertEqual(scoreLabel.scoreLabelNode.zPosition, ZPositions.label)
    }
    
    func testUpdateScore() {
        scoreLabel.updateScore(score: 123)
        XCTAssertEqual(scoreLabel.scoreLabelNode.text!, "123")
    }
}
