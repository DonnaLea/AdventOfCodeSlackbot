//
//  CompletionDayLevel.swift
//  AdventBotPackageDescription
//
//  Created by Donna McCulloch on 10/12/17.
//

import Foundation

struct CompletionDayLevel {
  // MARK: - Keys
  private struct Keys {
    static let getStarTimestamp = "get_star_ts"
    static let part1 = "1"
    static let part2 = "2"
  }

  // MARK: - Properties
  let part1StarTimestamp: Date?
  let part2StarTimestamp: Date?
  let day: Int

  // MARK: - Init
  init(dictionarySlice: (key: String, value: Any)) {
    day = Int(dictionarySlice.key) ?? 0
    if let timestamps = dictionarySlice.value as? [String : JSONDictionary] {
      if let starTimestamp = timestamps[Keys.part1]?[Keys.getStarTimestamp] as? String {
        part1StarTimestamp = dateFormatter.date(from: starTimestamp)
      } else {
        part1StarTimestamp = nil
      }
      if let starTimestamp = timestamps[Keys.part2]?[Keys.getStarTimestamp] as? String {
        part2StarTimestamp = dateFormatter.date(from: starTimestamp)
      } else {
        part2StarTimestamp = nil
      }
    } else {
      part1StarTimestamp = nil
      part2StarTimestamp = nil
    }
  }
}
