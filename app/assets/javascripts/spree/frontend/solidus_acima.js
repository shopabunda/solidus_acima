// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/frontend/all.js'

// Call this function to send a payment token, buyer name, and other details
// to the project server code so that a payment can be created with
// Payments API
async function createPayment(acima, transaction) {
  const paymentStatusDiv = document.getElementById('payment-status-container');

  acima.checkout({
    transaction: transaction
  }).catch(({ code, message }) => {
    paymentStatusDiv.innerHTML = "Payment Failed"
    throw new Error(message);
  })
}

// Helper method for displaying the Payment Status on the screen.
// status is either SUCCESS or FAILURE;
function displayPaymentResults(status) {
  const statusContainer = document.getElementById(
    'payment-status-container'
  );
  if (status === 'SUCCESS') {
    statusContainer.classList.remove('is-failure');
    statusContainer.classList.add('is-success');
  } else {
    statusContainer.classList.remove('is-success');
    statusContainer.classList.add('is-failure');

  }

  statusContainer.style.visibility = 'visible';
}

function jsonParseReturningNumbers(json) {
  let nJson = JSON.parse(json);

  // Iterate thorugh the array
  [].forEach.call(nJson, function(inst, i) {
    // Iterate through all the keys
    [].forEach.call(Object.keys(inst), function(y) {
      // Check if string is Numerical string
      if (!isNaN(nJson[i][y]))
        //Convert to numerical value
        nJson[i][y] = +nJson[i][y];
    });

  });

  return nJson
}

document.addEventListener('DOMContentLoaded', async function () {
  const iframeContainer = document.getElementById('iframe-container');
  const acima = new Acima.Client({
    merchantId: iframeContainer.dataset.merchantId,
    iframeUrl: iframeContainer.dataset.iframeUrl,
    iframeContainer: iframeContainer,
  });
  const transaction = jsonParseReturningNumbers(iframeContainer.dataset.transaction)

  async function handlePaymentMethodSubmission(event, paymentMethod) {
    event.preventDefault();

    try {
      // disable the submit button as we await tokenization and make a
      // payment request.

      cardButton.disabled = true;
      const paymentResults = await createPayment(acima, transaction);
      displayPaymentResults('SUCCESS');

      console.debug('Payment Success', paymentResults);
    } catch (e) {
      cardButton.disabled = false;
      displayPaymentResults('FAILURE');
      console.error(e.message);
    }
  }

  const cardButton = document.getElementById('acima-card-button');
  cardButton.addEventListener('click', async function (event) {

    await handlePaymentMethodSubmission(event);
  });
})
