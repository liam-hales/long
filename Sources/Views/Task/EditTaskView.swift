import SwiftUI

/// Used to display the edit view which allows
/// the user to update task details
struct EditTaskView: View {
  private static let _maxTitleLength = 128
  private let _task: TaskModel

  @Environment(\.displayScale)
  private var _displayScale: CGFloat

  @FocusState
  private var _isFocused: Bool

  @State
  private var _title: String

  @State
  private var _hasDueDate: Bool

  @State
  private var _pickerDate: Date

  private var _trimmedTitle: String {
    self._title.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var _dueDate: Date? {
    (self._hasDueDate == true)
      ? self._pickerDate
      : nil
  }

  private var _hasChanges: Bool {
    (
      self._trimmedTitle != self._task.title ||
      self._dueDate != self._task.dueDate
    )
  }

  private var _isTitleValid: Bool {
    (
      self._trimmedTitle.count <= Self._maxTitleLength &&
      self._trimmedTitle.isEmpty == false
    )
  }

  /// Initialises the view with
  /// the `task` to edit
  init(task: TaskModel) {
    self._task = task

    self.__title = State(initialValue: task.title)
    self.__hasDueDate = State(initialValue: task.dueDate != nil)
    self.__pickerDate = State(initialValue: task.dueDate ?? Calendar.current.startOfDay(for: .now))
  }

  var body: some View {
    EditView(
      subject: "task",
      height: 820,
      hasChanges: self._hasChanges,
      isValid: self._isTitleValid,
      onSave: {
        self._task.update(
          title: self._trimmedTitle,
          dueDate: self._dueDate
        )
      },
      content: {
        VStack(
          alignment: .leading,
          spacing: 8
        ) {
          TextField(
            "Title",
            text: self.$_title,
            prompt: Text("Untitled")
              .foregroundStyle(Color.contentSecondary),
            axis: .vertical
          )
          .font(.serif(28, .semibold))
          .lineLimit(4)
          .focused(self.$_isFocused)
          .submitLabel(.done)
          .onChange(of: self._title) { _, newValue in

            // A vertical text field inserts a new line when the done
            // key is pressed, so remove it and close the keyboard instead
            if (newValue.contains(where: \.isNewline) == true) {
              self._title = newValue.filter { $0.isNewline == false }
              self._isFocused = false
            }
          }

          // Display the current title character
          // count so the user knows not to go over
          Text("\(self._trimmedTitle.count) / \(Self._maxTitleLength)")
            .foregroundStyle(
              (self._trimmedTitle.count > Self._maxTitleLength)
                ? Color.contentError
                : Color.contentSecondary
            )
            .font(.mono(14))
        }
        .padding(.horizontal, 4)

        VStack(
          alignment: .leading,
          spacing: 0
        ) {
          Toggle(isOn: self.$_hasDueDate) {
            VStack(
              alignment: .leading,
              spacing: 4
            ) {
              Text("Due date")
                .font(.serif(16, .semibold))
              Text("The date the task is due")
                .font(.mono(11))
                .foregroundStyle(Color.contentSecondary)
            }
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 20)

          Rectangle()
            .fill(Color.outline)
            .frame(height: 2 / self._displayScale)
            .allowsHitTesting(false)

          DatePicker(
            "Due date",
            selection: self.$_pickerDate,
            displayedComponents: .date
          )
          .padding(.leading, 8)
          .padding(.trailing, 14)
          .padding(.top, 4)
          .padding(.bottom, 8)
          .datePickerStyle(.graphical)
          .disabled(self._hasDueDate == false)
        }
        .background(
          RoundedRectangle(cornerRadius: 14)
            .fill(Color.surfaceHigh)
            .strokeBorder(Color.outline, lineWidth: 1)
        )
      }
    )
  }
}
