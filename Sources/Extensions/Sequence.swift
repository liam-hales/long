import Foundation

extension Sequence {

  /// Maps items from an array and retruns the non-`nil` results of calling
  /// the given `async` transformation with each element of this sequence
  func asyncCompactMap<T>(_ transform: (Element) async throws -> T?) async rethrows -> [T] {
    var results: [T] = []

    for element in self {

      // Await the result for the current element and
      // apprend it to the results array once finished
      if let result = try await transform(element) {
        results.append(result)
      }
    }

    return results
  }
}
