# [APP_NAME] — Codex Development Setup & Access Checklist

**Purpose:** Everything the owner should prepare before or during development.  
**Rule:** Never paste production secrets into source files, PRD text, Codex prompts, screenshots, or Git commits.

---

## 1. What Codex needs on Day 1

### Required immediately
- A local project folder or a new empty Git repository.
- GitHub repository URL (prefer private during development).
- Confirm target platforms: Android + iOS.
- Flutter stable SDK installed.
- Android Studio + Android SDK + JDK installed.
- VS Code with the OpenAI Codex IDE extension, or Codex CLI.
- A physical Android test device.
- Product PRD (`MASTER_PRD.md`) at the repository root.
- A short placeholder app name/package ID if final branding is not decided.

### Recommended IDs
Use placeholders until branding is final:
- Android package: `com.yourcompany.appname`
- iOS bundle ID: `com.yourcompany.appname`

Do not change IDs repeatedly after Firebase / store setup.

---

## 2. GitHub access

Codex does **not** need your GitHub password or a token pasted into chat.

Preferred:
1. Create/private GitHub repo.
2. Authenticate locally using GitHub CLI (`gh auth login`) or SSH.
3. Clone/open the repo locally.
4. Let Codex work inside the already-authenticated local repo.

For GitHub Actions, put secrets only in **GitHub Actions Secrets/Variables**.

Recommended branch protection later:
- `main` protected
- development work on feature branches
- PR checks before merge
- automated Flutter analyze/test/build checks

---

## 3. Firebase project

### Create one Firebase project for development first
Provide:
- Firebase project ID
- Android app registration
- iOS app registration
- `google-services.json` (Android)
- `GoogleService-Info.plist` (iOS)

### Enable
- Firebase Analytics
- Firebase Crashlytics
- Firebase Remote Config
- Firebase App Check
- Firebase Cloud Functions (only for secure AI text proxy / tiny backend logic)
- Firebase Performance Monitoring (optional but recommended)
- Firebase Cloud Messaging (optional for future template-pack notifications)

### Do NOT use Remote Config for
- OpenAI keys
- Gemini keys
- service-account credentials
- private signing secrets
- any confidential information

Remote Config is for feature flags and non-secret runtime settings only.

### Firestore
Do **not** add Firestore in v1 unless a real requirement appears.
Bundled template manifests + Remote Config are enough for the first release.

---

## 4. Firebase authentication for development/CI

### Local machine
Use:
`firebase login`

### CI
Prefer Application Default Credentials / workload identity style authentication when available.

Do not build a workflow around legacy `FIREBASE_TOKEN` unless absolutely necessary.

---

## 5. OpenAI

OpenAI is optional for initial development.

Use it only for small text-generation features such as:
- reel title
- cover heading
- short memory line
- vibe-based caption
- optional 3–5 text suggestions

### You will eventually provide
- an OpenAI Project
- a project-scoped API key
- a strict monthly budget/spend limit

### Security
- Never embed `OPENAI_API_KEY` in Flutter.
- Never place it in `assets/`.
- Never put it in Remote Config.
- Never commit it.
- Production mobile requests must go through a protected backend function/proxy.
- Store the secret in the backend secret store/environment only.

---

## 6. Gemini

Gemini is also optional for the first build.

Use it as:
- primary or fallback text model
- A/B comparison against OpenAI
- optional low-cost title/caption generation

### September 2026 requirement
Use a current Gemini **authorization/auth key** associated with the proper Google Cloud project/service-account flow. Do not build production around an old unrestricted standard key.

### Security
Same rule as OpenAI:
- never ship Gemini credentials inside the app
- call Gemini from a secured function/proxy
- apply quotas and per-device/per-user limits

---

## 7. AI routing recommendation

Do not call both providers for every request.

Use:
- Provider A = default
- Provider B = fallback / experiment
- Remote Config chooses provider
- backend has hard usage limits
- local preset text is always the offline fallback

Suggested Remote Config flags:
- `cloud_text_enabled`
- `cloud_text_provider`
- `cloud_text_daily_limit_free`
- `cloud_text_daily_limit_pro`
- `cloud_text_timeout_ms`
- `cloud_text_fallback_to_local`

---

## 8. Canva integration — optional but useful for development

Canva should **not** be a runtime dependency of the mobile app.

Use Canva only during design/asset production:
- premium cover layouts
- typography inspiration
- frame concepts
- background texture assets
- promotional/store creatives
- template reference exports

Codex supports MCP servers, and Canva exposes a remote MCP service.

Recommended development integration:
- add Canva as an MCP server in Codex IDE/CLI
- authenticate via OAuth
- let Codex/you create or modify design references
- export the final legally usable assets
- commit only exported app assets/template definitions that the app needs

Canva runtime access is not required for end users.

Important:
- do not assume every Canva template/font/stock element can be redistributed inside an app
- only bundle assets/fonts/music whose licensing permits app redistribution

---

## 9. Design assets you should eventually provide

Not required on Day 1:
- final app name
- logo
- launcher icon
- brand colors
- preferred font family
- 3–5 reference apps/screens you like
- optional existing Canva brand kit
- support email
- privacy-policy URL
- terms URL
- company/developer name

Codex can begin with a neutral design token system and replace branding later.

---

## 10. Video / reel assets

You do NOT need an AI video-generation API.

Prepare or allow Codex to create:
- reel template JSON files
- vector overlays
- masks
- transition definitions
- animated text presets
- local motion presets
- intro/outro frames
- licensed music/SFX library

You must provide or license:
- music tracks that may legally be redistributed
- commercial fonts if non-open-source fonts are used
- any stock texture/video element that will ship in the app

Best choice for v1:
- open-source fonts
- self-created vector/gradient assets
- royalty-free or custom music with app redistribution rights

---

## 11. Image-analysis engine inputs

No external AI key is required for the core photo-ranking engine.

Initial on-device stack should use:
- native image metadata
- perceptual hashing
- similarity embeddings/on-device model
- blur/sharpness metrics
- exposure/contrast metrics
- face detection
- eye-open/smile/expression signals where supported
- composition heuristics
- diversity scoring

The engine must return structured reason codes such as:
- `SHARPER_FACE`
- `EYES_OPEN`
- `BETTER_EXPOSURE`
- `LOW_MOTION_BLUR`
- `BETTER_COMPOSITION`
- `DUPLICATE_OF_BETTER_FRAME`
- `BETTER_GROUP_EXPRESSION`

UI text is generated locally from these codes. An LLM is **not** required to explain why a photo is better.

---

## 12. Local development tools

Recommended:
- Flutter stable
- Dart SDK bundled with Flutter
- Android Studio
- Xcode (for iOS builds; Mac required)
- CocoaPods / Swift Package Manager as required
- Git
- GitHub CLI
- Node.js (for Firebase CLI and some MCP tooling)
- Firebase CLI
- Codex IDE extension and/or Codex CLI
- FFmpeg-based local rendering library or native media composition layer selected after license/build-size review
- ImageMagick optional for developer-side asset generation only

---

## 13. Test devices

Minimum:
- 1 mid-range Android device
- 1 recent Android device
- 1 iPhone
- optional older supported iPhone

Test specifically:
- limited photo access
- large HEIC/JPEG files
- portrait/landscape
- Live Photos behavior
- burst-like sequences
- low-light images
- 100+ photo selection
- deletion confirmation
- low storage
- low battery / thermal state
- interrupted video rendering

---

## 14. Store accounts — later, not Day 1

Eventually:
- Google Play Console developer account
- Apple Developer account
- app signing configuration
- privacy policy
- terms
- support contact
- store screenshots
- promo video
- data-safety/privacy answers
- in-app purchase products if monetization is enabled

---

## 15. What you should give Codex first

Give Codex:
1. `MASTER_PRD.md`
2. this file
3. repo access through the already-authenticated local environment
4. package/bundle ID decision
5. permission to scaffold the Flutter project
6. instruction to build **Phase 0 and Phase 1 only first**

Do NOT initially give Codex:
- production OpenAI key
- production Gemini key
- Play Console credentials
- Apple password
- Firebase service-account private key in chat
- signing keystore password in chat

Integrate secrets only when that phase is reached.

---

## 16. Recommended build sequence

1. Repository + Flutter project + architecture
2. Design system + navigation + mock data
3. System photo picker + selected-session flow
4. Local database/session persistence
5. Similar-photo grouping
6. quality scoring + explainable ranking
7. compare screen + Best Set
8. Review Bin + OS-safe deletion
9. minimal image adjustment
10. profile-picture composer
11. cover composer
12. collage engine
13. reel template engine
14. local video renderer
15. Firebase Remote Config/Crashlytics/App Check
16. secured cloud text proxy
17. Gemini/OpenAI optional text generation
18. premium/ads only if desired
19. performance/security/accessibility pass
20. store release hardening

Do not attempt all twenty steps in one Codex task.

---

## 17. Owner decisions still required

Before store release, decide:
- final app name
- final package/bundle ID
- minimum Android/iOS versions
- free vs lifetime/premium strategy
- whether ads will exist
- how many bundled reel/cover/collage packs launch in v1
- retention policy for local session data
- whether location EXIF is ever used (recommended: not by default)
- whether cloud text is enabled by default (recommended: local preset first; cloud optional)

