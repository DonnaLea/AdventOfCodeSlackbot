//
//  Leaderboard.swift
//  AdventBotPackageDescription
//
//  Created by Donna McCulloch on 6/12/17.
//

import Foundation

struct Leaderboard {

  // MARK: - Keys
  private struct Keys {
    static let event = "event"
    static let members = "members"
    static let ownerId = "owner_id"
  }

  // MARK: - Properties
  let event: String
  private(set) var owner: Member? = nil
  private(set) var members = [String : Member]()
  private(set) var rankedMembers = [Member]()

  // MARK: - Init
  init(dictionary: JSONDictionary) {
    event = dictionary[Keys.event] as? String ?? String(Calendar.current.component(.year, from: Date()))
    let ownerId = dictionary[Keys.ownerId] as? String ?? ""
    if let membersJSON = dictionary[Keys.members] as? [String : JSONDictionary] {
      for slice in membersJSON {
        let member = Member(dictionary: slice.value)
        members[member.id] = member
        rankedMembers.append(member)
        if member.id == ownerId {
          owner = member
        }
      }

      rankedMembers.sort(by: { (lhs, rhs) -> Bool in
        lhs.localScore > rhs.localScore
      })
    }
  }
}

// MARK: - Equatable
extension Leaderboard : Equatable {}

func ==(lhs: Leaderboard, rhs: Leaderboard) -> Bool {
  return  lhs.event == rhs.event &&
          lhs.owner == rhs.owner &&
          lhs.rankedMembers == rhs.rankedMembers
}
