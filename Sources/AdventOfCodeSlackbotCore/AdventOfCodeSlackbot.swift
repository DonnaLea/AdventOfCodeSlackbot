import Foundation
import Dispatch

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
    static let cookie = "cookie"
  }

  private let jsonURL: URL
  private let webhookURL: URL
  private let cookie: String

  private let arguments: [String]
  private var leaderboard: Leaderboard?
  static let jsonDateDecoder = JSONDecoder.DateDecodingStrategy.custom { (decoder) -> Date in
    // Possible date string format "1543743314", otherwise 0
    let container = try decoder.singleValueContainer()
    let dateStr = try? container.decode(String.self)
    var date: Date? = nil
    if let dateStr = dateStr {
      if let timeSinceEpoch = TimeInterval(dateStr) {
        date = Date(timeIntervalSince1970: timeSinceEpoch)
      }
    } else {
      let timeSinceEpoch = try? container.decode(Double.self)
      if let timeSinceEpoch = timeSinceEpoch {
        date = Date(timeIntervalSince1970: timeSinceEpoch)
      }
    }
    if date == nil {
      date = Date(timeIntervalSince1970: 0)
    }

    return date!
  }

  // MARK: - Init
  public init?(arguments: [String] = CommandLine.arguments) {
    self.arguments = arguments

    guard let webhook = ProcessInfo.processInfo.environment[Keys.webhook],
      let json = ProcessInfo.processInfo.environment[Keys.json],
      let cookie = ProcessInfo.processInfo.environment[Keys.cookie],
      let webhookURL = URL(string: webhook), let jsonURL = URL(string: json) else {
        print("Could not find all environment variables: \(Keys.webhook), \(Keys.json), \(Keys.cookie)")
        return nil
    }

    self.jsonURL = jsonURL
    self.webhookURL = webhookURL
    self.cookie = cookie
  }

  public func run() throws {
    print("Hello Advent Of Code!")
    requestLeaderboardState()
    dispatchMain() // Does not return. Need to exit the application elsewhere.
  }

  func requestLeaderboardState() {
    print("requestingLeaderboardState")
    var request = URLRequest(url: jsonURL)
    request.addValue(cookie, forHTTPHeaderField: Constants.cookie)
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: request) { data, response, error in
      defer {
        print("waiting \(Constants.delay) seconds before requesting")
        let when = DispatchTime.now() + Constants.delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: {
          self.requestLeaderboardState()
        })
      }
      
      guard error == nil else {
        print("Error: \(String(describing: error))")
        return
      }

      guard let data = data, let response = String(data: data, encoding: .utf8) else {
        print("no response from data")
        return
      }


      let decoder = JSONDecoder()
      if #available(OSX 10.12, *) {
        decoder.dateDecodingStrategy = AdventOfCodeSlackbot.jsonDateDecoder
      } else {
        print("ios8601 not available")
      }
      if let latestLeaderboard = try? decoder.decode(Leaderboard.self, from: data) {

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
      } else {
        print("unable to decode Leaderboard")
      }
    }
    task.resume()

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
    let announcement = announcement + "\nSee the updated <\(jsonURL.absoluteString.prefix(jsonURL.absoluteString.count - 5))|leaderboard>"
    print(announcement)
    var request = URLRequest(url: webhookURL)
    request.httpMethod = "POST"
    let parameters = [ "text": announcement ]
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
    let session = URLSession(configuration: .default)
    let task = session.dataTask(with: request) { data, response, error in
      guard data != nil, error == nil else {                                                 // check for fundamental networking error
        print("error=\(String(describing: error))")
        return
      }

      if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
        print("statusCode should be 200, but is \(httpStatus.statusCode)")
        print("response = \(String(describing: response))")
      }

    }
    task.resume()
  }

}
