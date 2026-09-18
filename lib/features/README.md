# Feature boundary

Phase 1 implements onboarding, Home, Sessions, Creations, Settings, and authored
sample result screens. Real photo selection and session storage begin in Phase 2.

Add one feature directory as it becomes necessary, with presentation, domain,
and data boundaries only where they have responsibilities. Presentation may use
domain contracts; it must not import platform plugins or cloud SDKs. Pure domain
logic must remain testable without widgets, media access, or a network.

See ../../ARCHITECTURE.md for the complete responsibility map.
