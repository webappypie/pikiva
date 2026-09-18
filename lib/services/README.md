# Service boundary

Add native media, analysis, storage, template, video, text, and Firebase adapters
only in their implementation phases. Inject them through the app composition
root. No empty service implementations or speculative dependencies ship now.

Core photo analysis and template rendering stay on-device. Future cloud text
accepts explicitly approved text metadata through a secured backend. No service
may upload normal user photos or silently delete originals.
