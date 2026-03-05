# Build Settings Cleanup Plan

To avoid simulator-time failures due to x86_64-only frameworks bundled with the template, we:

- Avoid importing and referencing `PlaygroundSupport` and `LiveViewHost` on arm64 simulators using:
  - `#if canImport(FRAMEWORK) && !(arch(arm64) && targetEnvironment(simulator))`
  - Provide shims for the necessary types when unavailable.

- Optional Xcode target settings (recommended):
  - For simulator SDKs, remove `PlaygroundSupport.framework` and `LiveViewHost.framework` from "Link Binary With Libraries" for targets: BookCore, BookAPI, UserModule, and LiveViewTestApp.
  - Ensure `FRAMEWORK_SEARCH_PATHS` or `SYSTEM_FRAMEWORK_SEARCH_PATHS` do not include the Playgrounds framework directories for arm64 simulator builds. The code no longer requires them on simulator, thanks to the shims.
  - Keep them linked for device builds if you want to test with the real frameworks.

- Rationale:
  - The bundled frameworks in SupportingContent are x86_64-only for Simulator. Importing or linking them on Apple Silicon simulators causes build/link errors. Conditional imports and shims avoid this, and removing the linkage cleans up warnings and potential conflicts.

- Notes:
  - The PlaygroundBook packaging still works for device builds. Simulator builds use shims to host the live view via LiveViewTestApp.
