//
//  Leaderboard.swift
//  AdventBotPackageDescription
//
//  Created by Donna McCulloch on 6/12/17.
//

import Foundation

struct Leaderboard : Codable {

  // MARK: - Coding Keys
  enum CodingKeys : String, CodingKey {
    case event
    case ownerId = "owner_id"
    case members
  }

  // MARK: - Properties
  let event: String
  let ownerId: String
  var owner: Member? {
    return members[ownerId]
  }
  let members: [String : Member]

  var rankedMembers: [Member]

  // MARK: - Init
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    event = try container.decode(String.self, forKey: .event)
    ownerId = try container.decode(String.self, forKey: .ownerId)
    members = try container.decode([String : Member].self, forKey: .members)
    rankedMembers = members.values.sorted { lhs, rhs -> Bool in
      lhs.localScore > rhs.localScore
    }
  }

}

// MARK: - Equatable
extension Leaderboard : Equatable {}

func ==(lhs: Leaderboard, rhs: Leaderboard) -> Bool {
  return  lhs.event == rhs.event &&
          lhs.ownerId == rhs.ownerId &&
          lhs.rankedMembers == rhs.rankedMembers
}
