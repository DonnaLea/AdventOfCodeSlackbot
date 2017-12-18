//
//  Star.swift
//  AdventOfCodeSlackbot
//
//  Created by Donna McCulloch on 15/12/17.
//

import Foundation

struct Star {
  let day: Int
  let part: Int
}

extension Star : CustomStringConvertible {
  var description: String {
    return "Day \(day) - Part \(part)"
  }
}
