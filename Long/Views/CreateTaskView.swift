import SwiftUI
import SwiftData
import LucideSwift

/// Used to create a new task from within
/// a sheet presented in the `TasksView`
struct CreateTaskView: View {

  @Environment(\.modelContext)
  private var _modelContext: ModelContext;

  @Environment(\.dismiss)
  private var _dismiss: DismissAction;
  
  @State
  private var _title: String = "";
  
  @FocusState
  private var _isFocused: Bool;
  
  private var _trimmedTitle: String {
    return self._title.trimmingCharacters(in: .whitespacesAndNewlines);
  }
  
  /// Creates and stores a new task with the
  /// entered title then dismisses the sheet
  private func _create() {
    // Check if the trimmed title
    // is empty and if so return
    if (self._trimmedTitle.isEmpty == true) {
      return;
    }
    
    // Create the new task
    // with the trimmed title
    let newTask = TaskItem(title: self._trimmedTitle)
    
    // Insert and immediately save the
    // new task so it persists
    self._modelContext.insert(newTask);
    try? self._modelContext.save();
    
    self._dismiss();
  }

  var body: some View {
    NavigationStack {
      VStack {
        TextField("What do you need to get done?", text: self.$_title)
          .focused(self.$_isFocused)
          .submitLabel(.done)
          .padding(.horizontal, 20)
          .onSubmit {
            self._create();
          }
      }
      .task {
        self._isFocused = true;
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(
            action: {
              self._dismiss();
            },
            label: {
              LucideIcon(.x, size: 22);
            }
          )
        }
        
        ToolbarItem(placement: .topBarTrailing) {
          Button(
            action: {
              self._create();
            },
            label: {
              Text("Create");
            }
          )
          .disabled(self._trimmedTitle.isEmpty == true);
        }
      }
    }
    .presentationBackground {
      ConcentricRectangle()
        .fill(Color(.systemBackground))
        .overlay(
          ConcentricRectangle()
            .stroke(.blue, lineWidth: 2)
        )
      }
    .presentationDetents([
      .height(130)
    ]);
  }
}
