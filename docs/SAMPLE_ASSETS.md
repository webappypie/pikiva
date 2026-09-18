# Bundled sample imagery

These two fictional landscape photographs are development-time generated assets,
not user photos. They are bundled for offline UI previews only. The app contains
no image-generation integration, AI key, network image loader, or analysis engine.
UI recommendations and selected sets are authored fixtures, not model output.

Generated with the built-in OpenAI image generation tool on 2026-09-18, using the
imagegen skill. Originals retained without editing at 1536 × 1024 pixels.
No referenced images, identifiable people, brands, or third-party stock were used.
The UI identifies the collection and creation previews as sample content.

## assets/samples/coast.png

Final prompt:

> Use case: photorealistic-natural. Asset type: bundled sample photograph in a premium offline photo-curation mobile app. Create one landscape editorial travel photograph, 1536x1024, of a quiet winding coastal footpath above a turquoise sea, sunlit pale cliffs, wild olive trees, small terracotta wildflowers in foreground, distant hazy headland, natural late-afternoon light. Sophisticated authentic film-like photography with delicate grain, restrained warm greens and blue, crisp realistic detail and airy composition. No people, buildings, text, logos, borders, watermarks or UI. This is a fictional sample scene for a clearly labeled demo collection.

## assets/samples/cove.png

Final prompt:

> Use case: photorealistic-natural. Asset type: second bundled sample photograph in an offline photo-curation app. One landscape editorial travel photograph, 1536x1024. A quiet Mediterranean-style rocky cove with transparent turquoise water, pale pebble shore, olive branches framing top corner, soft sunlit cliffs in background, no people. Natural late-afternoon light, sophisticated authentic travel photography, delicate film grain, crisp texture, warm greens and blues. Composition: shore gently curves diagonally toward a distant headland, ample sea in center. No text, logos, borders, watermark, UI or buildings. Fictional sample scene only.

Together the source PNGs add about 7.0 MiB before APK compression. Image widgets
bound decode width to 1200 pixels. Replace or optimize sample assets during
release asset review if the final download budget requires it; no media codec or
external font binaries were added for this phase.
