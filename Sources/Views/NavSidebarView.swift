import SwiftUI
import SwiftData
import LucideSwift

/// Used to display the navigation
/// sidebar options for the app
struct NavSidebarView: View {
  private let _sizeClass: UserInterfaceSizeClass?;

  @Environment(AppState.self)
  private var _appState: AppState;

  @Environment(\.displayScale)
  private var _displayScale: CGFloat;

  /// Query for the task sheets ordered
  /// by updated most recent
  @Query(
    sort: \TaskSheetItem.createDate,
    order: .reverse
  )
  private var _taskSheets: [TaskSheetItem];

  /// Initialises the view with
  /// the app `sizeClass`
  init(sizeClass: UserInterfaceSizeClass?) {
    self._sizeClass = sizeClass;
  }

  var body: some View {

    @Bindable
    var appState = _appState;

    List(selection: $appState.navSelection) {
      Section(
        content: {
          ForEach(self._taskSheets) { sheet in
            let value = AppState.NavSelection.taskSheet(sheet.id);

            NavigationLink(value: value) {
              Text(sheet.name);
            }
          }
        },
        header: {
          Text("Task Sheets")
            .foregroundStyle(Color.contentSecondary)
            .font(.mono(16));
        }
      )

      Section(
        content: {
          NavigationLink(value: AppState.NavSelection.archived) {
            Label(
              title: {
                Text("Archived");
              },
              icon: {
                Image(
                  lucide: .archive,
                  size: .init(width: 22, height: 22)
                );
              }
            );
          }

          NavigationLink(value: AppState.NavSelection.settings) {
            Label(
              title: {
                Text("Settings");
              },
              icon: {
                Image(
                  lucide: .settings,
                  size: .init(width: 22, height: 22)
                );
              }
            );
          }
        }
      )
    }
    .navigationTitle("Long")
    .toolbar(removing: .sidebarToggle)
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        Button(
          action: {
            self._appState.createTaskSheet(name: "Untitled");
          },
          label: {
            HStack(
              alignment: .center,
              spacing: 8
            ) {
              LucideIcon(.filePlusCorner, size: 22);

              Text("New Sheet")
                .font(.serif(14, .bold))
                .padding(.top, 2)
            }
          }
        );
      }

      // Show the sidebar open button only
      // if the size class is set to `regular`
      if (self._sizeClass == .regular) {
        ToolbarSpacer(
          .fixed,
          placement: .topBarTrailing
        );

        ToolbarItem(placement: .topBarTrailing) {
          Button(
            action: {
              self._appState.navVisibility = .detailOnly;
            },
            label: {
              LucideIcon(.panelRightOpen, size: 22)
            }
          );
        }
      }
    }
    .scrollContentBackground(.hidden)
    .background(Color.base)
    .safeAreaInset(
      edge: .trailing,
      spacing: 0
    ) {
      
      // Show the divider only if the
      // size class is set to `regular`
      if (self._sizeClass == .regular) {
        Rectangle()
          .fill(Color.outline)
          .frame(width: 2 / self._displayScale)
          .ignoresSafeArea(edges: .vertical)
          .allowsHitTesting(false);
      }
    };
  }
}
