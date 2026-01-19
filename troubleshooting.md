# Troubleshooting Flutter Build Issues

This document outlines the steps taken to resolve a Flutter build issue where the application failed to run due to file access errors.

## Problem

When running `flutter run`, the build would fail with the following error:

```
Flutter failed to delete a directory at "build\flutter_assets". The flutter tool cannot access the file or directory.
Please ensure that the SDK and/or project is installed in a location that has read/write permissions for the current user.
```

Subsequent attempts to clean the project with `flutter clean` also failed with similar permission errors, indicating that a process was holding a lock on the files.

## Solution

The following steps were taken to resolve the issue:

1.  **Terminated Dart Processes:** Identified and forcefully terminated all running `dart.exe` processes using `taskkill`:
    ```powershell
    taskkill /F /IM dart.exe /T
    ```

2.  **Manually Deleted Build Directories:**  The `build`, `.dart_tool`, and `ephemeral` directories were forcefully deleted using PowerShell's `Remove-Item` command:
    ```powershell
    Remove-Item -Recurse -Force build
    Remove-Item -Recurse -Force .dart_tool
    Remove-Item -Recurse -Force ios/Flutter/ephemeral
    Remove-Item -Recurse -Force macos/Flutter/ephemeral
    ```

3.  **Ran the Application:** After clearing the locked directories, the application was successfully launched using:
    ```
    flutter run -d chrome
    ```
