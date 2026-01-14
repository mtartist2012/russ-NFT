# Fix broken image pages with corrupted JavaScript

$fixes = @(
    @{ file = "blue-redux.html"; title = "Blue Redux"; prev = "a-forest.html"; next = "moving-on.html"; ratio = "1/1" },
    @{ file = "moving-on.html"; title = "moving on"; prev = "blue-redux.html"; next = "cloud-background.html"; ratio = "1/1" },
    @{ file = "cloud-background.html"; title = "Cloud background"; prev = "moving-on.html"; next = "a-quiet-escape.html"; ratio = "1/1" },
    @{ file = "a-quiet-escape.html"; title = "a quiet escape"; prev = "cloud-background.html"; next = "cowboy-in-the-woods.html"; ratio = "1/1" },
    @{ file = "cowboy-in-the-woods.html"; title = "Cowboy in the woods"; prev = "a-quiet-escape.html"; next = "cowgirl-in-the-sand.html"; ratio = "1/1" },
    @{ file = "cowgirl-in-the-sand.html"; title = "Cowgirl in the sand"; prev = "cowboy-in-the-woods.html"; next = "fight-or-flight.html"; ratio = "1/1" }
)

$correctScript = @'
    <script src="../staging list.js"></script>
    <script>
        // Find this specific artwork from the staging list
        const currentNFT = nfts.find(nft => nft.title === "TITLE_PLACEHOLDER");
        const nftArray = currentNFT ? [currentNFT] : [];

        const root = document.getElementById('gallery-root');
        
        nftArray.forEach((nft, idx) => {
            const section = document.createElement('section');
            section.className = 'nft-row';
            section.innerHTML = `
                    <!-- RIGHT COLUMN (text on large screens) -->
                    <div class="text-block">
                        <h1>${nft.title}</h1>
                        
                        <p>${nft.desc}</p>
                        
                        <div class="section-title">Themes</div>
                        <p>${nft.themes || 'ctc'}</p>
                        
                        <div class="section-title">Analysis</div>
                        <p>${nft.analysis || 'ctc'}</p>
                        
                        <div class="section-title">Collector Notes / Provenance</div>
                        <p>${nft.collector || 'First edition NFT; RVL signature; part of the 2025 series.'}</p>
                        
                        <div class="section-title">Series Context</div>
                        <p>${nft.series || 'ctc'}</p>
                        
                        <div class="section-title">Artist Notes</div>
                        <p>${nft.artistNotes || ''}</p>
                        
                        <div class="section-title">Keywords</div>
                        <ul>
                            ${nft.keywords ? nft.keywords.map(kw => `<li>${kw}</li>`).join('') : '<li>ctc</li><li>ctc</li><li>ctc</li><li>ctc</li><li>ctc</li>'}
                        </ul>
                        
                    
                        <p>
                            <a href="#" target="_blank" class="price-btn">${nft.price}</a>
                        </p>
                        
                        <div class="nav-links-bottom">
                            <a href="PREV_PLACEHOLDER">Previous</a>
                            <span class="nav-separator">|</span>
                            <a href="../index.html">Gallery</a>
                            <span class="nav-separator">|</span>
                            <a href="NEXT_PLACEHOLDER">Next</a>
                        </div>
                    </div>
                    
                    <div class="image-column">
                    <!-- LEFT COLUMN (image on large screens) -->
                    <div class="nft-image-wrapper" 
                         data-image="${nft.file}" 
                         data-ratio="RATIO_PLACEHOLDER"
                         onclick="openLB('${nft.file}')">
                    </div>
                    <div class="image-meta">
                        <p>${nft.dims}<span style="padding: 0 10px;">|</span>${nft.date}</p>
                    </div>
                    <div class="quote-block">${nft.quote || ''}</div>
                    </div>
            `;
            root.appendChild(section);
        });

        // Initialize aspect ratio image system
        function initAspectRatioImages() {
            const wrappers = document.querySelectorAll(".nft-image-wrapper");
            
            wrappers.forEach(wrapper => {
                const imgUrl = wrapper.dataset.image;
                const ratio = wrapper.dataset.ratio;
                
                wrapper.style.aspectRatio = ratio;
                
                const bg = document.createElement("div");
                bg.className = "nft-image";
                // Adjust path for staging list (which uses 'images/full/...' not '../images/full/...')
                const adjustedUrl = imgUrl.startsWith('images/') ? '../' + imgUrl : imgUrl;
                bg.style.backgroundImage = `url('${adjustedUrl}')`;
                
                const overlay = document.createElement("img");
                overlay.className = "pixel-overlay";
                overlay.src = "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7";
                overlay.alt = "";
                overlay.draggable = false;
                
                wrapper.appendChild(bg);
                wrapper.appendChild(overlay);
            });
        }

        function openLB(src) {
            document.getElementById('lb-img').src = src;
            document.getElementById('lightbox').style.display = 'flex';
        }

        function updateDetailImage() {
            const wrappers = document.querySelectorAll('.nft-image-wrapper');
            if (!wrappers.length) return;
            
            const isTabletOrMobile = window.innerWidth <= 1280;
            
            wrappers.forEach(wrapper => {
                const src = wrapper.dataset.image;
                const filename = src.substring(src.lastIndexOf('/') + 1);
                const basename = filename.replace(/-[23]\.jpg$/, '');
                
                let newSrc = isTabletOrMobile 
                    ? `../images/main/${basename}-2.jpg`
                    : `../images/full/${basename}-3.jpg`;
                
                wrapper.dataset.image = newSrc;
                wrapper.setAttribute('onclick', `openLB('${newSrc}')`);
                const bgDiv = wrapper.querySelector('.nft-image');
                if (bgDiv) bgDiv.style.backgroundImage = `url('${newSrc}')`;
            });
        }

        initAspectRatioImages();
        updateDetailImage();
        window.addEventListener('resize', updateDetailImage);
    </script>

    <footer class="footer">
'@

foreach ($fix in $fixes) {
    $filePath = "image-pages\$($fix.file)"
    Write-Host "Fixing $filePath..."
    
    $content = Get-Content $filePath -Raw
    
    # Replace the script section (from <script src="../staging list.js"> to <footer class="footer">)
    $pattern = '(?s)<script src="\.\./staging list\.js"></script>.*?<footer class="footer">'
    
    $replacement = $correctScript `
        -replace 'TITLE_PLACEHOLDER', $fix.title `
        -replace 'PREV_PLACEHOLDER', $fix.prev `
        -replace 'NEXT_PLACEHOLDER', $fix.next `
        -replace 'RATIO_PLACEHOLDER', $fix.ratio
    
    $newContent = $content -replace $pattern, $replacement
    
    $newContent | Set-Content $filePath -NoNewline
    
    Write-Host "Fixed $($fix.file)" -ForegroundColor Green
}

Write-Host "`nAll 6 files have been fixed!" -ForegroundColor Cyan
