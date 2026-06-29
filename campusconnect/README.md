# CampusConnect

CampusConnect is a Flutter application scaffolded for Group 5, campus code CAM-PHX-05, with configuration validation and a Milestone 2 authentication flow.

## Structure

- lib/core/config: configuration validation and startup settings.
- lib/core/services: authentication and shared services.
- lib/core/theme: theme palette and provider.
- lib/features/auth: login, signup, reset-password, and auth guard screens.
- lib/features/error: fatal config error UX.
- lib/features/splash: startup splash experience.

## Verification

Run the following commands from the project root:

- flutter pub get
- flutter test
- flutter build web

## Notes

- The app enforces dark mode automatically between 8 PM and 6 AM.
- Startup validates the campus code and API version before the app can proceed.
- Firebase initialization is wired through the auth provider for Milestone 2.
