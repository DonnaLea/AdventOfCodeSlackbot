//
//  LeaderboardTests.swift
//  AdventBot
//
//  Created by Donna McCulloch on 10/12/17.
//

import Foundation
import XCTest
@testable import AdventOfCodeSlackbotCore

class LeaderboardTests: XCTestCase {

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testLeaderboardCompareNewMembers() {
    // Leaderboard with no star completion of 2 members.

    let leaderboardDict1: [String: Any] = [
      "event": "2017",
      "owner_id": "199958",
      "members": [
        "199866": [
          "global_score": "0",
          "id": "199866",
          "last_star_ts": "2017-12-06T03:00:12-0500",
          "local_score": "24",
          "name": "Sakchai",
          "stars": "10",
        ],
        "199916": [
          "global_score": "0",
          "id": "199916",
          "last_star_ts": "2017-12-11T02:23:01-0500",
          "local_score": "77",
          "name": "Madhav",
          "stars": "22",
    ]]]
    let leaderboardDict2: [String: Any] = [
      "event": "2017",
      "owner_id": "199958",
      "members": [
        "199866": [
          "global_score": "0",
          "id": "199866",
          "last_star_ts": "2017-12-06T03:00:12-0500",
          "local_score": "24",
          "name": "Sakchai",
          "stars": "10",
        ],
        "199916": [
          "global_score": "0",
          "id": "199916",
          "last_star_ts": "2017-12-11T02:23:01-0500",
          "local_score": "77",
          "name": "Madhav",
          "stars": "22",
        ],
        "199958": [
          "global_score": "0",
          "id": "199958",
          "last_star_ts": "2017-12-11T00:12:42-0500",
          "local_score": "102",
          "name": "Jin",
          "stars": "22",
        ]]]

    let leaderboard1 = Leaderboard(dictionary: leaderboardDict1)
    let leaderboard2 = Leaderboard(dictionary: leaderboardDict2)
    let leaderboardsEquate = leaderboard1 == leaderboard2
    let membersEquate = leaderboard1.members == leaderboard2.members
    XCTAssertEqual(leaderboardsEquate, false)
    XCTAssertEqual(membersEquate, false)
  }

}
