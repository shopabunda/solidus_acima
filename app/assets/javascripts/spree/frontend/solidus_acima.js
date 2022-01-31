// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/frontend/all.js'

// Call this function to start the Acima iframe process
// on success send an API call to create a payment
const createPayment = async (acima, transaction) => {
  const paymentStatusDiv = document.getElementById('payment-status-container');

  acima.checkout({
    transaction: transaction
  })
  .then(() => {
    // call api to create payment
    displayPaymentResults('SUCCESS')
  })
  .catch(() => {
    displayPaymentResults('FAILURE')
  })
}

// Helper method for displaying the Payment Status on the screen.
// status is either SUCCESS or FAILURE;
const displayPaymentResults = (status) => {
  const statusContainer = document.getElementById('payment-status-container');
  if (status === 'SUCCESS') {
    statusContainer.classList.remove('is-failure');
    statusContainer.classList.add('is-success');
  } else {
    statusContainer.classList.remove('is-success');
    statusContainer.classList.add('is-failure');
  }

  statusContainer.style.visibility = 'visible';
}

const jsonParseReturningNumbers = (json) => {
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

  const handlePaymentMethodSubmission = async (event) => {
    event.preventDefault();

    try {
      // disable the submit button as we await payment creation
      cardButton.disabled = true;
      const paymentResults = await createPayment(acima, transaction);
    } catch (e) {
      cardButton.disabled = false;
    }
  }

  const cardButton = document.getElementById('acima-card-button');
  cardButton.addEventListener('click', async function (event) {
    iframeContainer.classList.remove('acima-iframe-hidden');
    await handlePaymentMethodSubmission(event);
  });
})
