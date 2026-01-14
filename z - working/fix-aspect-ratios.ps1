# Update all image pages to calculate aspect ratios from dimensions instead of hardcoded values

$files = Get-ChildItem "image-pages\*.html" | Where-Object { $_.Name -ne 'a-forest.html' }

$oldPattern1 = 'data-ratio="[^"]*"'
$newPattern1 = 'data-dims="${nft.dims}"'

$oldPattern2 = @'
                const imgUrl = wrapper.dataset.image;
                const ratio = wrapper.dataset.ratio;
                
                wrapper.style.aspectRatio = ratio;
'@

$newPattern2 = @'
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
'@

foreach ($file in $files) {
    Write-Host "Updating $($file.Name)..."
    
    $content = Get-Content $file.FullName -Raw
    
    # Replace data-ratio with data-dims
    $content = $content -replace $oldPattern1, $newPattern1
    
    # Replace aspect ratio calculation logic
    $content = $content -replace [regex]::Escape($oldPattern2), $newPattern2
    
    $content | Set-Content $file.FullName -NoNewline
    
    Write-Host "Updated $($file.Name)" -ForegroundColor Green
}

Write-Host "`nAll 23 files updated to use calculated aspect ratios!" -ForegroundColor Cyan
