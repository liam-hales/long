import LucideSwift
import SwiftUI

/// Used to display the edit view which allows
/// the user to update task details
struct EditTaskView: View {
  private static let _maxTitleLength = 128
  private let _task: TaskModel

  @Environment(\.displayScale)
  private var _displayScale: CGFloat

  @Environment(\.dismiss)
  private var _dismiss: DismissAction

  @State
  private var _title: String

  @State
  private var _hasDueDate: Bool

  @State
  private var _pickerDate: Date

  @State
  private var _showDiscardConfirmation: Bool = false

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

  private var _isSaveDisabled: Bool {
    (
      self._hasChanges == false ||
      self._isTitleValid == false
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

  /// Used to save the task
  /// and dismiss the view
  private func _save() -> Void {
    self._task.update(
      title: self._trimmedTitle,
      dueDate: self._dueDate
    )

    self._dismiss()
  }

  /// Used to dismiss the view or confirm with
  /// the user first if they have unsaved changes
  private func _close() -> Void {

    // If the user has edited the task then
    // confirm before discarding the changes
    if (self._hasChanges == true) {
      self._showDiscardConfirmation = true
      return
    }

    self._dismiss()
  }

  var body: some View {
    NavigationStack {
      VStack(
        alignment: .center,
        spacing: 28
      ) {
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
          .submitLabel(.done)

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
            Text("Due date")
              .font(.mono(14))
              .foregroundStyle(Color.contentSecondary)
          }
          .padding(.horizontal, 20)
          .padding(.vertical, 20)

          Rectangle()
            .fill(Color.outline)
            .frame(height: 2 / self._displayScale)
            .ignoresSafeArea(edges: .horizontal)
            .allowsHitTesting(false)

          DatePicker(
            "Due date",
            selection: self.$_pickerDate,
            displayedComponents: .date
          )
          .padding(.leading, 8)
          .padding(.trailing, 14)
          .padding(.vertical, 8)
          .datePickerStyle(.graphical)
          .disabled(self._hasDueDate == false)
        }
        .background(
          RoundedRectangle(cornerRadius: 14)
            .fill(Color.surfaceHigh)
            .strokeBorder(Color.outline, lineWidth: 1)
        )
      }
      .padding(.horizontal, 16)
      .padding(.top, 26)
      .frame(
        maxWidth: .infinity,
        maxHeight: .infinity,
        alignment: .top
      )
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button(
            action: self._close
          ) {
            LucideIcon(.x, size: 22)
          }
          .confirmationDialog(
            "Discard changes?",
            isPresented: self.$_showDiscardConfirmation,
            titleVisibility: .visible,
            actions: {
              Button(
                "Discard Changes",
                role: .destructive
              ) {
                self._dismiss()
              }
            },
            message: {
              Text("Your changes to this task will be lost.")
            }
          )
        }

        ToolbarItem(placement: .confirmationAction) {
          Button(
            action: self._save
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

              Text("Save")
                .font(.serif(16, .semibold))
            }
            .padding(.horizontal, 6)
            .foregroundStyle(
              (self._isSaveDisabled == true)
                ? .contentSecondary
                : .white
            )
          }
          .buttonStyle(.glassProminent)
          .disabled(self._isSaveDisabled)
          .tint(
            (self._isSaveDisabled == true)
              ? .disabled
              : .accent
          )
        }
      }
      .navigationTitle("Edit")
      .navigationSubtitle("Update task details")
      .navigationBarTitleDisplayMode(.inline)
      .interactiveDismissDisabled(self._hasChanges)
    }
    .presentationBackground(Color.base)
    .presentationDetents([
      .height(820)
    ])
  }
}
