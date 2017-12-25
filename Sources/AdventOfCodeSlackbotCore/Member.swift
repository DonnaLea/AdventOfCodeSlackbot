//
//  Member.swift
//  AdventBotPackageDescription
//
//  Created by Donna McCulloch on 6/12/17.
//

import Foundation

struct Member : Codable {

  // MARK: - Coding Keys
  enum CodingKeys : String, CodingKey {
    case id
    case name
    case localScore = "local_score"
    case globalScore = "global_score"
    case stars
    case completedDays = "completion_day_level"
    case lastStarTime = "last_star_ts"
  }

  // MARK: - Properties
  let id: String
  let name: String
  let localScore: Int
  let globalScore: Int
  let stars: Int
  private(set) var completedDays: CompletionDayLevel
  private(set) var lastStarTime: Date? = nil
  private(set) var starsByCompletionDate = [Date : Star]()

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(String.self, forKey: .id)
    name = try container.decode(String.self, forKey: .name)
    localScore = try container.decode(Int.self, forKey: .localScore)
    globalScore = try container.decode(Int.self, forKey: .globalScore)
    stars = try container.decode(Int.self, forKey: .stars)
    completedDays = try container.decode(CompletionDayLevel.self, forKey: .completedDays)
    lastStarTime = try container.decodeIfPresent(Date.self, forKey: .lastStarTime)
    for day in completedDays.days.values {
      if let timestamp = day.part1StarTimestamp {
        starsByCompletionDate[timestamp] = Star(day: day.dayNumber, part: 1)
      }
      if let timestamp = day.part2StarTimestamp {
        starsByCompletionDate[timestamp] = Star(day: day.dayNumber, part: 2)
      }
    }

  }

  func mostRecent(numStars: Int) -> [Star] {
    var stars = [Star]()

    let sortedDates = starsByCompletionDate.keys.sorted()
    let latestDates = sortedDates.suffix(numStars)

    for date in latestDates {
      if let star = starsByCompletionDate[date] {
        stars.append(star)
      }
    }

    return stars
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
