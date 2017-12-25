//
//  CompletionDayLevel.swift
//  AdventBotPackageDescription
//
//  Created by Donna McCulloch on 10/12/17.
//

import Foundation

struct CompletionDayLevel {
  struct CompletionDay {
    // MARK: - Properties
    let part1StarTimestamp: Date?
    let part2StarTimestamp: Date?
    let dayNumber: Int
  }

  // MARK: - Properties
  var days = [Int : CompletionDay]()

  // MARK: - Init
  init(days: [CompletionDay] = []) {
    for day in days {
      self.days[day.dayNumber] = day
    }
  }
}

// MARK: - Encoding
extension CompletionDayLevel : Encodable {

  // MARK: - Coding Keys
  struct CompletionDayCodingKey : CodingKey {
    var stringValue: String
    init?(stringValue: String) {
      self.stringValue = stringValue
    }

    var intValue: Int? { return nil }
    init?(intValue : Int) { return nil }

    static let part1 = CompletionDayCodingKey(stringValue: "1")!
    static let part2 = CompletionDayCodingKey(stringValue: "2")!
    static let getStarTimestamp = CompletionDayCodingKey(stringValue: "get_star_ts")!
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CompletionDayCodingKey.self)

    for day in days.values {
      // The completionDay number is used as a key name.
      let dayKey = CompletionDayCodingKey(stringValue: String(day.dayNumber))!
      var dayContainer = container.nestedContainer(keyedBy: CompletionDayCodingKey.self, forKey: dayKey)
      var part1Container = dayContainer.nestedContainer(keyedBy: CompletionDayCodingKey.self, forKey: .part1)
      var part2Container = dayContainer.nestedContainer(keyedBy: CompletionDayCodingKey.self, forKey: .part2)

      // The rest of the keys use static names defined in `CompletionDayCodingKey`.
      try part1Container.encodeIfPresent(day.part1StarTimestamp, forKey: .getStarTimestamp)
      try part2Container.encodeIfPresent(day.part2StarTimestamp, forKey: .getStarTimestamp)

    }
  }

}

// MARK: - Decoding
extension CompletionDayLevel : Decodable {
  public init(from decoder: Decoder) throws {
    var days = [CompletionDay]()
    let container = try decoder.container(keyedBy: CompletionDayCodingKey.self)
    for key in container.allKeys {
      // Note how the `key` in the loop above is used immediately to access a nested container.
      let dayContainer = try container.nestedContainer(keyedBy: CompletionDayCodingKey.self, forKey: key)
      let part1Container = try dayContainer.nestedContainer(keyedBy: CompletionDayCodingKey.self, forKey: .part1)
      var part2StarTimestamp: Date? = nil
      if dayContainer.contains(.part2) {
        let part2Container = try dayContainer.nestedContainer(keyedBy: CompletionDayCodingKey.self, forKey: .part2)
        part2StarTimestamp = try part2Container.decodeIfPresent(Date.self, forKey: .getStarTimestamp)
      }
      let part1StarTimestamp = try part1Container.decodeIfPresent(Date.self, forKey: .getStarTimestamp)

      // The key is used again here and completes the collapse of the nesting that existed in the JSON representation.
      let dayNumber = Int(key.stringValue)!
      let day = CompletionDay(part1StarTimestamp: part1StarTimestamp, part2StarTimestamp: part2StarTimestamp, dayNumber: dayNumber)
      days.append(day)

    }

    self.init(days: days)
  }
}

