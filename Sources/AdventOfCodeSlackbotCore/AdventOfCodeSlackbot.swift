import Alamofire
import Foundation

// MARK: - Type Alias'
typealias JSONDictionary = [String : Any]

public final class AdventOfCodeSlackbot {
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
    let headers = ["cookie": "session=53616c7465645f5f18a31b842dab491425605682234662c8d5000822d9a1d3fead1135d21f0b1ac5f9d26bac2aff662f"]
    Alamofire.request("https://adventofcode.com/2017/leaderboard/private/view/199958.json", headers: headers).validate().responseJSON { response in

      defer {
        print("exiting")
        exit(EXIT_SUCCESS)
      }

      //    debugPrint("All Response Info: \(response)")

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

        return
      }

      if leaderboard != latestLeaderboard {
        self.compareLeaderboardsAndNotify(lhs: leaderboard, rhs: latestLeaderboard)
      }
    }
  }

  func compareLeaderboardsAndNotify(lhs: Leaderboard, rhs: Leaderboard) {
    if lhs.members != rhs.members {
      for (key, member) in lhs.members {
        if let rhsMember = rhs.members[key], member.stars != rhsMember.stars {
          let starsDiff = rhsMember.stars
          print("\(member.name) gained \(starsDiff) star(s)!")
        }
      }
    }
  }

}
