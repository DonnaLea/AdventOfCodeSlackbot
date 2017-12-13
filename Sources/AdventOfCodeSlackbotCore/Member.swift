//
//  Member.swift
//  AdventBotPackageDescription
//
//  Created by Donna McCulloch on 6/12/17.
//

import Foundation

// MARK: - File variable
let dateFormatter = DateFormatter()

struct Member {
  // MARK: - Keys
  private struct Keys {
    static let completionDayLevel = "completion_day_level"
    static let globalScore = "global_score"
    static let id = "id"
    static let lastStarTimestamp = "last_star_ts"
    static let localScore = "local_score"
    static let name = "name"
    static let stars = "stars"
  }

  // MARK: - Properties
  let id: String
  let name: String
  let localScore: Int
  let globalScore: Int
  let stars: Int
  private(set) var completedDays = [Int : CompletionDayLevel]()
  private(set) var lastStarTime: Date? = nil

  // MARK: - Init
  init(dictionary: JSONDictionary) {
    id = dictionary[Keys.id] as? String ?? ""
    name = dictionary[Keys.name] as? String ?? ""
    localScore = dictionary[Keys.localScore] as? Int ?? 0
    globalScore = dictionary[Keys.globalScore] as? Int ?? 0
    stars = dictionary[Keys.stars] as? Int ?? 0
    if let dateString = dictionary[Keys.lastStarTimestamp] as? String {
      lastStarTime = dateFormatter.date(from: dateString)
    }

    if let completionDayLevels = dictionary[Keys.completionDayLevel] as? JSONDictionary {
      for slice in completionDayLevels {
        let completionDayLevel = CompletionDayLevel(dictionarySlice: slice)
        completedDays[completionDayLevel.day] = completionDayLevel
      }
    }
  }
}

// MARK: - Equatable
extension Member : Equatable {}

func ==(lhs: Member, rhs: Member) -> Bool {
  // No need to compare the completedDays as the information in 
  return  lhs.id == rhs.id &&
          lhs.name == rhs.name &&
          lhs.localScore == rhs.localScore &&
          lhs.globalScore == rhs.globalScore &&
          lhs.stars == rhs.stars &&
          lhs.lastStarTime == rhs.lastStarTime
}
