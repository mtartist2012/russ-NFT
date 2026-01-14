# Add hamburger button to all image-pages

$files = Get-ChildItem "c:\Users\Russell\OneDrive\Desktop\russ NFT\image-pages\*.html"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    
    # Add hamburger button after logo
    $content = $content -replace '(<div class="logo">.*?</div>)\s*(<ul class="nav-links">)', @'
$1
            <button class="hamburger" aria-label="Toggle navigation">
                <span></span>
                <span></span>
                <span></span>
            </button>
            $2
'@
    
    # Add mobile menu script before closing body tag if not already present
    if ($content -notmatch 'Mobile menu toggle') {
        $content = $content -replace '(</body>)', @'

    <script>
        // Mobile menu toggle
        const hamburger = document.querySelector('.hamburger');
        const navLinks = document.querySelector('.nav-links');
        const dropdown = document.querySelector('.dropdown');
        const dropdownToggle = document.querySelector('.dropdown-toggle');

        hamburger.addEventListener('click', () => {
            hamburger.classList.toggle('active');
            navLinks.classList.toggle('active');
        });

        // Close menu when clicking a link (except dropdown toggle)
        navLinks.querySelectorAll('a:not(.dropdown-toggle)').forEach(link => {
            link.addEventListener('click', () => {
                hamburger.classList.remove('active');
                navLinks.classList.remove('active');
            });
        });

        // Mobile dropdown toggle
        dropdownToggle.addEventListener('click', (e) => {
            if (window.innerWidth <= 768) {
                e.preventDefault();
                dropdown.classList.toggle('active');
            }
        });
    </script>
$1
'@
    }
    
    Set-Content $file.FullName $content -NoNewline
    Write-Host "Updated $($file.Name)"
}

Write-Host "`nAll image-pages updated with hamburger menu!"
