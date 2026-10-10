import LucideSwift
import SwiftUI

/// Used to display the captured tasks for
/// the user to review before they are added
struct ReviewTasksView: View {

  @Environment(AppState.self)
  private var _appState: AppState

  @Environment(\.dismiss)
  private var _dismiss: DismissAction

  @State
  private var _contentHeight: CGFloat = 400

  private var _isAddDisabled: Bool {
    (
      self._appState.isCapturing == true ||
      self._appState.capturedTasks.contains { $0.reviewStatus == .confirmed } == false
    )
  }

  /// Used to add the confirmed
  /// tasks and dismiss the view
  private func _add() -> Void {
    self._appState.addConfirmedTasks()
    self._dismiss()
  }

  var body: some View {
    NavigationStack {
      List {
        Section {
          ForEach(self._appState.capturedTasks) { task in
            CapturedTaskRowView(task: task)
          }
        }
        .listRowSeparator(.hidden)
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(
            action: {
              self._dismiss()
            },
            label: {
              LucideIcon(.x, size: 22)
            }
          )
        }

        ToolbarItem(placement: .confirmationAction) {
          Button(
            action: self._add
          ) {
            HStack(
              alignment: .center,
              spacing: 8
            ) {
              LucideIcon(
                .check,
                size: 20,
                strokeWidth: 3
              )

              Text("Add")
                .font(.serif(16, .semibold))
            }
            .padding(.horizontal, 6)
            .foregroundStyle(
              (self._isAddDisabled == true)
                ? .contentSecondary
                : .white
            )
          }
          .buttonStyle(.glassProminent)
          .disabled(self._isAddDisabled)
          .tint(
            (self._isAddDisabled == true)
              ? .disabled
              : .accent
          )
        }
      }
      .listStyle(.plain)
      .navigationTitle("Review")
      .navigationSubtitle("You have \(self._appState.capturedTasks.count) tasks to review")
      .navigationBarTitleDisplayMode(.inline)
      .listRowSpacing(10)
      .contentMargins(.vertical, 20, for: .scrollContent)
      .contentMargins(.horizontal, 20, for: .scrollContent)
      .scrollContentBackground(.hidden)
      .background(Color.base)
      .onScrollGeometryChange(
        for: CGFloat.self,
        of: { geometry in
          // The top inset covers the nav bar and top margin and the bottom margin is added
          // manually as the detent height already excludes the bottom safe area
          (
            geometry.contentInsets.top +
            geometry.contentSize.height +
            20
          )
        },
        action: { _, height in
          self._contentHeight = height
        }
      )
    }
    .presentationBackground(Color.base)
    .presentationDetents([
      .height(self._contentHeight)
    ])
  }
}
