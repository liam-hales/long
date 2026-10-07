import SwiftUI

/// Used to render a single
/// task sheet item
struct TaskSheetItemView: View {
  private let _sheet: TaskSheetModel

  /// Initialises the view with
  /// the task `sheet` to render
  init(sheet: TaskSheetModel) {
    self._sheet = sheet
  }

  var body: some View {
    VStack(
      alignment: .leading,
      spacing: 10
    ) {
      Text(self._sheet.name)

      HStack(
        alignment: .center,
        spacing: 8
      ) {
        if (self._sheet.overdueCount > 0) {
          BadgeView(
            appearance: .error,
            icon: TaskFocus.overdue.icon,
            text: "\(self._sheet.overdueCount)"
          )
        }

        if (self._sheet.todayCount > 0) {
          BadgeView(
            appearance: .warning,
            icon: TaskFocus.today.icon,
            text: "\(self._sheet.todayCount)"
          )
        }

        if (
          self._sheet.overdueCount > 0 ||
          self._sheet.todayCount > 0
        ) {
          Text("•")
            .foregroundStyle(Color.contentSecondary)
            .font(.mono(11))
        }

        Text("\(self._sheet.activeCount) \((self._sheet.activeCount == 1) ? "task" : "tasks") to complete")
          .foregroundStyle(Color.contentSecondary)
          .font(.mono(11))
      }
    }
  }
}
