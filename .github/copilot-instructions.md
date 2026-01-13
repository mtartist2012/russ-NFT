## Purpose
Concise, actionable guidance for AI coding agents working on this repository — a static multi-page NFT gallery website (HTML/CSS/JS) with no build tools.

## Big picture
- **Type**: Static multi-page website showcasing digital NFT artwork
- **Key files**: [index.html](index.html) (gallery hub), [css/style.css](css/style.css)
- **Structure**: Gallery hub → individual artwork pages in `image-pages/` directory
- **Assets**: High-res artwork in `images/full/`, thumbnails in `images/thumbs/`, hero/banner images in `images/main/`

## Architecture & data flow
- **Multi-page pattern**: [index.html](index.html) shows thumbnail grid linking to dedicated pages (e.g., [image-pages/a-forest.html](image-pages/a-forest.html))
- **Naming convention**: Thumbnails use `-1` suffix (`a-forest-1.jpg`), medium-res use `-2` suffix (`a-forest-2.jpg`), full images use `-3` suffix (`a-forest-3.jpg`), same basename required
- **Responsive images** (JavaScript-driven):
  - **Index gallery**: Mobile (≤768px) loads `-1` from `thumbs/`, desktop/tablet loads `-2` from `main/`
  - **Detail pages**: Tablet/mobile (≤1280px) loads `-2` from `main/`, desktop loads `-3` from `full/`
  - Image switching handled by JavaScript on window resize
- **Navigation**: Dropdown menu in navbar (`<li class="dropdown">`) lists all artworks — must be updated in both [index.html](index.html) AND all pages in `image-pages/` when adding new artwork
- **Page templates** (located in `z - working/` folder):
  - [z - working/new-image-template.html](z - working/new-image-template.html): JS-driven gallery with inline NFT data in `<script>` block — **migrating to this approach**
  - `image-pages/*.html`: Legacy static HTML pages (being phased out in favor of JS-driven approach)
  - [z - working/text-template.html](z - working/text-template.html): Text content template for artwork descriptions
  - [z - working/one-image.css](z - working/one-image.css): Alternative CSS layout (not currently in production)
  - [z - working/new-hub.html](z - working/new-hub.html): Alternative gallery hub layout
- **Lightbox**: Inline JS (`openLB()` function) handles click-to-zoom; DOM: `<div class="lightbox" id="lightbox" onclick="this.style.display='none'">` — click anywhere to close

## Critical file structures
```
images/
  thumbs/     → <basename>-1.jpg (mobile gallery thumbnails, ≤768px)
  main/       → <basename>-2.jpg (tablet/desktop gallery + detail pages ≤1280px)
  full/       → <basename>-3.jpg (high-res detail pages >1280px)
  z-not/      → unused/archived images
image-pages/  → individual artwork detail pages (JS-driven with responsive images)
css/
  style.css   → main styling for ALL pages (gallery + detail pages)
z - working/  → templates and experimental layouts
  new-image-template.html → JS-driven detail page template
  text-template.html      → content structure guide
  one-image.css           → alternative layout CSS (not in production)
  new-hub.html            → alternative gallery hub
qr-codes/
  ASF-qr-codes/ → QR code assets
```

## Developer workflow
**Run local server** (repo root):
```powershell
python -m http.server 8000
# Open http://localhost:8000/index.html
```
**Debugging**: Open DevTools, check Console for JS errors and Network tab for 404s (missing images).

## Project-specific conventions
1. **Adding new artwork**: 
   - Place thumbnail in `images/thumbs/<name>-1.jpg` 
   - Place medium-res in `images/main/<name>-2.jpg`
   - Place full image in `images/full/<name>-3.jpg`
   - Create detail page in `image-pages/<name>.html` using existing pages like [image-pages/a-forest.html](image-pages/a-forest.html) as template
   - Add gallery entry to [index.html](index.html) gallery section:
     ```html
     <a class="thumb" href="image-pages/<name>.html">
         <img src="images/thumbs/<name>-1.jpg" alt="...">
         <div class="thumb-title"><name></div>
     </a>
     ```
   - **CRITICAL**: Update dropdown menu in BOTH [index.html](index.html) AND all existing pages in `image-pages/` — add link in `<div class="dropdown-menu">` section
   - **Case sensitivity**: Image filenames in `images/full/` and `images/thumbs/` mix uppercase and lowercase (e.g., `All-American-3.jpg`, `a-forest-1.jpg`). Match exact case when referencing images.

2. **Templates usage**:
   - **Primary template**: Use [z - working/new-image-template.html](z - working/new-image-template.html) for new artwork pages — JS-driven with inline NFT data in `<script>` block
   - Legacy pages in `image-pages/` folder use static HTML (being migrated to JS approach)
   - [z - working/text-template.html](z - working/text-template.html) provides text structure for artwork descriptions
   - [z - working/staging list.js](z - working/staging list.js) holds NFT metadata (title, desc, date, dims) for JS-driven galleries
   - [z - working/new-hub.html](z - working/new-hub.html) is an alternative gallery hub layout
   - **Detail page structure**: Each artwork page includes Themes, Analysis, Collector Notes/Provenance, Series Context, Artist Notes, and Keywords sections

3. **Path references critical detail**: 
   - From root (e.g., [index.html](index.html), [z - working/new-image-template.html](z - working/new-image-template.html)): Use `images/full/<name>-3.jpg`
   - From `image-pages/` subdirectory: Use `../images/full/<name>-3.jpg` and `../css/style.css` (relative paths)
   - **Current implementation**: All existing pages in `image-pages/` correctly use `../` prefix for CSS and images

4. **Do not rename/move**: `images/thumbs/`, `images/full/`, `images/main/`, `qr-codes/ASF-qr-codes/` — paths hard-coded in HTML.

## Styling patterns
- **Gallery grid**: Desktop uses `grid-template-columns: repeat(3, 1fr)` with `gap: 1.5rem` in [css/style.css](css/style.css); responsive breakpoints adjust for mobile
- **Detail pages**: Responsive 2-column layout (text left, image right on desktop) via [css/style.css](css/style.css)
- **Fonts**: Google Fonts (Oswald, Droid Sans, Roboto, Homemade Apple, Red Hat Text) loaded in `<head>`
- **CSS Variables**: Color scheme defined in `:root` ([css/style.css](css/style.css)) — `--bg`, `--bk`, `--accent`, `--text`, `--rule`, `--frame`, `--button`
- **Background**: Page uses `url(../images/page-background-02.jpg)` with `background-size: cover`

## Examples from codebase
**Lightbox implementation** ([index.html](index.html)):
```html
<div class="lightbox" id="lightbox" onclick="this.style.display='none'">
    <img id="lb-img" src="">
</div>
<script>
    function openLB(src) {
        document.getElementById('lb-img').src = src;
        document.getElementById('lightbox').style.display = 'flex';
    }
</script>
```

**Detail page structure** ([image-pages/a-forest.html](image-pages/a-forest.html)):
- Text block with title, medium, year, descriptions (short/long), conceptual themes, keywords
- Image displayed: `<img src="../images/full/a-forest-3.jpg">` (using relative path from subdirectory)
- Back link: `<a href="../index.html">← Back to Gallery</a>`
- Uses JS to dynamically populate content from inline `nfts` array in `<script>` block (in newer template approach)

**CSS color variables** ([css/style.css](css/style.css#L4-L11)):
```css
:root {
    --bg: rgb(235, 208, 144);
    --bk: rgb(255, 253, 251);
    --accent: rgb(255, 0, 85);
    --text: rgb(29, 25, 26);
    --rule: rgb(141, 122, 97);
    --frame: rgb(25, 18, 10);
    --button: rgba(125, 88, 50, 0.5);
}
```

## Testing checklist
- Verify all thumbnails in gallery load (no 404s)
- Click each gallery item → detail page loads correctly
- Detail page shows full-resolution image
- Back link returns to gallery
- Test lightbox on applicable pages

## Platform notes
- Repo stored in **OneDrive on Windows** — watch for spaces in paths, file locking
- Use absolute paths from workspace root when referencing files programmatically
- **About/Contact pages**: Use `page-background-01.jpg` instead of default `page-background-02.jpg`; logo links to [index.html](index.html)

## When to ask owner
- Before adding build tools, package managers, or frameworks
- Before restructuring image directory layout
- If changing from static pages to JS-driven SPA
