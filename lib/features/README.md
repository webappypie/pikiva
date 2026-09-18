# Feature boundary

Product features start in their assigned PRD phase. Phase 0 does not implement
onboarding, home, sessions, creations, settings, or mock result screens.

Add one feature directory as it becomes necessary, with presentation, domain,
and data boundaries only where they have responsibilities. Presentation may use
domain contracts; it must not import platform plugins or cloud SDKs. Pure domain
logic must remain testable without widgets, media access, or a network.

See ../../ARCHITECTURE.md for the complete responsibility map.
