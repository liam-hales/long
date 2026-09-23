import Foundation
import SwiftData

/// Describes a task sheet the user
/// can create to group tasks
@Model
final class TaskSheetItem: Identifiable {
  var name: String = "";

  private(set) var createDate: Date = Date.now;
  private(set) var updateDate: Date = Date.now;

  /// Initialises a new task sheet
  /// with a given `name`
  init(name: String) {
    self.name = name;
    self.tasks = [];
    self.createDate = .now;
    self.updateDate = .now;
  }
}
