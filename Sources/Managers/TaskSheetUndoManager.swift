import Foundation
import Observation

/// The undo manager used to record changes made to a task
/// sheet and its tasks, with observable undo and redo states
final class TaskSheetUndoManager: UndoManager, Observable {
  private let _registrar = ObservationRegistrar()
  private var _tokens: [NotificationCenter.ObservationToken] = []

  override var canUndo: Bool {
    self._registrar.access(self, keyPath: \.canUndo)
    return super.canUndo
  }

  override var canRedo: Bool {
    self._registrar.access(self, keyPath: \.canRedo)
    return super.canRedo
  }

  /// Initialises the undo manager and listens for
  /// when changes are recorded, undone or redone
  override init() {
    super.init()

    // The observers are removed when their tokens are
    // released, so they're kept for the managers lifetime
    self._tokens = [
      NotificationCenter
        .default
        .addObserver(of: self, for: .didCloseUndoGroup) { [weak self] _ in
          self?._didChange()
        },
      NotificationCenter
        .default
        .addObserver(of: self, for: .didUndoChange) { [weak self] _ in
          self?._didChange()
        },
      NotificationCenter
        .default
        .addObserver(of: self, for: .didRedoChange) { [weak self] _ in
          self?._didChange()
        },
    ]
  }

  /// Used to notify observers that `canUndo`
  /// and `canRedo` may have changed
  private func _didChange() -> Void {
    self._registrar.willSet(self, keyPath: \.canUndo)
    self._registrar.willSet(self, keyPath: \.canRedo)
    self._registrar.didSet(self, keyPath: \.canUndo)
    self._registrar.didSet(self, keyPath: \.canRedo)
  }
}
