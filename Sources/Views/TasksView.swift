import LucideSwift
import SwiftData
import SwiftUI

/// Used to display the users
/// current outstanding tasks
struct TasksView: View {
  private let _sheet: TaskSheetModel

  @Environment(AppState.self)
  private var _appState: AppState

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

  private var _overdueTasks: [TaskModel] {
    self._tasks.filter { task in task.status == .overdue }
  }

  private var _todayTasks: [TaskModel] {
    self._tasks.filter { task in task.status == .today }
  }

  private var _scheduledTasks: [TaskModel] {
    self._tasks.filter { task in task.status == .scheduled }
  }

  private var _unscheduledTasks: [TaskModel] {
    self._tasks.filter { task in task.status == .unscheduled }
  }

  var body: some View {

    @Bindable
    var appState = _appState

    List {
      TaskInputView()
        .padding(.vertical, 10)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(.horizontal, 0)

      if (self._tasks.isEmpty == true) {
        VStack(
          alignment: .center,
          spacing: 6
        ) {
          Text("No tasks.")
            .font(.serif(22, .bold))
          Text("You currently have no tasks to complete, try creating one above.")
            .foregroundStyle(Color.contentSecondary)
            .font(.serif(14, .regular))
            .frame(maxWidth: 260)
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
        .listRowInsets(.horizontal, 0)
      }

      if (self._todayTasks.isEmpty == false) {
        Section(
          content: {
            ForEach(self._todayTasks) { task in
              Text(task.title)
            }
          },
          header: {
            Text("Today")
              .foregroundStyle(Color.contentSecondary)
              .font(.mono(16))
          }
        )
        .listRowInsets(.horizontal, 0)
      }

      if (self._scheduledTasks.isEmpty == false) {
        Section(
          content: {
            ForEach(self._scheduledTasks) { task in
              Text(task.title)
            }
          },
          header: {
            Text("Scheduled")
              .foregroundStyle(Color.contentSecondary)
              .font(.mono(16))
          }
        )
        .listRowInsets(.horizontal, 0)
      }

      if (self._unscheduledTasks.isEmpty == false) {
        Section {
          ForEach(self._unscheduledTasks) { task in
            Text(task.title)
          }
        }
        .listRowInsets(.horizontal, 0)
      }
    }
    .navigationTitle(self._sheet.name)
    .toolbar {
      ToolbarView()
    }
    .scrollContentBackground(.hidden)
    .background(Color.base)
  }
}
