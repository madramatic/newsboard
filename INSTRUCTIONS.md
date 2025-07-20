# GitHub Copilot Instructions for newsboard Flutter Project

## Project Overview
- This is a news app built with Flutter.
- Backend: Firebase (authentication, database, etc.)
- State Management: Riverpod
- Networking: Dio

## Strict CLEAN Architecture & File Structure
- **Strictly follow CLEAN architecture and SOLID principles in all code.**
- **Always separate code into appropriate layers and folders:**
  - `lib/presentation/` for UI widgets, screens, and themes.
  - `lib/domain/` for business logic, entities, and use cases.
  - `lib/data/` for data sources, repositories, and models.
- **Never place logic, configuration, or reusable code in the app entry file (`app.dart` or `main.dart`).**
- **For theming:**
  - Place all theme-related code in `lib/presentation/theme/` (e.g., `theme_data.dart`).
  - Only reference the theme in the app entry point; do not define it there.
- **Whenever adding new features or logic, create new files and folders as needed to maintain separation of concerns and modularity.**
- **Review and refactor existing code to ensure it adheres to this structure.**
- **Never add comments in code unless they are documentation or truly needed for clarity.**

## Theming, Constants, and Configuration
- **Always use the app theme for all colors, text styles, and UI properties. Never hardcode values in widgets or business logic unless absolutely necessary.**
- **When creating new features or updating existing ones, reference colors, text styles, and other UI properties from the theme.**
- **All constants, configuration values, and reusable settings must be placed in dedicated files (such as `constants.dart`, `config.dart`, or within the theme directory). Never hardcode values directly in widgets, screens, or business logic.**
- **If a value must be hardcoded (e.g., for a one-off or platform limitation), document the reason with a comment.**
- **Follow best practices for maintainability and scalability: keep configuration, constants, and theming separate and reusable.**

## Commit Guidelines
- **Commits must be modular**: Each commit should address a single concern or feature.
- **Follow Conventional Commits**: Use prefixes like `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`, etc.
- **Commit messages**: Be clear and concise, describing what and why (not how).

## Example Commit Messages
- `feat(auth): implement Firebase email/password login`
- `fix(news): handle Dio network timeout error`
- `refactor(ui): extract NewsCard widget for reusability`
- `docs(readme): add project setup instructions`

## Instructions Maintenance & Consistency
- **Update this document** whenever:
  - A new dependency is added (e.g., packages in `pubspec.yaml`).
  - A new feature is introduced.
  - A new coding pattern, architectural decision, or best practice is adopted (e.g., using the `equatable` package for value equality).
- **Always maintain consistency**: Ensure new code aligns with existing patterns, architecture, and guidelines.
- **Codebase awareness**: Before adding new features or patterns, review the entire codebase to understand current practices and avoid conflicts or duplication.
- **Document all decisions**: Any significant change or decision (dependencies, patterns, architecture) must be reflected here to guide Copilot and contributors.

## Splash Screen

- Only use the `flutter_native_splash` package for splash screen implementation.
- Do not implement custom splash screen widgets or logic in Dart code.
- Configure splash screen appearance in `flutter_native_splash.yaml`.

## Additional Notes
- Prefer Riverpod for all state management needs.
- Use Dio for all HTTP/network requests.
- Integrate Firebase using official packages.
- Write unit and widget tests for critical logic and UI.
- Review code for maintainability and extensibility before merging.

---
This document is for Copilot and all contributors. Please follow these guidelines to ensure code quality and maintainability.
