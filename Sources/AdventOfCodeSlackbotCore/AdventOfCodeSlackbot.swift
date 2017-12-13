import Alamofire
import Foundation

// MARK: - Type Alias'
typealias JSONDictionary = [String : Any]

public final class AdventOfCodeSlackbot {

  private struct Constants {
    static let delay = 20.0
    static let productionURL = "https://adventofcode.com/2017/leaderboard/private/view/199958.json"
    static let testURL = "http://localhost:8000/leaderboard.json"
  }

  private let arguments: [String]
  private var leaderboard: Leaderboard?

  public init(arguments: [String] = CommandLine.arguments) {
    self.arguments = arguments
  }

  public func run() throws {
    print("Hello Advent Of Code!")
    requestLeaderboardState()
    dispatchMain() // Does not return. Need to exit the application elsewhere.

  }

  func requestLeaderboardState() {
    print("requestingLeaderboardState")
    let headers = ["cookie": "session=53616c7465645f5f18a31b842dab491425605682234662c8d5000822d9a1d3fead1135d21f0b1ac5f9d26bac2aff662f"]
    Alamofire.request(Constants.productionURL, headers: headers).validate().responseJSON { response in

      defer {
        print("waiting \(Constants.delay) seconds before requesting")
        let when = DispatchTime.now() + Constants.delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
          self.requestLeaderboardState()
        })
      }

      guard response.result.isSuccess, let json = response.result.value as? JSONDictionary else {
        if let error = response.result.error {
          print("error: \(error)")
        }
        return
      }

      let latestLeaderboard = Leaderboard(dictionary: json)

      guard let leaderboard = self.leaderboard else {
        // This is the first version of the leaderboard retrieved.
        self.leaderboard = latestLeaderboard
        print("no need to compare, this is our first leaderboard")
        return
      }

      if leaderboard != latestLeaderboard {
        self.compareLeaderboardsAndNotify(lhs: leaderboard, rhs: latestLeaderboard)
        self.leaderboard = latestLeaderboard
      } else {
        print("leaderboards are the same")
      }
    }
  }

  func compareLeaderboardsAndNotify(lhs: Leaderboard, rhs: Leaderboard) {
    print("comparing leaderboards")
    if lhs.members != rhs.members {
      for (key, member) in lhs.members {
        if let rhsMember = rhs.members[key], member.stars != rhsMember.stars {
          let starsDiff = rhsMember.stars - member.stars
          print("\(member.name) gained \(starsDiff) star(s)!")
        }
      }
    }
  }

}
