import SwiftUI

/// Used to display the app
/// settings to the user
struct SettingsView: View {

  var body: some View {

    let version = Bundle.main.appVersion
    let build = Bundle.main.appBuild

    VStack(
      alignment: .center,
      spacing: 6
    ) {
      Text("LONG")
        .font(.condensed(96))
      Text("Created by Liam Hales")
        .font(.serif(14, .regular))
      Text("Version \(version) (build \(build))")
        .foregroundStyle(Color.contentSecondary)
        .font(.mono(12))
    }
    .frame(
      maxWidth: .infinity,
      maxHeight: .infinity,
    )
    .presentationBackground(Color.base)
    .presentationDetents([
      .height(360)
    ])
  }
}
