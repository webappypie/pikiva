# [APP_NAME] — MASTER PRODUCT REQUIREMENTS DOCUMENT
## Smart Photo Selection & Creative Memory App
**Document type:** Codex-executable product blueprint  
**Target:** Flutter, Android + iOS  
**Product principle:** Template-first, on-device-first, AI-second, privacy-first  
**Version:** 1.0 — September 2026

---

# 0. MASTER BUILD DIRECTIVE FOR CODEX

Read this entire document before editing code.

The product is **not** a full photo editor and **not** a generative image/video app.

The product helps a user:
1. select many photos from one event/session,
2. identify similar shots,
3. rank the strongest shots,
4. explain why one shot is better,
5. let the user review weak/redundant shots safely,
6. create polished social-ready outputs from the chosen photos:
   - profile picture
   - cover/banner
   - collage
   - short reel/video
7. apply only lightweight image adjustments.

Core ranking and creation must work **without a server**.

Do not upload user photos to OpenAI, Gemini, Firebase, or any external AI service for normal analysis.

Cloud AI is optional and only for small text suggestions.

Never delete photos silently.

Never hardcode API keys.

Never make Canva a runtime dependency.

Implement one development phase at a time, test it, commit it, and do not rewrite working modules unnecessarily.

---

# 1. PRODUCT VISION

## 1.1 Problem

Users often take 20–300 photos at:
- travel spots
- college events
- birthdays
- weddings
- parties
- outings
- family events
- casual photo shoots

Afterwards:
- many images look almost identical,
- users cannot easily decide which photo is best,
- weak/blurry shots remain mixed with strong shots,
- cleanup takes time,
- making a profile photo, cover, collage, and reel requires separate apps.

## 1.2 Solution

Create a simple premium mobile experience:

**Many photos in → best photos identified → clear reasons → safe cleanup → ready-to-share creations out**

## 1.3 Positioning

This is an **intelligent photo curator and memory creator**.

It is not:
- Lightroom
- Photoshop
- CapCut
- Canva
- a cloud AI image generator
- a generic duplicate cleaner

## 1.4 Product promise

**Choose the photos worth keeping and turn them into something worth sharing.**

---

# 2. PRODUCT PRINCIPLES

1. **Photo is the hero.** UI must not compete with the image.
2. **On-device first.** Core photo analysis must work offline.
3. **Template first.** Covers, collages, reels, typography, transitions and motion should be predefined deterministic systems.
4. **AI second.** Use LLMs only when they add real value.
5. **Explain recommendations.** Never show a mysterious score without a reason.
6. **User controls deletion.**
7. **Fast perceived performance.** Progressive results are better than a long blocking loader.
8. **No feature bloat.** Minimal editing only.
9. **Premium visual quality.** Fewer excellent templates are better than hundreds of weak templates.
10. **Provider independence.** OpenAI/Gemini must be swappable.
11. **No secret in client.**
12. **Accessible and store-safe.**

---

# 3. PRIMARY USERS

## 3.1 Everyday social user
Takes many photos and wants the best few for Instagram/WhatsApp/social use.

## 3.2 Traveler
Returns from a spot with many similar shots and wants a strong compact set plus a reel.

## 3.3 College/student user
Wants best photos, group shots, stylish collage, cover and short reel.

## 3.4 Family/event user
Wants group-photo comparison, eyes-open detection, safe cleanup and memory creation.

## 3.5 Casual creator
Does not want a complex editing app but wants premium-looking output quickly.

---

# 4. NON-GOALS

Do not turn v1 into:
- RAW editor
- Photoshop clone
- manual timeline video editor
- generative face/body editor
- background-generation studio
- beauty retouching suite
- cloud photo backup
- social network
- stock media marketplace
- online collaborative editor

If a requested feature pushes the product into one of these categories, keep it out of v1 unless explicitly approved.

---

# 5. CORE USER JOURNEY

## 5.1 First launch
1. Splash
2. Short value proposition
3. Privacy statement:
   - photos stay on device for normal analysis
   - nothing is deleted automatically
4. Continue
5. Home

Do not request full photo-library access immediately if unnecessary.

## 5.2 Start a session
1. User taps **Choose Photos**
2. Open system photo picker
3. User selects photos
4. App creates a local session
5. Show analysis screen with progressive stages
6. Start processing thumbnails immediately

## 5.3 Analysis
Progress messages:
- Grouping similar shots
- Checking clarity
- Comparing faces
- Finding strongest moments
- Building your Best Set

Never fake progress.

## 5.4 Results
Main result categories:
- **Best Picks**
- **Best Set**
- **Good**
- **Review**
- **Suggested Remove**

## 5.5 Decision
User can:
- keep
- unselect
- compare
- mark favorite
- move to Review Bin
- restore from Review Bin

## 5.6 Creation
From approved photos:
- Profile
- Cover
- Collage
- Reel

---

# 6. INFORMATION ARCHITECTURE

Bottom navigation:
- **Home**
- **Creations**
- **Sessions**
- **Settings**

Keep navigation at four items.

## Home
- Primary CTA: Choose Photos
- Continue latest session
- Recent creations
- 2–3 contextual quick-create cards
- no noisy analytics dashboard

## Creations
Tabs:
- Profile
- Cover
- Collage
- Reels

## Sessions
- event/session cards
- date
- selected photo count
- best-pick count
- status
- resume analysis

## Settings
- privacy
- processing
- video export quality
- cloud text toggle
- theme
- storage/cache
- app lock if later required
- help/legal
- restore purchases if monetized

---

# 7. DESIGN SYSTEM

## 7.1 Visual direction
- extremely clean
- modern
- premium
- content-led
- large imagery
- restrained chrome
- high-quality motion
- no excessive gradients
- no glassmorphism everywhere
- no decorative clutter

## 7.2 Theme
Support:
- light
- dark
- system

## 7.3 Design tokens
Create central token files for:
- spacing
- radii
- typography
- colors
- elevation
- motion duration
- easing curves
- icon sizes

Do not hardcode repeated visual values inside screens.

## 7.4 Cards
- consistent radius
- clear hierarchy
- minimal shadow/elevation
- image-first layout

## 7.5 Motion
Motion should communicate:
- analysis
- selection
- comparison
- creation
- completion

Avoid looping decorative animation that drains battery.

## 7.6 Accessibility
- semantic labels
- dynamic text where practical
- minimum touch targets
- sufficient contrast
- do not communicate Keep/Remove state by color alone

---

# 8. PHOTO IMPORT & PERMISSIONS

## 8.1 Preferred behavior
Use system-provided photo selection wherever possible.

The main use case is user-selected sessions, so broad background gallery scanning is not required for v1.

## 8.2 Android
Prefer the platform photo picker for normal selection.

For deletion of selected external media:
- use the OS-supported user-confirmed deletion flow
- never attempt hidden/silent deletion
- batch requests where platform behavior allows

## 8.3 iOS
Support:
- standard PhotoKit authorization states
- limited library access
- updating limited selection
- user-confirmed/OS-governed library mutations

## 8.4 Permission UX
Explain *why* access is needed before system prompt.

Never block the whole app because full library access was not granted if selected-photo access is enough.

---

# 9. SESSION MODEL

Each import creates a `PhotoSession`.

Suggested model:

```text
PhotoSession
- id
- title
- createdAt
- updatedAt
- sourceType
- status
- assetCount
- analyzedCount
- bestCount
- reviewCount
- suggestedRemoveCount
- selectedCreationAssets[]
- coverAssetId?
- localOnly = true
```

Photo asset record:

```text
SessionAsset
- id
- platformAssetIdentifier
- sessionId
- width
- height
- orientation
- createdAt
- mimeType
- duration? (future video support)
- perceptualHash?
- embeddingRef?
- qualityMetrics
- faceMetrics
- clusterId?
- rankingScore?
- rankWithinCluster?
- decision
- reasonCodes[]
- isFavorite
- isInReviewBin
```

Do not store raw face images or face embeddings in analytics/cloud.

---

# 10. ANALYSIS PIPELINE

The ranking engine is the most important product module.

Implement as separate testable stages.

## Stage A — metadata
Extract:
- dimensions
- orientation
- creation time if available
- file type
- basic exposure metadata if safely available

Do not require EXIF location.

## Stage B — efficient thumbnail generation
Use an analysis-sized thumbnail first.

Never decode every full-resolution image simultaneously.

Cache thumbnails with an LRU/size-limited strategy.

## Stage C — exact/near duplicate detection
Use:
- file identity where available
- perceptual hash
- low-cost visual comparison

## Stage D — similarity clustering
Goal:
group near-identical frames / same pose / same moment.

Possible signals:
- perceptual hash distance
- on-device image embedding distance
- timestamp proximity
- face-layout similarity
- dominant composition similarity

Clustering must be deterministic enough to debug.

## Stage E — technical quality
Generate normalized metrics:
- sharpness
- motion blur likelihood
- brightness/exposure balance
- clipped highlight/shadow tendency
- noise estimate
- contrast
- resolution adequacy

## Stage F — face quality
Where a face is present, evaluate available on-device signals:
- face detection confidence
- face size
- face sharpness
- eye-open indicators
- smile/expression indicators
- occlusion
- head pose
- number of valid faces
- group consistency

Never infer sensitive attributes.

## Stage G — composition
Use lightweight heuristics:
- subject framing
- face cut-off
- horizon/tilt where detectable
- edge crowding
- excessive empty space
- distracting severe crop
- rule-of-thirds proximity as a soft signal only

Composition must not overpower a strong human moment.

## Stage H — contextual scoring
Do not use one universal formula.

Determine approximate photo type:
- single portrait
- group portrait
- landscape/scenery
- general scene
- close-up/detail

Then select the appropriate weighted scoring profile.

Example conceptual portrait weighting:
- face sharpness: high
- eye/expression quality: high
- exposure: medium
- composition: medium
- technical noise: low/medium
- uniqueness: medium

Do not expose raw weighting as scientific truth.

## Stage I — cluster winner
Within each similar cluster:
- best
- alternate
- review
- suggested remove

## Stage J — Best Set diversity
Best Set is **not simply the top N global scores**.

It must optimize:
- quality
- diversity
- different moments
- different composition
- different subject scale
- different people combinations where relevant

Avoid 10 nearly identical hero portraits.

## Stage K — explanation
Generate reason codes locally.

Example positive:
- SHARPER_SUBJECT
- BETTER_FACE_FOCUS
- EYES_OPEN
- NATURAL_EXPRESSION
- BETTER_GROUP_EXPRESSION
- BALANCED_EXPOSURE
- CLEANER_COMPOSITION
- MORE_UNIQUE_MOMENT

Example negative:
- MOTION_BLUR
- SUBJECT_SOFT
- EYES_CLOSED
- OVEREXPOSED
- UNDEREXPOSED
- DUPLICATE_OF_STRONGER_FRAME
- AWKWARD_CROP
- LOWER_GROUP_SUCCESS

Translate reason codes to short friendly copy.

No LLM call is required.

---

# 11. RESULT LABELS

Use:
- **Best**
- **Great**
- **Review**
- **Suggested Remove**

Avoid insulting labels such as:
- Bad
- Ugly
- Failed
- Worst

Recommendation is assistance, not absolute truth.

---

# 12. COMPARE EXPERIENCE

This screen is critical.

Features:
- 2–4 similar images side-by-side
- synchronized pan/zoom where feasible
- tap face to zoom
- winner badge
- reason chips
- sharpness indicator
- face state summary
- user can override choice
- swipe next cluster

If group photos:
- allow quick face-by-face inspection

---

# 13. BEST SET

## Goal
Give a ready-to-use set, not merely the technically highest scores.

Default options:
- Best 5
- Best 10
- Best 20
- Custom

Best Set should favor:
- one strong hero photo
- alternate expression
- environmental/wide shot
- candid
- group shot
- detail/interesting composition

Only use categories that exist in the selected session.

---

# 14. REVIEW BIN / SAFE CLEANUP

## 14.1 Default behavior
`Review Bin` is a **pre-deletion staging area**.

Moving an item to Review Bin:
- does not immediately remove the original file from the device
- marks the asset locally
- removes it from normal app views
- remains reversible

## 14.2 Final delete
When user taps **Delete from Device**:
1. show count and estimated storage
2. require clear confirmation
3. invoke platform deletion flow
4. respect OS confirmation
5. refresh asset state
6. show successful/failed count

## 14.3 Why not promise an app-level post-delete recycle bin?
Copying every original into app-private storage before deleting would:
- temporarily duplicate storage use
- complicate iCloud/media behavior
- create privacy/storage risks

Therefore v1 uses:
- app Review Bin before deletion
- operating-system trash/recently-deleted behavior after final deletion

Do not imply the app can always restore an OS-deleted file itself.

---

# 15. MINIMAL IMAGE EDITOR

The app is not a pro editor.

Allowed v1 adjustments:
- auto enhance
- exposure
- brightness
- contrast
- highlights
- shadows
- warmth
- saturation
- crop
- rotate
- straighten
- light sharpen
- vignette
- optional background blur for portrait if implemented locally and reliably

Rules:
- non-destructive preview
- reset
- before/after
- preserve original
- save as new creation where platform behavior requires

Do not add:
- curves
- masks
- layers
- RAW workflow
- healing brush
- clone tool
- pro color grading timeline

---

# 16. PROFILE PICTURE CREATOR

## 16.1 Input
User-selected or AI-recommended portrait.

## 16.2 Output presets
Use platform-agnostic ratio presets first:
- square
- circle-safe square
- 4:5 portrait
- 9:16 portrait-card

Platform-specific named presets can be updated later through non-secret configuration.

## 16.3 Features
- smart subject crop
- face-safe margins
- background blur option
- subtle background tint/gradient
- circular preview
- frame presets
- minimal text optional
- high-resolution export

## 16.4 Template packs
Launch with ~12 excellent presets:
- Minimal
- Clean Border
- Soft Gradient
- Editorial
- Bold Type
- Monochrome
- College
- Travel
- Celebration
- Professional
- Creator
- Dark Premium

No generative portrait replacement.

---

# 17. COVER / BANNER CREATOR

## 17.1 Purpose
Turn one or multiple best photos into a wide social/profile cover.

## 17.2 Template system
Each template specifies:
- canvas ratio
- safe zones
- 1–5 photo slots
- masks
- crop behavior
- gradient overlays
- title region
- subtitle region
- decorative vector elements
- typography preset

## 17.3 Text
User can:
- type manually
- pick local preset
- optionally request cloud-generated suggestions

## 17.4 Styles
Launch target:
- Minimal Editorial
- Bold Magazine
- College Memory
- Travel Journal
- Celebration
- Elegant Dark
- Soft Gradient
- Split Portrait
- Multi-frame Story
- Photo Strip
- Hero Quote
- Clean Professional

Templates are deterministic JSON/data + local assets.

---

# 18. COLLAGE ENGINE

## 18.1 Goals
Fast, beautiful, minimal controls.

## 18.2 Layout types
- 2-photo split
- 3-photo editorial
- 4-photo grid
- asymmetric magazine
- film strip
- polaroid-style
- scrapbook-lite
- full-bleed mosaic
- memory card
- story collage

## 18.3 Smart fill
When user selects Best Set:
- avoid repeated near-identical frames
- vary crop/scale
- preserve faces
- avoid placing critical faces under text

## 18.4 Controls
- spacing
- corner radius
- background
- reorder
- replace photo
- text on/off
- preset switch

Keep manual controls intentionally simple.

---

# 19. REEL / SHORT VIDEO ENGINE

This is the second major product differentiator after selection.

## 19.1 Principle
Reels are **template-driven**, not AI-generated video.

## 19.2 Target formats
Primary:
- 9:16 vertical
Optional later:
- 1:1
- 16:9

## 19.3 Durations
- 10 sec
- 15 sec
- 20 sec
- 30 sec

## 19.4 Template categories
Launch target 12–20 premium templates:
- Minimal
- Travel
- College
- Memories
- Fun
- Celebration
- Birthday
- Cinematic
- Editorial
- Fast Cuts
- Soft Emotional
- Polaroid
- Film Roll
- Luxury
- Friends
- Before/After-style sequence without deceptive edits

## 19.5 Template definition
Every reel must be data-driven.

Conceptual schema:

```json
{
  "id": "travel_01",
  "version": 1,
  "ratio": "9:16",
  "durationMs": 15000,
  "minPhotos": 6,
  "maxPhotos": 14,
  "theme": "travel",
  "scenes": [],
  "audioProfile": {},
  "textSlots": [],
  "exportProfile": {}
}
```

Each scene supports:
- start/end
- photo slot
- crop mode
- start transform
- end transform
- opacity
- blur
- mask
- overlay
- transition in/out
- text timing
- texture
- optional video slot later

## 19.6 Motion presets
Create reusable primitives:
- slow push in
- slow pull out
- horizontal pan
- vertical reveal
- parallax-lite
- film slide
- split reveal
- mask wipe
- photo stack
- snap zoom
- cross dissolve
- blur dissolve
- scale cut
- light flash (restrained)
- paper reveal

Avoid excessive gimmicks.

## 19.7 Text animation presets
- fade-up
- tracking reveal
- word stagger
- slide mask
- subtle scale
- line reveal
- editorial wipe
- type-on (limited)

## 19.8 Photo sequencing
Auto-sequence should prefer:
1. opener / environmental shot
2. subject introduction
3. strong portrait
4. varied moments
5. group/candid
6. closing hero shot

Do not order only by score.

## 19.9 Beat sync
For bundled music, precompute:
- beat timestamps
- intro section
- accent hits
- outro point

Templates map transitions to beat markers.

No cloud is needed.

## 19.10 Audio
Use only properly licensed redistributable audio.

Allow:
- bundled tracks
- mute
- volume
- optional user-selected local track later

Do not bundle copyrighted commercial music without redistribution rights.

## 19.11 Rendering
Prefer local rendering.

Before locking a Flutter FFmpeg package:
- verify active maintenance
- Android/iOS compatibility
- native binary size
- codec licenses
- App Store/Play Store implications
- GPL implications if applicable

Abstract renderer behind an interface so the implementation can change later.

```text
VideoRenderer
- render(template, assets, text, audio, exportProfile)
- cancel(jobId)
- progress(jobId)
```

## 19.12 Export profiles
- 720p fast
- 1080p standard
- 1080p high
- 4K only later if performance proves safe

Default: 1080p standard.

## 19.13 Failure handling
- render resumes or safely restarts
- user can cancel
- low-storage check
- thermal/low-memory failure message
- temporary files cleaned after completion/cancel

---

# 20. TEMPLATE ENGINE ARCHITECTURE

Use one common template system where practical.

Folders:

```text
assets/
  templates/
    profile/
    cover/
    collage/
    reels/
  overlays/
  masks/
  textures/
  fonts/
  audio/
```

Each template has:
- immutable ID
- version
- minimum app version
- metadata
- thumbnail
- JSON definition
- optional local assets

## Remote availability
Firebase Remote Config may control:
- pack enabled
- pack featured
- minimum version
- experimental flags

Do not attempt to download arbitrary executable template logic.

Template engine must fail safely if an unknown field appears.

---

# 21. LOCAL TEXT PRESET ENGINE

The app must remain useful without cloud AI.

Create local text packs by vibe.

Examples:

## Travel
- “A day worth keeping”
- “Somewhere worth remembering”
- “Found a little magic here”

## College
- “The days we’ll talk about forever”
- “One chapter, countless memories”
- “Same people. New stories.”

## Friends
- “Good people, good chaos”
- “The kind of day we keep”
- “Us, as usual”

## Minimal
- date
- location entered by user
- session title
- initials

All local copy should be editable by the user.

---

# 22. OPTIONAL CLOUD TEXT ASSISTANT

## 22.1 Uses
Only:
- reel title
- cover heading
- subtitle
- 1-line memory text
- short caption

## 22.2 Input
Send text metadata only.

Example:
```json
{
  "type": "reel_title",
  "event": "college farewell",
  "vibe": "nostalgic",
  "length": "short",
  "language": "English"
}
```

Do not send:
- photos
- face crops
- private EXIF
- contact names
- raw filenames

## 22.3 Output
Structured JSON only:
```json
{
  "suggestions": [
    "...",
    "...",
    "..."
  ]
}
```

## 22.4 Provider abstraction
```text
TextSuggestionProvider
- LocalPresetProvider
- OpenAIProvider
- GeminiProvider
```

Cloud calls are routed through secured backend.

## 22.5 Cost control
- local first
- user explicitly taps “Generate more”
- hard daily quota
- per-request timeout
- max token/output length
- cached suggestions per session/vibe
- provider switch via backend/Remote Config
- graceful fallback

---

# 23. FIREBASE ARCHITECTURE

Use Firebase as a **control/support layer**, not as a photo backend.

## 23.1 Required
- Analytics
- Crashlytics
- Remote Config
- App Check

## 23.2 Optional
- Cloud Functions: secure text proxy only
- FCM: future new-pack announcements
- Performance Monitoring

## 23.3 Avoid in v1
- Cloud Storage for user photos
- Firestore for every session
- cloud media processing
- server-side video rendering

## 23.4 Example Remote Config
```text
cloud_text_enabled
cloud_text_provider
reel_pack_travel_enabled
reel_pack_college_enabled
cover_pack_editorial_enabled
max_selected_photos_free
max_selected_photos_pro
render_1080_high_enabled
experimental_group_face_compare
min_supported_template_version
```

Never store secrets.

---

# 24. LOCAL DATABASE

Use a lightweight robust local database selected for Flutter compatibility.

Requirements:
- migrations
- sessions
- asset-analysis metadata
- decisions
- creation drafts
- render jobs
- template favorites
- settings

Do not store full original images in the database.

---

# 25. CACHE STRATEGY

Cache:
- thumbnails
- derived analysis images
- temporary render frames where needed
- creation previews

Rules:
- bounded cache
- automatic cleanup
- clear cache in settings
- do not clear active render files
- never delete original user media

---

# 26. PERFORMANCE TARGETS

Treat these as engineering targets, not marketing promises.

- home interactive quickly after launch
- scrolling remains smooth during analysis
- analysis happens off the UI thread/isolate/native worker
- progressive cluster results displayed before entire session is complete
- no full-resolution mass decode
- memory remains bounded
- user can background/cancel analysis safely
- long tasks survive navigation changes
- render progress is honest and cancellable

Benchmark on a mid-range Android device, not only flagship hardware.

---

# 27. PRIVACY & SECURITY

## 27.1 Default
- local processing
- no account required for v1
- no photo upload
- no face recognition identity database

## 27.2 Analytics exclusions
Never send:
- image bytes
- face crops
- face embeddings
- raw filenames
- precise EXIF coordinates
- user-written private text unless explicitly needed and disclosed

## 27.3 API keys
Never inside Flutter binary for production.

Use:
- backend secret store
- restricted project keys
- provider budgets
- key rotation

## 27.4 App Check
Protect callable/HTTP backend as appropriate.

## 27.5 Logs
Production logs must redact:
- tokens
- authorization headers
- local media paths where possible

---

# 28. MONETIZATION ARCHITECTURE (OPTIONAL, NOT CORE V1)

Do not couple core architecture to monetization.

Possible later structure:

## Free
- core best-shot analysis
- core review flow
- basic profile templates
- basic cover templates
- basic collage templates
- limited reel templates
- local text presets

## Premium / Lifetime candidate
- ad-free
- premium template packs
- advanced Best Set sizes
- more reel packs
- high-quality export profiles
- more cloud text generations
- premium typography/frames

Core photo safety and basic best-shot selection should not be intentionally degraded.

Do not add ads until core UX is stable.

---

# 29. ANALYTICS EVENTS

Keep minimal and privacy-safe.

Examples:
- `session_started`
- `session_analysis_completed`
- `cluster_compared`
- `ai_recommendation_overridden`
- `best_set_created`
- `review_bin_added`
- `device_delete_requested`
- `device_delete_completed`
- `profile_created`
- `cover_created`
- `collage_created`
- `reel_render_started`
- `reel_render_completed`
- `reel_render_failed`
- `cloud_text_requested`
- `cloud_text_fallback_used`
- `template_selected`

Do not log asset IDs that can identify personal library content unless strictly necessary; prefer session-local random identifiers.

---

# 30. ERROR UX

Every error must answer:
- what happened
- whether user data is safe
- what user can do next

Examples:

Bad:
“Render failed: -11800”

Good:
“Video couldn’t be finished. Your photos are safe. Free some storage and try again.”

Bad:
“Permission denied.”

Good:
“We can only work with photos you allow. Choose photos again or update photo access in Settings.”

---

# 31. OFFLINE BEHAVIOR

Must work offline:
- import already accessible local photos
- analysis
- ranking
- compare
- Review Bin
- minimal editing
- profile creation
- cover creation
- collage
- predefined reel creation
- local preset text

Cloud text button:
- show local suggestions if offline
- never block creation

---

# 32. TESTING STRATEGY

## Unit tests
- score normalization
- ranking
- cluster grouping
- diversity selection
- reason mapping
- template parser
- text fallback
- Remote Config mapping
- database migrations

## Golden/widget tests
- core result cards
- compare UI
- creation template previews
- dark/light theme

## Integration tests
- select photos
- analysis
- override recommendation
- Review Bin
- delete request flow (platform test)
- creation/export
- interrupted rendering

## Performance tests
- 20 photos
- 50 photos
- 100 photos
- 200 photos

Measure:
- analysis duration
- peak memory
- dropped frames
- thermal behavior
- render duration
- temporary storage

---

# 33. QUALITY GATES

A phase is not complete until:
- `flutter analyze` is clean or reviewed
- tests for the module pass
- loading/error/empty states exist
- dark/light theme checked
- no hardcoded secrets
- no placeholder TODO in critical path
- accessibility labels on critical controls
- manual smoke test completed
- Git diff reviewed

---

# 34. CI/CD

GitHub Actions should eventually run:
- Flutter formatting check
- static analysis
- unit/widget tests
- Android debug build
- release build validation later

Keep signing credentials outside repository.

iOS production signing should use approved secure CI or local Mac signing flow.

---

# 35. STORE-SAFETY REQUIREMENTS

- request only necessary media permissions
- clearly explain photo access
- no silent deletion
- no misleading “AI accuracy” claims
- no false guarantee that a photo is objectively best
- no uploading photos without explicit disclosure/consent
- privacy policy must match actual behavior
- third-party SDK list must be audited
- remove debug/pro bypass before release
- disable dev menus in production
- verify app has no embedded API keys
- verify screenshots accurately represent app behavior

---

# 36. DEVELOPMENT PHASES

## Phase 0 — Repository & architecture
Deliver:
- Flutter project
- app flavors/config structure if needed
- routing
- theme tokens
- core folder architecture
- local config abstraction
- test scaffolding
- CI baseline
- `README.md`
- `ARCHITECTURE.md`

Do not implement features deeply yet.

## Phase 1 — Premium UI shell
Deliver:
- splash
- onboarding
- home
- sessions
- creations
- settings
- mock result screens
- dark/light
- responsive layout
- animation primitives

Goal: approve product feel before complex engine work.

## Phase 2 — Photo selection/session
Deliver:
- system picker
- selected photo preview
- session creation
- thumbnails
- local persistence
- permission/limited-access UX

## Phase 3 — Analysis foundation
Deliver:
- metadata
- perceptual hashing
- quality metrics
- analysis worker
- progress
- caching
- persistence

## Phase 4 — Similarity & ranking
Deliver:
- near-duplicate clusters
- on-device similarity
- context profiles
- best/alternate/review/remove
- reason codes
- deterministic tests

## Phase 5 — Face-aware comparison
Deliver:
- face detection
- face quality signals
- group-photo logic
- compare UI
- face zoom
- override

## Phase 6 — Best Set
Deliver:
- diversity engine
- Best 5/10/20
- manual override
- creation handoff

## Phase 7 — Review Bin & deletion
Deliver:
- local Review Bin
- undo
- storage estimate
- OS-governed delete request
- result reconciliation

## Phase 8 — Minimal editor
Deliver:
- non-destructive adjustments
- before/after
- export
- reset

## Phase 9 — Profile + cover + collage
Deliver:
- shared template parser
- profile templates
- cover templates
- collage layouts
- smart face-safe crop
- high-res export

## Phase 10 — Reel template engine
Deliver:
- template JSON schema
- scene engine
- transitions
- motion presets
- text presets
- audio beat metadata
- preview

## Phase 11 — Local video render
Deliver:
- renderer abstraction
- selected implementation
- progress/cancel
- 720/1080 output
- storage handling
- temp cleanup
- device benchmarks

## Phase 12 — Firebase support layer
Deliver:
- Analytics
- Crashlytics
- Remote Config
- App Check
- privacy-safe events
- feature flags

## Phase 13 — Optional cloud text
Deliver:
- secure function/proxy
- provider abstraction
- OpenAI/Gemini integration
- quotas
- local fallback
- no photo upload

## Phase 14 — Monetization if approved
Deliver only after decision:
- IAP/lifetime/subscription design
- premium gating
- optional ad strategy

## Phase 15 — Release hardening
Deliver:
- performance pass
- package-size pass
- permissions audit
- dependency/license audit
- security scan
- secret scan
- store assets
- release build
- Android/iOS smoke tests

---

# 37. CODING ARCHITECTURE

Use clean modular boundaries, not over-engineered ceremony.

Suggested:

```text
lib/
  app/
  core/
    config/
    design/
    errors/
    logging/
    platform/
    storage/
    utils/
  features/
    onboarding/
    home/
    import/
    sessions/
    analysis/
    ranking/
    compare/
    review_bin/
    editor/
    creations/
      profile/
      cover/
      collage/
      reel/
    settings/
    premium/
  services/
    media_library/
    image_analysis/
    template_engine/
    video_renderer/
    text_suggestions/
    firebase/
```

Rules:
- UI must not directly call platform plugins.
- wrap platform/media APIs.
- analysis engine should be independently testable.
- video renderer behind interface.
- cloud provider behind interface.
- Firebase behind service layer.
- template parser versioned.

State-management library may be chosen based on maintainability; keep it consistent project-wide.

---

# 38. TEMPLATE PRODUCTION WORKFLOW

Use Canva/Figma/code-generated previews as **design tools**, not app dependencies.

For every template:

1. define purpose/vibe
2. create static visual reference
3. identify deterministic primitives
4. rebuild as app-native/template JSON
5. export only legally usable local assets
6. test on portrait/landscape photos
7. test face-safe crop
8. create preview thumbnail
9. assign immutable ID/version
10. add golden/snapshot preview test if practical

Codex should never scrape random web designs/assets into the app.

---

# 39. PREMIUM TEMPLATE QUALITY CHECK

Every cover/reel/collage template must pass:
- readable typography
- safe margins
- no text over important face unless intended
- works with bright and dark photos
- works with portrait and landscape source crops
- correct output dimensions
- no stretched image
- no broken mask
- no low-resolution texture
- no unlicensed asset
- consistent animation timing
- tasteful motion
- acceptable render time

Reject templates that merely add clutter.

---

# 40. FIRST RELEASE TEMPLATE TARGET

Recommended launch target:

## Profile
12 templates

## Cover
12 templates

## Collage
12 layouts

## Reels
12 premium templates

Total quality target: **48 strong creation options**.

Do not start by building 100+ mediocre templates.

Add more packs after engine stability.

---

# 41. LANGUAGE

Start:
- English UI

Architecture must support localization.

Optional later:
- Hindi
- other major locales

AI/local generated text must never overwrite user-written text.

---

# 42. DATA RETENTION

Default:
- sessions local
- analysis metadata local
- no server copy
- temporary render files auto-clean
- user can delete a session without deleting originals
- Review Bin entries clear when source file no longer exists

Add “Clear analysis data/cache” in settings.

---

# 43. SUCCESS METRICS

Product metrics:
- % sessions reaching analysis completion
- recommendation override rate
- % sessions generating Best Set
- % sessions creating at least one output
- reel render success rate
- deletion cancellation/restore rate
- crash-free sessions
- median time to first useful recommendation

High override rate may indicate ranking problems.

---

# 44. ACCEPTANCE CRITERIA — CORE PRODUCT

The product is not launch-ready unless a user can:

1. select a batch of photos,
2. receive useful clusters,
3. see a best recommendation with clear reason,
4. compare similar shots,
5. override the recommendation,
6. build a diverse Best Set,
7. move weak photos into Review Bin,
8. delete only after explicit confirmation,
9. create a profile image,
10. create a cover,
11. create a collage,
12. create a local predefined-template reel,
13. export successfully,
14. use core features offline,
15. complete all this without photos being uploaded to cloud AI.

---

# 45. SECURITY ACCEPTANCE CRITERIA

Before release:
- no API key in APK/AAB/IPA/repository
- no secret in Remote Config
- backend protected and rate-limited
- App Check enabled where suitable
- cloud text payload reviewed
- analytics payload reviewed
- debug endpoints removed
- dev premium override removed
- logs redacted
- dependency/license review complete

---

# 46. CODEX WORKING RULES

Codex must:

1. read current project state before every major task
2. inspect Git diff/status
3. preserve completed working functionality
4. implement only the requested phase
5. avoid giant rewrites
6. run format/analyze/tests after changes
7. document architectural decisions
8. record new dependencies and why they were added
9. avoid abandoned/unmaintained packages when a native or maintained option exists
10. verify package licensing before video/codec dependency is finalized
11. never commit secrets
12. never bypass OS media permission/deletion behavior
13. add graceful empty/loading/error states
14. optimize after correctness, but design APIs so performance work is possible
15. keep the app usable offline

---

# 47. FIRST PROMPT TO GIVE CODEX

Use this after placing both PRD files in the repository:

> Read `MASTER_PRD.md` and `CODEX_SETUP_CHECKLIST.md` completely. Treat them as the product source of truth. First inspect the repository, current Git status, installed SDK/tool versions, and any existing project files. Do not implement the entire app at once. Create a concise implementation plan for Phase 0 and Phase 1 only, note any technical risks or dependency choices that need verification, then scaffold the production-ready Flutter architecture, design system, navigation, theme support, test structure, CI baseline, and premium UI shell using mock data. Keep all integrations abstracted and do not request or embed OpenAI, Gemini, Firebase service-account, signing, or store secrets. Run formatting, static analysis, and tests. Summarize completed work, changed files, commands run, remaining issues, and the exact next phase.

---

# 48. PROMPT FOR EACH NEXT PHASE

> Continue from the current repository state. Read `MASTER_PRD.md`, inspect Git diff/status, and implement **Phase X only**. Reuse completed architecture; do not recreate or unnecessarily rewrite working code. Before coding, list the exact acceptance criteria for this phase. Implement production-quality loading/error/empty states, tests, and platform-safe behavior. After implementation run format, analysis, relevant tests and a build/smoke check where practical. Then report what changed, test results, risks, and the exact recommended next task.

---

# 49. CANVA + CODEX WORKFLOW

Canva is optional.

Use it when a template needs higher-quality design exploration.

Workflow:
1. connect Canva MCP to Codex/compatible agent
2. create 3 visual directions
3. select one
4. convert design into deterministic native/template primitives
5. export allowed vectors/rasters only
6. do not call Canva at app runtime
7. store source/reference ID in developer documentation
8. validate license before bundling any asset

---

# 50. OPEN QUESTIONS — OWNER DECISIONS

These are the only major product decisions that may remain unresolved while development begins:

- final name
- final logo
- final package/bundle ID
- monetization
- ads yes/no
- launch languages
- launch template-pack count
- final minimum OS versions
- whether local video files (not only photos) are supported in v1 reels
- whether cloud text is shown as “AI suggestions” or simply “Suggestions”

Everything else in this document should be treated as the default product direction unless changed explicitly.

---

# 51. FINAL PRODUCT STANDARD

The target is not “feature complete.”

The target is:

**A simple app that feels expensive, makes confident photo decisions, explains them, protects the user from accidental deletion, and turns the chosen photos into genuinely polished social-ready creations without depending on expensive cloud media generation.**

When choosing between:
- more features, or
- fewer features with better speed, clarity, animation, reliability and visual quality,

choose the second.

