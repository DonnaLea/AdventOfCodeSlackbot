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
  let decoder = JSONDecoder()
  
  let oneMemberNoStarsJSON = """
    {
      "event": "2017",
      "owner_id": "199866",
      "members": {
        "199866": {
          "global_score": 0,
          "id": "199866",
          "completion_day_level": {},
          "last_star_ts": 0,
          "local_score": 0,
          "name": "Sakchai",
          "stars": 0,
      }}}
    """.data(using: .utf8)!

  let twoMembersNoStarsJSON = """
    {
      "event": "2017",
      "owner_id": "199866",
      "members": {
        "199866": {
          "global_score": 0,
          "id": "199866",
          "completion_day_level": {},
          "last_star_ts": 0,
          "local_score": 0,
          "name": "Sakchai",
          "stars": 0,
        },
        "199916": {
          "global_score": 0,
          "id": "199916",
          "completion_day_level": {},
          "last_star_ts": 0,
          "local_score": 0,
          "name": "Madhav",
          "stars": 0,
        }}}
    """.data(using: .utf8)!
  let threeMembersNoStarsJSON = """
    {
      "event": "2017",
      "owner_id": "199866",
      "members": {
        "199866": {
          "global_score": 0,
          "id": "199866",
          "completion_day_level": {},
          "last_star_ts": 0,
          "local_score": 0,
          "name": "Sakchai",
          "stars": 0,
        },
        "199916": {
          "global_score": 0,
          "id": "199916",
          "completion_day_level": {},
          "last_star_ts": 0,
          "local_score": 0,
          "name": "Madhav",
          "stars": 0,
        },
        "199958": {
          "global_score": 0,
          "id": "199958",
          "completion_day_level": {},
          "last_star_ts": 0,
          "local_score": 0,
          "name": "Jin",
          "stars": 0,
        }}}
    """.data(using: .utf8)!
  let sampleJSON = """
    {
      "members": {
        "199866": {
          "stars": 0,
          "name": "Jen Wong",
          "completion_day_level": {},
          "local_score": 0,
          "last_star_ts": 0,
          "id": "199866",
          "global_score": 0
        },
        "199916": {
          "completion_day_level": {
            "1": {
              "1": {
                "get_star_ts": "1543743314"
              },
              "2": {
                "get_star_ts": "1543745575"
              }
            }
          },
          "name": "DonnaLea",
          "stars": 2,
          "id": "199916",
          "global_score": 0,
          "last_star_ts": "1543745575",
          "local_score": 8
        },
        "199958": {
          "local_score": 20,
          "last_star_ts": "1543739269",
          "global_score": 0,
          "id": "199958",
          "stars": 4,
          "name": "Leigh McCulloch",
          "completion_day_level": {
            "1": {
              "1": {
                "get_star_ts": "1543712714"
              },
              "2": {
                "get_star_ts": "1543716823"
              }
            },
            "2": {
              "1": {
                "get_star_ts": "1543738511"
              },
              "2": {
                "get_star_ts": "1543739269"
              }
            }
          }
        },
        "227379": {
          "name": "Corey Knight",
          "stars": 0,
          "completion_day_level": {},
          "local_score": 0,
          "id": "227379",
          "global_score": 0,
          "last_star_ts": 0
        },
        "245475": {
          "completion_day_level": {},
          "stars": 0,
          "name": "Nicolas Milliard",
          "last_star_ts": 0,
          "global_score": 0,
          "id": "245475",
          "local_score": 0
        }
      },
      "owner_id": "199958",
      "event": "2018"
    }
    """.data(using: .utf8)!

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if #available(OSX 10.12, *) {
      decoder.dateDecodingStrategy = AdventOfCodeSlackbot.jsonDateDecoder
    }
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testSample() {
    let leaderboard = try! decoder.decode(Leaderboard.self, from: sampleJSON)
    XCTAssertNotNil(leaderboard.members)
  }

  func testEquateIdentical() {
    let leaderboard1 = try! decoder.decode(Leaderboard.self, from: threeMembersNoStarsJSON)
    let leaderboard2 = try! decoder.decode(Leaderboard.self, from: threeMembersNoStarsJSON)
    XCTAssertEqual(leaderboard1, leaderboard2)
    XCTAssertEqual(leaderboard1.members, leaderboard2.members)
  }

  func testEquateNewMembers() {
    let leaderboard1 = try! decoder.decode(Leaderboard.self, from: oneMemberNoStarsJSON)
    let leaderboard2 = try! decoder.decode(Leaderboard.self, from: threeMembersNoStarsJSON)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
    XCTAssertNotEqual(leaderboard1.members, leaderboard2.members)
  }

  func testEquateLessMembers() {
    let leaderboard1 = try! decoder.decode(Leaderboard.self, from: threeMembersNoStarsJSON)
    let leaderboard2 = try! decoder.decode(Leaderboard.self, from: twoMembersNoStarsJSON)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
    XCTAssertNotEqual(leaderboard1.members, leaderboard2.members)
  }

  func testEquateDifferentMember() {
    let json = """
      {
        "event": "2017",
        "owner_id": "199866",
        "members": {
          "199866": {
            "global_score": 0,
            "id": "199866",
            "completion_day_level": {},
            "last_star_ts": 0,
            "local_score": 0,
            "name": "Sakchai",
            "stars": 0,
          },
          "199916": {
            "global_score": 0,
            "id": "199915",
            "completion_day_level": {},
            "last_star_ts": 0,
            "local_score": 0,
            "name": "Cael",
            "stars": 0,
      }}}
    """.data(using: .utf8)!
    let leaderboard1 = try! decoder.decode(Leaderboard.self, from: twoMembersNoStarsJSON)
    let leaderboard2 = try! decoder.decode(Leaderboard.self, from: json)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
  }

  func testEquateNewEvent() {
    let json = """
      {
        "event": "2018",
        "owner_id": "199866",
        "members": {
          "199866": {
            "global_score": 0,
            "id": "199866",
            "completion_day_level": {},
            "last_star_ts": 0,
            "local_score": 0,
            "name": "Sakchai",
            "stars": 0,
        }}}
      """.data(using: .utf8)!
    let leaderboard1 = try! decoder.decode(Leaderboard.self, from: oneMemberNoStarsJSON)
    let leaderboard2 = try! decoder.decode(Leaderboard.self, from: json)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
  }

  func testEquateNewOwner() {
    let json = """
      {
        "event": "2017",
        "owner_id": "199916",
        "members": {
          "199866": {
            "global_score": 0,
            "id": "199866",
            "completion_day_level": {},
            "last_star_ts": 0,
            "local_score": 0,
            "name": "Sakchai",
            "stars": 0,
          },
          "199916": {
            "global_score": 0,
            "id": "199916",
            "completion_day_level": {},
            "last_star_ts": 0,
            "local_score": 0,
            "name": "Madhav",
            "stars": 0,
          }}}
    """.data(using: .utf8)!
    let leaderboard1 = try! decoder.decode(Leaderboard.self, from: twoMembersNoStarsJSON)
    let leaderboard2 = try! decoder.decode(Leaderboard.self, from: json)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
  }

  func testMemberGetsNewStar() {
    let json = """
      {
        "event": "2017",
        "owner_id": "199866",
        "members": {
          "199866": {
            "global_score": 0,
            "id": "199866",
            "last_star_ts": "1512286168",
            "local_score": 0,
            "name": "Sakchai",
            "stars": 2,
            "completion_day_level": {
              "2": {
                "1": {"get_star_ts":"1512284552"},
                "2": {"get_star_ts":"1512286168"},
            }}}}}
      """.data(using: .utf8)!
    let leaderboard1 = try! decoder.decode(Leaderboard.self, from: oneMemberNoStarsJSON)
    let leaderboard2 = try! decoder.decode(Leaderboard.self, from: json)
    XCTAssertNotEqual(leaderboard1, leaderboard2)
  }
}
