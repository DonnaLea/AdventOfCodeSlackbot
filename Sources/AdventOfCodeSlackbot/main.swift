import AdventOfCodeSlackbotCore

let adventOfCodeSlackbot = AdventOfCodeSlackbot()

do {
  try adventOfCodeSlackbot?.run()
} catch {
  print("Whoops! An error occurred: \(error)")
}
