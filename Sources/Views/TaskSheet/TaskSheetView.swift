import SwiftData
import SwiftUI

/// Used to display the tasks
/// for a given task sheet
struct TaskSheetView: View {
  private let _sheet: TaskSheetModel

  @Environment(AppState.self)
  private var _appState: AppState

  @Environment(AppSettings.self)
  private var _appSettings: AppSettings

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

  private var _activeTasks: [TaskModel] {
    self._tasks.filter { task in task.isCompleted == false }
  }

  var body: some View {

    @Bindable
    var appState = _appState

    ScrollViewReader { proxy in
      List {
        if (self._appState.taskFocus != .all) {

          // Get the focussed tasks using
          // the `taskFocus` state
          let focusedTasks = self._tasks.filtered(by: self._appState.taskFocus)

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
                TaskRowView(
                  task: task,
                  dateFormat: self._appSettings.dateFormat,
                  isSelected: self._appState.revealedTaskId == task.id
                )
                .accessibilityAddTraits(.isButton)
                .onTapGesture {
                  self._appState.modalSelection = .editTask(task)
                }
              }
            }
          }
        }

        if (self._appState.taskFocus == .all) {
          if (self._tasks.isEmpty == true) {
            NoContentView(
              title: "No tasks.",
              message: "You currently have no tasks to complete, try creating one below."
            )
          }

          let filters = TaskFilter
            .allCases
            .filter { filter in filter != .all }

          // Section and render the
          // tasks by each filter
          ForEach(filters) { filter in
            let tasks = self._tasks.filtered(by: filter)

            if (tasks.isEmpty == false) {
              TaskSectionView(
                filter: filter,
                tasks: tasks
              ) { task in
                self._appState.modalSelection = .editTask(task)
              }
            }
          }
        }
      }
      .task(id: self._appState.revealedTaskId) {

        // This runs when the view appears and
        // whenever the highlighted task changes
        if let taskId = self._appState.revealedTaskId {
          withAnimation {
            proxy.scrollTo(taskId, anchor: .center)
          }
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
    .contentMargins(.vertical, 16, for: .scrollContent)
    .scrollContentBackground(.hidden)
    .scrollDismissesKeyboard(.interactively)
    .background(Color.base)
  }
}
