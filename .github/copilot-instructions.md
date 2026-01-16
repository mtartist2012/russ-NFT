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
- **Automated aspect ratio system**: Detail pages use data attributes (`data-image`, `data-dims`) with JavaScript that auto-builds background-image divs and calculates aspect ratios from dimensions (`6000 x 6000px` → ratio computed programmatically)
- **Navigation**: 
  - **Navbar links**: Simple navigation with gallery/start, about/contact links
  - **Mobile**: Hamburger menu (`<button class="hamburger">`) toggles `.active` class on `.nav-links`
  - **Detail pages**: Previous/gallery/next links in navbar and bottom of content section
  - **Note**: No dropdown artwork list in current implementation; users navigate via gallery grid or sequential prev/next links
- **Page templates** (located in `z - working/` folder and `image-pages/` for reference):
  - **Current approach**: Use existing files in `image-pages/` (e.g., [image-pages/a-forest.html](image-pages/a-forest.html)) as template — JS-driven with inline NFT data in `<script>` block
  - [z - working/text-template.html](z - working/text-template.html): Text content template for artwork descriptions with section structure guide
  - [z - working/one-image.css](z - working/one-image.css): Alternative CSS layout (not currently in production)
  - [z - working/new-hub.html](z - working/new-hub.html): Alternative gallery hub layout
  - [staging list.js](staging list.js) (root level): NFT metadata source with complete artwork data (title, desc, date, dims, aspectRatio, themes, etc.)
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
  text-template.html      → content structure guide
  one-image.css           → alternative layout CSS (not in production)
  new-hub.html            → alternative gallery hub
qr-codes/
  ASF-qr-codes/ → QR code assets
staging list.js → NFT metadata source (root level)
```

## Developer workflow
**Run local server** (repo root):
```powershell
python -m http.server 8000
# Open http://localhost:8000/index.html
```
**Debugging**: Open DevTools, check Console for JS errors and Network tab for 404s (missing images).

**Bulk automation scripts** (PowerShell): Several utility scripts exist in `z - working/` directory for batch operations:
- `fix-aspect-ratios.ps1`, `fix-pages.ps1`, `fix-remaining-pages.ps1` — automated page updates
- `add-hamburger.ps1` — add mobile navigation to pages
- Use with caution; review changes before committing

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
   - **CRITICAL**: Update prev/next navigation links in BOTH navbar and bottom navigation in each new page to maintain sequential flow
   - **Case sensitivity**: Image filenames in `images/full/` and `images/thumbs/` mix uppercase and lowercase (e.g., `All-American-3.jpg`, `a-forest-1.jpg`). Match exact case when referencing images.

2. **Templates usage**:
   - **Primary template**: Use existing files in `image-pages/` (e.g., [image-pages/a-forest.html](image-pages/a-forest.html)) as template — JS-driven with inline NFT data in `<script>` block
   - [z - working/text-template.html](z - working/text-template.html) provides text structure for artwork descriptions
   - [staging list.js](staging list.js) holds NFT metadata (title, desc, date, dims, aspectRatio, themes, etc.) — source of truth for artwork data
   - [z - working/new-hub.html](z - working/new-hub.html) is an alternative gallery hub layout
   - **Detail page structure**: Each artwork page includes Themes, Analysis, Collector Notes/Provenance, Series Context, Artist Notes, and Keywords sections

3. **Path references critical detail**: 
   - From root (e.g., [index.html](index.html)): Use `images/full/<name>-3.jpg`
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
**Responsive image switching on gallery** ([index.html](index.html#L208-L230)):
```javascript
function updateGalleryImages() {
    const galleryImages = document.querySelectorAll('.gallery .thumb img');
    const isMobile = window.innerWidth <= 768;
    
    galleryImages.forEach(img => {
        const src = img.src;
        const filename = src.substring(src.lastIndexOf('/') + 1);
        const basename = filename.replace(/-[12]\.jpg$/, '');
        
        if (isMobile) {
            img.src = `images/thumbs/${basename}-1.jpg`;
        } else {
            img.src = `images/main/${basename}-2.jpg`;
        }
    });
}
```

**Mobile hamburger menu** ([index.html](index.html#L237-L254)):
```javascript
const hamburger = document.querySelector('.hamburger');
const navLinks = document.querySelector('.nav-links');

hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('active');
    navLinks.classList.toggle('active');
});
```

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

**Aspect ratio calculation** ([image-pages/a-forest.html](image-pages/a-forest.html#L139-L155)):
```javascript
function initAspectRatioImages() {
    const wrappers = document.querySelectorAll(".nft-image-wrapper");
    
    wrappers.forEach(wrapper => {
        const imgUrl = wrapper.dataset.image;
        const dims = wrapper.dataset.dims;
        
        // Calculate aspect ratio from dimensions
        if (dims) {
            const match = dims.match(/(\d+)\s*x\s*(\d+)/i);
            if (match) {
                const width = parseInt(match[1]);
                const height = parseInt(match[2]);
                const ratio = width / height;
                wrapper.style.aspectRatio = ratio;
            }
        }
    });
}
```

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

## SEO & Meta tag patterns
All pages require SEO-optimized meta tags following this structure:

**Gallery pages** ([index.html](index.html)):
```html
<title>russNFT | 4K Gallery</title>
<meta name="description" content="Explore the russNFT 4K digital art gallery featuring abstract collages, symbolic landscapes, and contemporary digital artwork by RVL...">
<meta name="keywords" content="NFT gallery, 4K digital art, abstract collage, digital art collection, RVL artist...">
```

**Artwork detail pages** (use [meta descriptions.html](meta descriptions.html) as reference):
```html
<title>a forest - digital collage by RUSSNFT</title>
<meta name="description" content="A layered digital forest abstraction blending atmosphere, symbolism, and quiet psychological depth...">
<meta name="keywords" content="digital forest collage, abstract woodland art, symbolic nature imagery, atmospheric greens, RVL digital art">
```

**Static pages** ([about.html](about.html), [contact.html](contact.html)):
- Use page-specific, descriptive content
- Include "russNFT" or "RVL artist" in descriptions
- Keywords should reflect page purpose (e.g., "contact NFT artist, commission digital art")

**Meta description guidelines**:
- 140-160 characters optimal
- Artwork descriptions focus on visual elements, emotional tone, and symbolic themes
- Include "RVL digital art" in keywords for consistency
- Use artwork title format: lowercase for most titles, title case for proper nouns (e.g., "a forest" vs "Blue Redux")

## Footer structure
All pages use consistent three-column footer from [css/style.css](css/style.css):

```html
<footer class="footer">
    <div class="container footer-container">
        <div class="footer-section">
            <h3>RUSS NFT</h3>
            <p>Unlocking the potential of digital art for the 4K age</p>
        </div>
        <div class="footer-section">
            <h4>Quick Links</h4>
            <ul>
                <li><a href="../index.html">Gallery</a></li>
                <li><a href="../about.html">About</a></li>
                <li><a href="../contact.html">Contact</a></li>
            </ul>
        </div>
        <div class="footer-section"> 
            <h4>Connect</h4>
            <ul>
                <li><a href="https://www.instagram.com/mtartist2012">Instagram</a></li>
                <li><a href="https://www.facebook.com/rvlfineart">Facebook</a></li>
                <li><a href="https://www.rvlfineart.com/favorites">Purchase Prints</a></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">
        <div class="container">
            <p>&copy; 2026 RUSS NFT. All rights reserved.</p>
        </div>
    </div>
</footer>
```

**Path adjustments**:
- From root pages ([index.html](index.html), [about.html](about.html)): Use `href="index.html"`
- From `image-pages/` subdirectory: Use `href="../index.html"`
- External links (Instagram, Facebook, Purchase Prints) remain unchanged

**Social media URLs** (do not modify):
- Instagram: `https://www.instagram.com/mtartist2012`
- Facebook: `https://www.facebook.com/rvlfineart`
- Purchase Prints: `https://www.rvlfineart.com/favorites`

## QR codes
QR code assets stored in `qr-codes/ASF-qr-codes/` directory for artwork sharing and physical exhibition materials.

**Current QR codes**:
- `ASF-qr-code-Blue-Redux.jpeg` — Links to Blue Redux artwork page

**Naming convention**: `ASF-qr-code-<artwork-title>.jpeg`
- Match artwork basename (e.g., "Blue-Redux" for blue-redux.html)
- Use title case for proper nouns, hyphens for spaces
- JPEG format for print compatibility

**Usage**: QR codes enable physical exhibition visitors to access high-res digital versions and NFT purchase links via mobile devices. Not currently embedded in HTML pages but available for promotional materials.

## Testing checklist
- Verify all thumbnails in gallery load (no 404s)
- Click each gallery item → detail page loads correctly
- Detail page shows full-resolution image
- Back link returns to gallery
- Test lightbox on applicable pages
- Validate meta descriptions are unique per page
- Check footer links work correctly with proper relative paths

## Platform notes
- Repo stored in **OneDrive on Windows** — watch for spaces in paths, file locking
- Use absolute paths from workspace root when referencing files programmatically
- **About/Contact pages**: Use `page-background.jpg` instead of default `page-background-02.jpg`; logo links to [index.html](index.html)

## When to ask owner
- Before adding build tools, package managers, or frameworks
- Before restructuring image directory layout
- If changing from static pages to JS-driven SPA

## Quick reference
- **Local server**: `python -m http.server 8000` from repo root
- **Image naming**: `<basename>-1.jpg` (thumbs), `-2.jpg` (main), `-3.jpg` (full)
- **Path from subdirs**: Use `../` prefix for CSS and images
- **Data source**: [staging list.js](staging list.js) contains all NFT metadata
- **Template**: Copy [image-pages/a-forest.html](image-pages/a-forest.html) for new artwork pages
