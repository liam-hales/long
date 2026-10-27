import LucideSwift
import SwiftUI

/// Used to welcome the user and show them
/// how to get started with the app
struct WelcomeView: View {

  @Environment(AppState.self)
  private var _appState: AppState

  var body: some View {
    ScrollView {
      VStack(
        alignment: .center,
        spacing: 36
      ) {
        Text("LONG")
          .font(.logo(100))

        VStack(
          alignment: .center,
          spacing: 6
        ) {
          Text("Welcome to Long.")
            .font(.serif(28, .semibold))

          Text("Don't be long. Get stuff done.")
            .foregroundStyle(Color.contentSecondary)
            .font(.mono(14))
        }

        VStack(
          alignment: .leading,
          spacing: 20
        ) {
          WelcomeStepView(
            number: 1,
            title: "Create a task sheet.",
            message: "Task sheets group related tasks together. Create one for home, work or a project."
          )

          WelcomeStepView(
            number: 2,
            title: "Add tasks.",
            message: "Type out what you need to do and let on-device Apple Intelligence create you your tasks."
          )

          WelcomeStepView(
            number: 3,
            title: "Get stuff done.",
            message: "Use focus to see what’s due and tick off tasks as you go."
          )
        }
        .padding(20)
        .background(
          RoundedRectangle(cornerRadius: 14)
            .fill(Color.surfaceHigh)
            .strokeBorder(Color.outline, lineWidth: 1)
        )

        VStack(
          alignment: .center,
          spacing: 20
        ) {
          Button(
            action: {
              self._appState.createTaskSheet(name: "Untitled")
            },
            label: {
              HStack(
                alignment: .center,
                spacing: 8
              ) {
                LucideIcon(.rocket, size: 20)

                Text("Get started")
                  .font(.serif(16, .semibold))
              }
              .padding(.horizontal, 6)
              .foregroundStyle(.white)
            }
          )
          .buttonStyle(.glassProminent)
          .tint(.accent)

          Text("Capturing tasks uses Apple Intelligence which can make mistakes. Review tasks before they are added.")
            .font(.serif(13, .regular))
            .lineHeight(.multiple(factor: 1.4))
            .foregroundStyle(Color.contentSecondary)
            .multilineTextAlignment(.center)
        }
      }
      .frame(maxWidth: 400)
      .padding(.top, 32)
      .containerMargins()
      // Stretch the content to the full width so the scroll
      // view fills the screen and its indicator sits at the edge
      .frame(maxWidth: .infinity)
    }
    // Vertically centre the content when it's
    // shorter than the screen, otherwise scroll
    .defaultScrollAnchor(.center, for: .alignment)
    .scrollBounceBehavior(.basedOnSize)
    .background(Color.base)
  }
}
