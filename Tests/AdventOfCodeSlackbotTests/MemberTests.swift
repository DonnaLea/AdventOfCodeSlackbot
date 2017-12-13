//
//  MemberTests.swift
//  AdventOfCodeSlackbotTests
//
//  Created by Donna McCulloch on 12/12/17.
//

import XCTest
@testable import AdventOfCodeSlackbotCore

class MemberTests: XCTestCase {

  let noStarsDictionary: JSONDictionary = [
    "global_score": "0",
    "id": "199866",
    "last_star_ts": "1969-12-31T19:00:00-0500",
    "local_score": "0",
    "name": "Sakchai",
    "stars": "0",
    "completion_day_level": []
  ]
  let stars2Dictionary: JSONDictionary = [
    "global_score": "10",
    "id": "199866",
    "last_star_ts": "2017-12-03T02:29:28-0500",
    "local_score": "50",
    "name": "Sakchai",
    "stars": "2",
    "completion_day_level": [
      "2": [
        "1": ["get_star_ts":"2017-12-03T02:02:32-0500"],
        "2": ["get_star_ts":"2017-12-03T02:29:28-0500"],
      ]]]

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testMemberNoStarsInit() {
    let member = Member(dictionary: noStarsDictionary)
    XCTAssertEqual(member.name, "Sakchai")
    XCTAssertEqual(member.id, "199866")
    XCTAssertEqual(member.globalScore, 0)
    XCTAssertEqual(member.localScore, 0)
    XCTAssertEqual(member.lastStarTime, dateFormatter.date(from: "2017-12-03T02:29:28-0500"))
    XCTAssertEqual(member.stars, 0)
    XCTAssertEqual(member.completedDays.count, 0)
  }

  func testMember2StarsInit() {
    let member = Member(dictionary: stars2Dictionary)
    XCTAssertEqual(member.name, "Sakchai")
    XCTAssertEqual(member.id, "199866")
    XCTAssertEqual(member.globalScore, 10)
    XCTAssertEqual(member.localScore, 50)
    XCTAssertEqual(member.lastStarTime, dateFormatter.date(from: "2017-12-03T02:29:28-0500"))
    XCTAssertEqual(member.stars, 2)
    XCTAssertEqual(member.completedDays.count, 1)
  }

  func testEquateIdentical() {
    let member1 = Member(dictionary: stars2Dictionary)
    let member2 = Member(dictionary: stars2Dictionary)
    XCTAssertEqual(member1, member2)
  }

  func testEquateDifferentMembers() {
    let dictionary: JSONDictionary = [
      "global_score": "0",
      "id": "199867",
      "last_star_ts": "1969-12-31T19:00:00-0500",
      "local_score": "0",
      "name": "Sakchai",
      "stars": "0",
      "completion_day_level": []
    ]
    let member1 = Member(dictionary: noStarsDictionary)
    let member2 = Member(dictionary: dictionary)
    XCTAssertNotEqual(member1, member2)
  }

  func testEquateMemberWithMoreStars() {
    let member1 = Member(dictionary: noStarsDictionary)
    let member2 = Member(dictionary: stars2Dictionary)
    XCTAssertNotEqual(member1, member2)
  }

  func testEquateMemberWithDifferentGlobalScore() {
    let dictionary: JSONDictionary = [
      "global_score": "10",
      "id": "199866",
      "last_star_ts": "1969-12-31T19:00:00-0500",
      "local_score": "0",
      "name": "Sakchai",
      "stars": "0",
      "completion_day_level": []
    ]
    let member1 = Member(dictionary: noStarsDictionary)
    let member2 = Member(dictionary: dictionary)
    XCTAssertNotEqual(member1, member2)
  }

  func testEquateMemberWithDifferentLocalScore() {
    let dictionary: JSONDictionary = [
      "global_score": "0",
      "id": "199866",
      "last_star_ts": "1969-12-31T19:00:00-0500",
      "local_score": "10",
      "name": "Sakchai",
      "stars": "0",
      "completion_day_level": []
    ]
    let member1 = Member(dictionary: noStarsDictionary)
    let member2 = Member(dictionary: dictionary)
    XCTAssertNotEqual(member1, member2)
  }

  func testEquateMemberWithDifferentName() {
    let dictionary: JSONDictionary = [
      "global_score": "0",
      "id": "199866",
      "last_star_ts": "1969-12-31T19:00:00-0500",
      "local_score": "0",
      "name": "Cael",
      "stars": "0",
      "completion_day_level": []
    ]
    let member1 = Member(dictionary: noStarsDictionary)
    let member2 = Member(dictionary: dictionary)
    XCTAssertNotEqual(member1, member2)
  }

}
