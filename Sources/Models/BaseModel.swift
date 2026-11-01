import Foundation

/// Describes the shared
/// behaviour for all models
nonisolated protocol BaseModel: AnyObject {

  @MainActor
  var undoManager: TaskSheetUndoManager { get }
  var updateDate: Date { get set }
}

extension BaseModel {

  /// Used to set the property at the given `keyPath` to `value`
  /// and record the change to revert back to the previous value
  @MainActor
  func _update<Value>(
    _ keyPath: ReferenceWritableKeyPath<Self, Value>,
    to value: Value
  ) -> Void {
    let previousValue = self[keyPath: keyPath]

    self[keyPath: keyPath] = value

    // The property is set back to the
    // old value if the user chooses to undo
    self._recordChange {
      self._update(keyPath, to: previousValue)
    }
  }

  /// Used to set the update date and record
  /// the change with the undo manager
  @MainActor
  func _recordChange(undo: @escaping () -> Void) -> Void {
    self.updateDate = .now
    self.undoManager.registerUndo(withTarget: self) { _ in
      undo()
    }
  }
}
