import SwiftUI

/// Used to render a single
/// task sheet item
struct TaskSheetItemView: View {
  private let _sheet: TaskSheetModel
  private let _isSelected: Bool

  /// Initialises the view with the task `sheet`
  /// to render and whether it `isSelected`
  init(sheet: TaskSheetModel, isSelected: Bool) {
    self._sheet = sheet
    self._isSelected = isSelected
  }

  var body: some View {
    HStack(
      alignment: .top,
      spacing: 8
    ) {
      VStack(
        alignment: .leading,
        spacing: 6
      ) {
        Text(self._sheet.name)

        Text("\(self._sheet.activeCount) \((self._sheet.activeCount == 1) ? "task" : "tasks") to complete")
          .foregroundStyle(Color.contentSecondary)
          .font(.mono(11))
      }

      Spacer()

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
      }
    }
    .padding(.leading, 6)
    .listItem(isSelected: self._isSelected)
  }
}
