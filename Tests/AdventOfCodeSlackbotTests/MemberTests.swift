//
//  MemberTests.swift
//  AdventOfCodeSlackbotTests
//
//  Created by Donna McCulloch on 12/12/17.
//

import XCTest
@testable import AdventOfCodeSlackbotCore

class MemberTests: XCTestCase {

  // MARK: - Properties
  let dateFormatter = DateFormatter()
  let decoder = JSONDecoder()
  let noStarsJSON = """
    {
      "global_score": 0,
      "id": "199866",
      "last_star_ts": "1969-12-31T19:00:00-0500",
      "local_score": 0,
      "name": "Sakchai",
      "stars": 0,
      "completion_day_level": {}
    }
  """.data(using: .utf8)!
  let stars2JSON = """
    {
      "global_score": 10,
      "id": "199866",
      "last_star_ts": "2017-12-03T02:29:28-0500",
      "local_score": 50,
      "name": "Sakchai",
      "stars": 2,
      "completion_day_level": {
        "2": {
          "1": {"get_star_ts":"2017-12-03T02:02:32-0500"},
          "2": {"get_star_ts":"2017-12-03T02:29:28-0500"},
        }}}
  """.data(using: .utf8)!

  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if #available(OSX 10.12, *) {
      decoder.dateDecodingStrategy = .iso8601
    } else {
      // Fallback on earlier versions
    }

    // MARK: - File variable
    let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
    dateFormatter.locale = enUSPosixLocale
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testMemberNoStarsInit() {
    let member = try! decoder.decode(Member.self, from: noStarsJSON)
    XCTAssertEqual(member.name, "Sakchai")
    XCTAssertEqual(member.id, "199866")
    XCTAssertEqual(member.globalScore, 0)
    XCTAssertEqual(member.localScore, 0)
    XCTAssertEqual(member.lastStarTime, dateFormatter.date(from: "1969-12-31T19:00:00-0500"))
    XCTAssertEqual(member.stars, 0)
    XCTAssertEqual(member.completedDays.days.count, 0)
  }

  func testMember2StarsInit() {
    let member = try! decoder.decode(Member.self, from: stars2JSON)
    XCTAssertEqual(member.name, "Sakchai")
    XCTAssertEqual(member.id, "199866")
    XCTAssertEqual(member.globalScore, 10)
    XCTAssertEqual(member.localScore, 50)
    XCTAssertEqual(member.lastStarTime, dateFormatter.date(from: "2017-12-03T02:29:28-0500"))
    XCTAssertEqual(member.stars, 2)
    XCTAssertEqual(member.completedDays.days.count, 1)
  }

  func testEquateIdentical() {
    let member1 = try! decoder.decode(Member.self, from: stars2JSON)
    let member2 = try! decoder.decode(Member.self, from: stars2JSON)
    XCTAssertEqual(member1, member2)
  }

  func testEquateDifferentMembers() {
    let json = """
      {
        "global_score": 0,
        "id": "199867",
        "last_star_ts": "1969-12-31T19:00:00-0500",
        "local_score": 0,
        "name": "Sakchai",
        "stars": 0,
        "completion_day_level": {}
      }
    """.data(using: .utf8)!
    let member1 = try! decoder.decode(Member.self, from: noStarsJSON)
    let member2 = try! decoder.decode(Member.self, from: json)
    XCTAssertNotEqual(member1, member2)
  }

  func testEquateMemberWithMoreStars() {
    let member1 = try! decoder.decode(Member.self, from: noStarsJSON)
    let member2 = try! decoder.decode(Member.self, from: stars2JSON)
    XCTAssertNotEqual(member1, member2)
  }

  func testEquateMemberWithDifferentGlobalScore() {
    let json = """
      {
        "global_score": 10,
        "id": "199866",
        "last_star_ts": "1969-12-31T19:00:00-0500",
        "local_score": 0,
        "name": "Sakchai",
        "stars": 0,
        "completion_day_level": {}
      }
    """.data(using: .utf8)!
    let member1 = try! decoder.decode(Member.self, from: noStarsJSON)
    let member2 = try! decoder.decode(Member.self, from: json)
    XCTAssertNotEqual(member1, member2)
  }

  func testEquateMemberWithDifferentLocalScore() {
    let json = """
      {
        "global_score": 0,
        "id": "199866",
        "last_star_ts": "1969-12-31T19:00:00-0500",
        "local_score": 10,
        "name": "Sakchai",
        "stars": 0,
        "completion_day_level": {}
      }
    """.data(using: .utf8)!
    let member1 = try! decoder.decode(Member.self, from: noStarsJSON)
    let member2 = try! decoder.decode(Member.self, from: json)
    XCTAssertNotEqual(member1, member2)
  }

  func testEquateMemberWithDifferentName() {
    let json = """
      {
        "global_score": 0,
        "id": "199866",
        "last_star_ts": "1969-12-31T19:00:00-0500",
        "local_score": 0,
        "name": "Cael",
        "stars": 0,
        "completion_day_level": {}
      }
    """.data(using: .utf8)!
    let member1 = try! decoder.decode(Member.self, from: noStarsJSON)
    let member2 = try! decoder.decode(Member.self, from: json)
    XCTAssertNotEqual(member1, member2)
  }

}
