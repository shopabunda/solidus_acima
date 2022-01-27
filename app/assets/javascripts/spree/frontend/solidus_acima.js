// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/frontend/all.js'

document.addEventListener('DOMContentLoaded', async function () {
  const iframeContainer = document.getElementById('my-container');
  if (iframeContainer){
    const acima = new Acima.Client({
      merchantId: iframeContainer.dataset.merchantId,
      iframeUrl: iframeContainer.dataset.iframeUrl,
      iframeContainer: iframeContainer,
    });
  }
})
