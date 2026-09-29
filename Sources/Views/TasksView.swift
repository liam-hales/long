import LucideSwift
import SwiftData
import SwiftUI

/// Used to display the users
/// current outstanding tasks
struct TasksView: View {
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

    // Query for the unarchived tasks for the
    // sheet ordered by ones that are due first
    self.__tasks = Query(
      filter: #Predicate<TaskModel> { task in
        task.sheet.id == sheetId &&
        task.isArchived == false
      },
      sort: \TaskModel.dueDate,
      order: .reverse
    )
  }

  private var _openTasks: [TaskModel] {
    self._tasks.filter { task in task.isSettled == false }
  }

  private var _overdueTasks: [TaskModel] {
    self._openTasks.filter { task in task.schedule == .overdue }
  }

  private var _todayTasks: [TaskModel] {
    self._openTasks.filter { task in task.schedule == .today }
  }

  private var _scheduledTasks: [TaskModel] {
    self._openTasks.filter { task in task.schedule == .scheduled }
  }

  private var _unscheduledTasks: [TaskModel] {
    self._openTasks.filter { task in task.schedule == .unscheduled }
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
      if (self._tasks.isEmpty == true) {
        Section {
          VStack(
            alignment: .center,
            spacing: 6
          ) {
            Text("No tasks.")
              .font(.serif(22, .bold))
            Text("You currently have no tasks to complete, try creating one below.")
              .foregroundStyle(Color.contentSecondary)
              .font(.serif(14, .regular))
              .frame(maxWidth: 260)
              .multilineTextAlignment(.center)
          }
          .frame(maxWidth: .infinity)
          .padding(.vertical, 20)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(.horizontal, 0)
      }

      if (self._todayTasks.isEmpty == false) {
        Section(
          content: {
            ForEach(self._todayTasks) { task in
              TaskView(task: task)
            }
          },
          header: {
            Text("Today")
              .foregroundStyle(Color.contentSecondary)
              .font(.mono(16))
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
            Text("Scheduled")
              .foregroundStyle(Color.contentSecondary)
              .font(.mono(16))
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
              .font(.mono(16))
              .listRowInsets(.horizontal, 20)
          }
        )
        .listRowSeparator(.hidden)
      }
    }
    .toolbar {
      ToolbarView()

      ToolbarItem(placement: .largeTitle) {
        Text(self._sheet.name)
          .font(.serif(28, .bold))
          .padding(.horizontal, 4)
          .padding(.top, 32)
          .padding(.bottom, -4)
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
    .listStyle(.plain)
    .navigationTitle(self._sheet.name)
    .navigationSubtitle("\(self._activeTasks.count) tasks to complete")
    .listRowSpacing(10)
    .contentMargins(.top, 20, for: .scrollContent)
    .contentMargins(.bottom, 20, for: .scrollContent)
    .scrollContentBackground(.hidden)
    .scrollDismissesKeyboard(.interactively)
    .background(Color.base)
  }
}
