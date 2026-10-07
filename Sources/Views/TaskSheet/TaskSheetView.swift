import LucideSwift
import SwiftData
import SwiftUI

/// Used to display the tasks
/// for a given task sheet
struct TaskSheetView: View {
  private let _sheet: TaskSheetModel

  @Environment(AppState.self)
  private var _appState: AppState

  /// Used for force the view to rebuild when the
  /// app comes back from the background
  @Environment(\.scenePhase)
  private var _scenePhase: ScenePhase

  @Query
  private var _tasks: [TaskModel]

  /// Initialises the view with the task
  /// `sheet` to display tasks for
  init(sheet: TaskSheetModel) {
    self._sheet = sheet

    // `#Predicate` used below can only capture plain values
    // So we must extract the sheet ID first before using it
    let sheetId = self._sheet.id

    // Query for all tasks for the sheet
    // ordered by ones that are due first
    self.__tasks = Query(
      filter: #Predicate<TaskModel> { task in
        task.sheet?.id == sheetId
      },
      sort: \TaskModel.dueDate,
      order: .forward
    )
  }

  private var _overdueTasks: [TaskModel] {
    self._tasks.filter { task in
      (
        task.isSettled == false &&
        task.schedule == .overdue
      )
    }
  }

  private var _todayTasks: [TaskModel] {
    self._tasks.filter { task in
      (
        task.isSettled == false &&
        task.schedule == .today
      )
    }
  }

  private var _scheduledTasks: [TaskModel] {
    self._tasks.filter { task in
      (
        task.isSettled == false &&
        task.schedule == .scheduled
      )
    }
  }

  private var _unscheduledTasks: [TaskModel] {
    self._tasks.filter { task in
      (
        task.isSettled == false &&
        task.schedule == .unscheduled
      )
    }
  }

  private var _completedTasks: [TaskModel] {
    let sort = SortDescriptor(\TaskModel.completedDate, order: .reverse)

    return self._tasks
      .filter { task in task.isSettled == true }
      .sorted(using: sort)
  }

  private var _activeTasks: [TaskModel] {
    self._tasks.filter { task in task.isCompleted == false }
  }

  var body: some View {

    @Bindable
    var appState = _appState

    List {
      if (self._appState.taskFocus != .all) {
        // Get the focussed tasks based
        // on the `taskFocus` state
        let focusedTasks = switch self._appState.taskFocus {
          case .all: self._tasks
          case .today: self._todayTasks
          case .overdue: self._overdueTasks
          case .scheduled: self._scheduledTasks
          case .unscheduled: self._unscheduledTasks
          case .completed: self._completedTasks
        }

        if (focusedTasks.isEmpty == true) {
          let focus = self._appState.taskFocus.title

          NoContentView(
            title: "No tasks.",
            message: "There are no tasks for the \"\(focus)\" focus, try choosing a different one."
          )
        }

        if (focusedTasks.isEmpty == false) {
          Section {
            ForEach(focusedTasks) { task in
              TaskView(task: task)
            }
          }
          .listRowSeparator(.hidden)
        }
      }

      if (self._appState.taskFocus == .all) {
        if (self._tasks.isEmpty == true) {
          NoContentView(
            title: "No tasks.",
            message: "You currently have no tasks to complete, try creating one below."
          )
        }

        if (self._todayTasks.isEmpty == false) {
          Section(
            content: {
              ForEach(self._todayTasks) { task in
                TaskView(task: task)
              }
            },
            header: {
              Text("Today • \(self._todayTasks.count)")
                .foregroundStyle(Color.contentSecondary)
                .font(.mono(14))
                .listRowInsets(.horizontal, 24)
            }
          )
          .listRowSeparator(.hidden)
        }

        if (self._scheduledTasks.isEmpty == false) {
          Section(
            content: {
              ForEach(self._scheduledTasks) { task in
                TaskView(task: task)
              }
            },
            header: {
              Text("Scheduled • \(self._scheduledTasks.count)")
                .foregroundStyle(Color.contentSecondary)
                .font(.mono(14))
                .listRowInsets(.horizontal, 24)
            }
          )
          .listRowSeparator(.hidden)
        }

        if (self._unscheduledTasks.isEmpty == false) {
          Section {
            ForEach(self._unscheduledTasks) { task in
              TaskView(task: task)
            }
          }
          .listRowSeparator(.hidden)
        }

        if (self._completedTasks.isEmpty == false) {
          Section(
            content: {
              ForEach(self._completedTasks) { task in
                TaskView(task: task)
              }
            },
            header: {
              Text("Completed • \(self._completedTasks.count)")
                .foregroundStyle(Color.contentSecondary)
                .font(.mono(14))
                .listRowInsets(.horizontal, 24)
            }
          )
          .listRowSeparator(.hidden)
        }
      }
    }
    .toolbar {
      TaskSheetToolbar(sheet: self._sheet)

      ToolbarItem(placement: .largeTitle) {
        Text(self._sheet.name)
          .font(.serif(28, .semibold))
          .padding(.horizontal, 4)
          .padding(.top, 32)
          .frame(
            maxWidth: .infinity,
            alignment: .leading
          )
      }

      ToolbarItem(placement: .largeSubtitle) {
        Text("\(self._activeTasks.count) tasks to complete")
          .foregroundStyle(Color.contentSecondary)
          .font(.mono(14))
          .padding(.horizontal, 4)
          .frame(
            maxWidth: .infinity,
            alignment: .leading
          )
      }
    }
    .safeAreaInset(
      edge: .bottom,
      spacing: 0
    ) {
      TaskInputView()
    }
    .alert(
      self._appState.captureError?.title ?? "",
      isPresented: Binding(
        get: {
          self._appState.captureError != nil
        },
        set: { _ in
          self._appState.captureError = nil
        }
      ),
      presenting: self._appState.captureError,
      actions: { _ in
        Button("OK", role: .cancel) {
          self._appState.captureError = nil
        }
      },
      message: { error in
        Text(error.message)
      }
    )
    .listStyle(.plain)
    .navigationTitle(self._sheet.name)
    .navigationSubtitle("\(self._activeTasks.count) tasks to complete")
    .listRowSpacing(10)
    .listSectionSpacing(16)
    .contentMargins(.vertical, 20, for: .scrollContent)
    .scrollContentBackground(.hidden)
    .scrollDismissesKeyboard(.interactively)
    .background(Color.base)
  }
}
