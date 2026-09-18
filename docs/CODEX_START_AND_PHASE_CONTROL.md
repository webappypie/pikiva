# CODEX_START_AND_PHASE_CONTROL.md
## Master Startup + One-Phase-at-a-Time Development Instructions

Use this file as the primary operating instruction for Codex at the beginning of development.

---

# 1. MASTER START PROMPT — GIVE THIS FIRST

```text
You are starting development of this mobile application from the local project folder that is already open.

IMPORTANT: Do not rush into coding immediately.

First, carefully inspect and understand the entire project context.

STEP 1 — READ EVERYTHING FIRST
- Read every project document in the repository/folder completely before making implementation decisions.
- Pay special attention to:
  - MASTER_PRD.md
  - CODEX_SETUP_CHECKLIST.md
  - this file
  - any architecture, branding, product, UI/UX, API, setup, requirements, notes, or planning documents present in the folder.
- If multiple documents overlap, treat MASTER_PRD.md as the primary product source of truth unless a newer explicit instruction overrides it.
- Build a clear mental model of:
  - what the app is
  - what the app is not
  - the core user journey
  - the technical architecture
  - on-device vs cloud responsibilities
  - privacy and deletion requirements
  - template engine requirements
  - reel/video rendering requirements
  - Firebase responsibilities
  - optional OpenAI/Gemini responsibilities
  - performance expectations
  - release/store safety requirements

STEP 2 — INSPECT THE DEVELOPMENT ENVIRONMENT
Before implementation:
- inspect the current folder structure
- inspect Git status and Git diff
- identify whether a Flutter project already exists
- inspect installed Flutter/Dart versions
- inspect Android SDK/JDK setup where possible
- inspect existing dependencies
- inspect any existing code, assets, configuration, or partial implementation
- do not overwrite or recreate working code unnecessarily
- do not delete existing files unless clearly required

STEP 3 — UNDERSTAND BEFORE CHANGING
Before writing code, provide a concise execution plan for the CURRENT phase only.

For the current phase, identify:
- exact deliverables
- acceptance criteria
- files/modules likely to change
- dependencies required
- risks
- platform-specific considerations
- tests that must be added/run

Do not redesign the product or expand scope on your own.

STEP 4 — DEVELOPMENT MODE
Development must happen ONE PHASE AT A TIME.

STRICT RULE:
- Implement only the phase explicitly requested by the user.
- Never automatically continue to the next phase.
- Never start future-phase work “while you are here.”
- Never prebuild incomplete future features unless a tiny abstraction is essential for the current architecture.
- After the current phase is fully complete and tested, STOP.
- Wait for the user's next phase instruction.

The user will provide a separate prompt for every next phase.

STEP 5 — QUALITY STANDARD
This is intended to be a premium production app, not a prototype.

Every implementation must prioritize:
- clean architecture
- maintainable code
- premium UI/UX
- smooth interactions
- responsive layouts
- Android + iOS compatibility
- performance
- offline-first behavior
- user privacy
- safe photo handling
- accessibility
- proper error/loading/empty states
- testability
- production readiness

Do not use placeholder-quality UI when implementing final screens.

Do not take shortcuts that will create major technical debt later.

STEP 6 — PRODUCT BOUNDARIES
Remember throughout development:

This app is:
- a smart best-photo selection app
- an explainable photo recommendation app
- a safe photo review/cleanup tool
- a profile photo creator
- a cover/banner creator
- a collage creator
- a template-driven short reel creator
- a lightweight photo adjustment tool

This app is NOT:
- a full Photoshop/Lightroom replacement
- a full manual video editor
- an AI image generator
- an AI video generator
- a cloud photo backup product
- a server-heavy media-processing system

Core photo analysis and media creation should be on-device wherever practical.

OpenAI/Gemini are optional helper services for small text-generation tasks only.

Do not upload normal user photos to OpenAI, Gemini, Firebase Storage, or any other cloud service for core analysis.

STEP 7 — SECURITY RULES
Never:
- hardcode API keys
- put production secrets in Flutter source code
- put secrets in Firebase Remote Config
- commit credentials
- request GitHub passwords
- request Apple passwords
- request Google Play passwords
- expose authorization headers in logs
- embed OpenAI/Gemini production credentials in the mobile binary

If a future phase requires credentials, first implement the secure integration structure and clearly state exactly which secret/config is needed and where the user should place it.

STEP 8 — DEPENDENCY RULES
Before adding a dependency:
- verify it is actively maintained
- check Android/iOS support
- check license compatibility
- avoid abandoned packages
- avoid adding large dependencies for trivial functionality
- prefer stable/native/platform-supported solutions where appropriate

For video/FFmpeg/media libraries, inspect:
- binary size
- codec support
- licensing
- App Store compatibility
- Play Store compatibility
before locking the dependency.

STEP 9 — UI/UX RULES
The visual design must feel:
- simple
- modern
- premium
- clean
- photo-first
- polished

Avoid:
- clutter
- excessive gradients
- excessive glassmorphism
- generic stock UI
- unnecessary animations
- overloaded dashboards
- inconsistent spacing/radii/typography

Use a centralized design-token system.

Support:
- light theme
- dark theme
- system theme

All major screens need:
- loading state
- empty state
- error state
- success state where relevant

STEP 10 — PHOTO SAFETY
Never silently delete user photos.

The flow must remain:
Suggestion -> User Review -> Review Bin -> Explicit Delete from Device -> OS-confirmed deletion flow

Review Bin is a pre-deletion staging area.

Do not promise restoration after operating-system deletion unless the platform explicitly supports it and the app can reliably provide it.

STEP 11 — TEMPLATE-FIRST CREATION
Profile, cover, collage, and reel creation should be driven by reusable templates.

Do not hardcode each template as a completely separate feature screen.

Use data-driven/versioned definitions where practical.

Reels must be created from:
- predefined scenes
- transitions
- motion presets
- text animations
- masks
- typography
- licensed/local audio
- beat markers

Do not use AI-generated video for normal reel creation.

STEP 12 — CLOUD AI RULE
Local-first.

Use local presets where possible.

Optional OpenAI/Gemini use is limited to:
- short reel titles
- cover headings
- one-line memory text
- short caption ideas
- other small text suggestions explicitly approved later

Cloud AI must never be required for the core app to work.

STEP 13 — TESTING
At the end of every phase run all relevant checks available to the project, including as applicable:
- formatting
- static analysis
- unit tests
- widget tests
- integration tests
- Android build/smoke check
- iOS compile/smoke check when a Mac environment is available

Never claim something was tested if it was not actually tested.

STEP 14 — GIT DISCIPLINE
Before starting a phase:
- inspect Git status
- understand current modifications

After the phase:
- inspect Git diff
- identify accidental/unrelated changes
- ensure generated/secrets/build artifacts are not committed
- summarize changed files

Do not reset or discard user changes unless explicitly requested.

STEP 15 — PHASE COMPLETION REPORT
When the requested phase is complete, STOP DEVELOPMENT and provide a concise completion report containing:

1. Phase completed
2. What was implemented
3. Important architectural decisions
4. Files/modules created or changed
5. Dependencies added/removed and why
6. Tests/checks actually run
7. Test/build results
8. Known limitations or risks
9. Any manual verification the user should perform
10. Exact recommended next phase

Then STOP.

Do not begin the recommended next phase until the user explicitly instructs you to continue.

CURRENT TASK:

Start with PHASE 0 ONLY from MASTER_PRD.md.

Read all project documents first, inspect the repository and development environment, then implement Phase 0 completely.

Do not start Phase 1.

After Phase 0 passes its relevant checks and is properly documented, provide the Phase Completion Report and STOP.
```

---

# 2. PHASE 0 -> PHASE 1 PROMPT

Give this only after Phase 0 is complete and you have reviewed its report.

```text
Continue development from the exact current repository state.

First:
- reread the relevant project documents and Phase 1 requirements
- inspect Git status and Git diff
- review the Phase 0 implementation
- preserve all completed and working Phase 0 architecture

Implement PHASE 1 ONLY from MASTER_PRD.md.

The goal is the premium UI shell and product feel using mock/local data where needed.

Before coding, identify the exact Phase 1 acceptance criteria.

Then implement Phase 1 fully with production-quality:
- UI structure
- navigation
- design system usage
- light/dark/system themes
- loading states
- empty states
- error states
- responsive behavior
- polished animations/interactions
- accessibility
- tests

Do not start Phase 2.

After implementation:
- run formatting
- run static analysis
- run relevant tests
- run a practical build/smoke check
- review Git diff

Then provide the standard Phase Completion Report and STOP.
```

---

# 3. UNIVERSAL NEXT-PHASE PROMPT

Use this for Phase 2 onward by replacing [PHASE_NUMBER].

```text
Continue development from the exact current repository state.

Implement PHASE [PHASE_NUMBER] ONLY from MASTER_PRD.md.

Before making changes:

1. Read the complete Phase [PHASE_NUMBER] requirements from MASTER_PRD.md.
2. Read any related architecture/setup documents.
3. Inspect current Git status and Git diff.
4. Review the completed implementation from previous phases.
5. Preserve all working functionality and architecture.
6. Do not restart or recreate completed work.
7. Identify the exact acceptance criteria for this phase.
8. Identify required dependencies, platform-specific concerns, tests, performance risks, privacy risks, and migration needs.

Then implement Phase [PHASE_NUMBER] completely to production-quality standards.

STRICT SCOPE:
- Only work on Phase [PHASE_NUMBER].
- Do not begin the next phase.
- Do not add unrelated features.
- Do not perform broad rewrites unless required to correctly complete this phase.
- If an architectural improvement is necessary, keep it minimal and explain it in the completion report.

QUALITY REQUIREMENTS:
- Android + iOS safe behavior
- premium and consistent UI where applicable
- responsive layouts
- smooth performance
- proper loading/error/empty states
- privacy-safe behavior
- no embedded secrets
- no silent media deletion
- offline-first behavior wherever required by the PRD
- maintainable/testable code
- accessibility for critical controls

After implementation:
- format code
- run static analysis
- run relevant unit/widget/integration tests
- run practical build/smoke checks
- inspect Git diff
- verify no accidental secrets/build artifacts/unrelated changes were introduced

Then provide the standard Phase Completion Report:

1. Phase completed
2. Features implemented
3. Architecture/technical decisions
4. Files/modules changed
5. Dependencies changed
6. Checks/tests executed
7. Results
8. Known limitations/risks
9. Manual verification needed
10. Recommended next phase

STOP after this report.

Do not start the next phase until I explicitly tell you to continue.
```

---

# 4. SHORT VERSION FOR EVERY NEXT PHASE

If the project is already stable and Codex understands the rules, use this shorter version:

```text
Continue from the exact current repository state and implement PHASE [X] ONLY from MASTER_PRD.md.

First reread the relevant requirements, inspect Git status/diff, and review the completed previous phase. Preserve all working functionality and do not recreate completed work.

Implement the phase completely at production quality, including required loading/error/empty states, Android/iOS behavior, privacy/security, performance, accessibility, and tests.

After implementation, run format, static analysis, relevant tests, and practical build/smoke checks. Review Git diff and provide the standard Phase Completion Report.

STOP after Phase [X]. Do not start the next phase until I explicitly request it.
```

---

# 5. IF CODEX STOPS MID-PHASE BECAUSE OF LIMITS / INTERRUPTION

```text
Resume PHASE [X] from exactly where development stopped.

First inspect the current repository, Git status/diff, existing code, tests, and the previous work completed for this phase.

Determine:
- what is already complete
- what is partially complete
- what is still missing from the Phase [X] acceptance criteria

Do not restart the phase.
Do not recreate completed work.
Do not undo working implementation.

Continue only the remaining Phase [X] work, finish it completely, run the required checks/tests, provide the standard Phase Completion Report, and STOP.

Do not start the next phase.
```

---

# 6. IF CODEX INTRODUCES BUGS / REGRESSIONS

```text
Do not continue feature development yet.

Audit the current implementation for regressions introduced in the latest phase.

Compare:
- current Git diff
- previous working behavior
- Phase [X] requirements
- relevant tests

Fix only the regressions and incomplete requirements related to Phase [X].

Do not redesign unrelated modules.
Do not start the next phase.

After fixes:
- format
- analyze
- run relevant tests
- run a build/smoke check
- review Git diff

Then provide an updated Phase Completion Report and STOP.
```

---

# 7. FINAL RELEASE-HARDENING PROMPT

Use only when all planned product phases are complete.

```text
All planned implementation phases are complete.

Now perform the RELEASE HARDENING phase only.

Do not add new product features.

Audit the complete app for:
- Android/iOS build reliability
- release-mode behavior
- permissions
- photo-library access
- deletion safety
- privacy
- analytics payloads
- Firebase configuration
- App Check
- API secret exposure
- embedded credentials
- debug/dev flags
- premium/debug bypasses
- logs
- crash handling
- performance
- memory
- thumbnail caching
- local storage cleanup
- video rendering failures
- low-storage handling
- offline behavior
- accessibility
- responsive UI
- dark/light themes
- dependencies
- licenses
- deprecated APIs
- package size
- store compliance
- production error states
- app metadata/configuration

Run every practical automated test/build available.

Create a release-readiness report containing:
1. passed checks
2. fixed issues
3. unresolved blockers
4. manual Android checks
5. manual iOS checks
6. Play Store requirements still needed
7. App Store requirements still needed
8. secrets/configuration the owner still needs to add
9. final release build commands

Do not submit or publish anything unless explicitly requested.

STOP after the release-readiness report.
```

---

# 8. NON-NEGOTIABLE RULES FOR THE ENTIRE PROJECT

Codex must always remember:

- one phase at a time
- never self-start the next phase
- preserve working code
- inspect Git before changing
- test before declaring completion
- do not guess that a test passed
- do not embed secrets
- do not upload user photos to AI services for core features
- do not silently delete user media
- do not turn the product into a full editor
- do not turn predefined reels into AI-generated video
- keep the app useful offline
- prioritize premium quality over feature quantity
- prefer 12 excellent templates over 100 weak templates
- always treat user media as private
- keep core analysis on-device
- cloud AI remains optional
- Firebase is a support/control layer, not a photo backend
- document meaningful architectural changes
- stop after the requested phase is complete

---

# 9. OWNER WORKFLOW

Recommended workflow:

1. Put all product docs in the project folder/repository.
2. Open that local folder in VS Code/Codex.
3. Give Codex the MASTER START PROMPT.
4. Let Codex finish Phase 0.
5. Review Phase 0 report and repository state.
6. Give the Phase 1 prompt.
7. Review again.
8. Continue one phase at a time using the Universal Next-Phase Prompt.
9. If execution gets interrupted, use the Resume prompt.
10. If a regression appears, use the Regression prompt.
11. Only after all planned development phases are complete, use Release Hardening.

This workflow intentionally prevents Codex from racing through the whole application and helps maintain a higher, reviewable production-quality standard.
