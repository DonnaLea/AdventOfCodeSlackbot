//
//  LeaderboardTests.swift
//  AdventBot
//
//  Created by Donna McCulloch on 10/12/17.
//

import XCTest
@testable import AdventOfCodeSlackbotCore

class LeaderboardTests: XCTestCase {

  // MARK: - Properties
  let oneMemberNoStarsDictionary: JSONDictionary = [
    "event": "2017",
    "owner_id": "199866",
    "members": [
      "199866": [
        "global_score": 0,
        "id": "199866",
        "completion_day_level": [],
        "last_star_ts": "1969-12-31T19:00:00-0500",
        "local_score": 0,
        "name": "Sakchai",
        "stars": 0,
      ]]]

  let twoMembersNoStarsDictionary: JSONDictionary = [
    "event": "2017",
    "owner_id": "199866",
    "members": [
      "199866": [
        "global_score": 0,
        "id": "199866",
        "completion_day_level": [],
        "last_star_ts": "1969-12-31T19:00:00-0500",
        "local_score": 0,
        "name": "Sakchai",
        "stars": 0,
      ],
      "199916": [
        "global_score": 0,
        "id": "199916",
        "completion_day_level": [],
        "last_star_ts": "1969-12-31T19:00:00-0500",
        "local_score": 0,
        "name": "Madhav",
        "stars": 0,
      ]]]
  let threeMembersNoStarsDictionary: JSONDictionary = [
    "event": "2017",
    "owner_id": "199866",
    "members": [
      "199866": [
        "global_score": 0,
        "id": "199866",
        "completion_day_level": [],
        "last_star_ts": "1969-12-31T19:00:00-0500",
        "local_score": 0,
        "name": "Sakchai",
        "stars": 0,
      ],
      "199916": [
        "global_score": 0,
        "id": "199916",
        "completion_day_level": [],
        "last_star_ts": "1969-12-31T19:00:00-0500",
        "local_score": 0,
        "name": "Madhav",
        "stars": 0,
      ],
      "199958": [
        "global_score": 0,
        "id": "199958",
        "completion_day_level": [],
        "last_star_ts": "1969-12-31T19:00:00-0500",
        "local_score": 0,
        "name": "Jin",
        "stars": 0,
      ]]]

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testEquateIdentical() {

    let leaderboard1 = Leaderboard(dictionary: threeMembersNoStarsDictionary)
    let leaderboard2 = Leaderboard(dictionary: threeMembersNoStarsDictionary)
    XCTAssertEqual(leaderboard1, leaderboard2)
    XCTAssertEqual(leaderboard1.members, leaderboard2.members)
  }

  func testEquateNewMembers() {
    let leaderboard1 = Leaderboard(dictionary: oneMemberNoStarsDictionary)
    let leaderboard2 = Leaderboard(dictionary: threeMembersNoStarsDictionary)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
    XCTAssertNotEqual(leaderboard1.members, leaderboard2.members)
  }

  func testEquateLessMembers() {
    let leaderboard1 = Leaderboard(dictionary: threeMembersNoStarsDictionary)
    let leaderboard2 = Leaderboard(dictionary: twoMembersNoStarsDictionary)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
    XCTAssertNotEqual(leaderboard1.members, leaderboard2.members)
  }

  func testEquateDifferentMember() {
    let dictionary: JSONDictionary = [
      "event": "2017",
      "owner_id": "199866",
      "members": [
        "199866": [
          "global_score": 0,
          "id": "199866",
          "completion_day_level": [],
          "last_star_ts": "1969-12-31T19:00:00-0500",
          "local_score": 0,
          "name": "Sakchai",
          "stars": 0,
        ],
        "199916": [
          "global_score": 0,
          "id": "199915",
          "completion_day_level": [],
          "last_star_ts": "1969-12-31T19:00:00-0500",
          "local_score": 0,
          "name": "Cael",
          "stars": 0,
        ]]]
    let leaderboard1 = Leaderboard(dictionary: twoMembersNoStarsDictionary)
    let leaderboard2 = Leaderboard(dictionary: dictionary)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
  }

  func testEquateNewEvent() {
    let dictionary: JSONDictionary = [
      "event": "2018",
      "owner_id": "199866",
      "members": [
        "199866": [
          "global_score": 0,
          "id": "199866",
          "completion_day_level": [],
          "last_star_ts": "1969-12-31T19:00:00-0500",
          "local_score": 0,
          "name": "Sakchai",
          "stars": 0,
        ]]]
    let leaderboard1 = Leaderboard(dictionary: oneMemberNoStarsDictionary)
    let leaderboard2 = Leaderboard(dictionary: dictionary)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
  }

  func testEquateNewOwner() {
    let dictionary: JSONDictionary = [
      "event": "2017",
      "owner_id": "199916",
      "members": [
        "199866": [
          "global_score": 0,
          "id": "199866",
          "completion_day_level": [],
          "last_star_ts": "1969-12-31T19:00:00-0500",
          "local_score": 0,
          "name": "Sakchai",
          "stars": 0,
        ],
        "199916": [
          "global_score": 0,
          "id": "199916",
          "completion_day_level": [],
          "last_star_ts": "1969-12-31T19:00:00-0500",
          "local_score": 0,
          "name": "Madhav",
          "stars": 0,
        ]]]
    let leaderboard1 = Leaderboard(dictionary: twoMembersNoStarsDictionary)
    let leaderboard2 = Leaderboard(dictionary: dictionary)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
  }

  func testMemberGetsNewStar() {
    let dictionary: JSONDictionary = [
      "event": "2017",
      "owner_id": "199866",
      "members": [
        "199866": [
          "global_score": 0,
          "id": "199866",
          "last_star_ts": "2017-12-03T02:29:28-0500",
          "local_score": 0,
          "name": "Sakchai",
          "stars": 2,
          "completion_day_level": [
            "2": [
              "1": ["get_star_ts":"2017-12-03T02:02:32-0500"],
              "2": ["get_star_ts":"2017-12-03T02:29:28-0500"],
          ]]]]]
    let leaderboard1 = Leaderboard(dictionary: oneMemberNoStarsDictionary)
    let leaderboard2 = Leaderboard(dictionary: dictionary)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
  }
}
