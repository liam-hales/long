import Foundation
import SwiftData

extension ModelContext {

  /// Used to clean up the stored model data which
  /// should only call this on launch before it's used
  func cleanup() -> Void {

    // Delete tasks that have been removed from their sheet, they're
    // only kept while the app is running so are safe to delete now
    try? self.delete(
      model: TaskModel.self,
      where: #Predicate { $0.sheet == nil }
    )

    try? self.save()
  }
}
