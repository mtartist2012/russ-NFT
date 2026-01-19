(function () {
  const body = document.querySelector("body.artwork-page");
  const slug = body.getAttribute("data-slug");

  const art = artworks.find(a => a.slug === slug);
  if (!art) return;

  // Title
  document.getElementById("artwork-title").textContent = art.title;

  // Short / long descriptions
  document.getElementById("short-desc").textContent = art.desc;
  document.getElementById("long-desc").textContent = art.longDesc;

  // Image
  const img = document.getElementById("artwork-image");
  img.src = art.file;
  img.alt = art.title;

  // Dims | Date
  document.getElementById("dims-date").textContent = `${art.dims} | ${art.date}`;

  // Text blocks
  document.getElementById("themes").textContent = art.themes;
  document.getElementById("analysis").textContent = art.analysis;
  document.getElementById("collector").textContent = art.collector;
  document.getElementById("series").textContent = art.series;
  document.getElementById("artist-notes").textContent = art.artistNotes;
  document.getElementById("keywords").textContent = art.keywords.join(", ");

  // Status / NFT
  document.getElementById("status").textContent = art.status;
  document.getElementById("nft-listing").textContent = art.price;

  // Quote
  document.getElementById("quote-block").textContent = art.quote;

  // Meta tags
  const metaDesc = document.getElementById("meta-description");
  const ogTitle = document.getElementById("og-title");
  const ogImage = document.getElementById("og-image");
  const ogDesc = document.getElementById("og-description");

  if (metaDesc) metaDesc.setAttribute("content", art.metaDescription || art.desc);
  if (ogTitle) ogTitle.setAttribute("content", art.title);
  if (ogImage) ogImage.setAttribute("content", art.file);
  if (ogDesc) ogDesc.setAttribute("content", art.metaDescription || art.desc);
})();