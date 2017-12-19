import Alamofire
import Foundation

// MARK: - Type Alias'
typealias JSONDictionary = [String : Any]

public final class AdventOfCodeSlackbot {

  // MARK: - Keys
  private struct Keys {
    static let webhook = "SLACK_WEBHOOK"
    static let cookie = "ADVENT_COOKIE"
    static let json = "ADVENT_JSON"
  }

  // MARK: - Constants
  private struct Constants {
    static let delay = 60.0
  }

  private let jsonURL: String
  private let webhookURL: String
  private let cookie: String

  private let arguments: [String]
  private var leaderboard: Leaderboard?

  public init?(arguments: [String] = CommandLine.arguments) {
    self.arguments = arguments
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"

    guard let webhook = ProcessInfo.processInfo.environment[Keys.webhook],
      let json = ProcessInfo.processInfo.environment[Keys.json],
      let cookie = ProcessInfo.processInfo.environment[Keys.cookie] else {
        print("Could not find all environment variables: \(Keys.webhook), \(Keys.json), \(Keys.cookie)")
        return nil
    }

    jsonURL = json
    webhookURL = webhook
    self.cookie = cookie
  }

  public func run() throws {
    print("Hello Advent Of Code!")
    requestLeaderboardState()
    dispatchMain() // Does not return. Need to exit the application elsewhere.
  }

  func requestLeaderboardState() {
    print("requestingLeaderboardState")
    let headers = ["cookie": cookie]
    Alamofire.request(jsonURL, headers: headers).validate().responseJSON { response in

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
          let stars = rhsMember.mostRecent(numStars: starsDiff)
          for star in stars {
            let announcement = "\(member.name) completed \(star)! :star2:"
            notify(announcement: announcement)
          }
        }
      }
    }
  }

  func notify(announcement: String, appendLeaderboard: Bool = true) {
    let announcement = announcement + "\nSee the updated <http://adventofcode.com/2017/leaderboard/private/view/199958|leaderboard>"
    print(announcement)
    let parameters: Parameters = [ "text": announcement ]
    Alamofire.request(webhookURL, method: .post, parameters: parameters, encoding: JSONEncoding.default)
  }

}
