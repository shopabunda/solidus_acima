const redirectToNextStep = (orderNumber, frontend) => {
  if (frontend) {
    window.location.href = '/checkout/confirm';
  } else {
    window.location.href = `/admin/orders/${orderNumber}/payments`
  }
}

const updateOrder = async (orderNumber, orderToken, leaseId, leaseNumber, checkoutToken, paymentMethodId, frontend) => {
console.log([leaseId, leaseNumber, checkoutToken])
  await fetch(`/api/checkouts/${orderNumber}`, {
    method: "PATCH",
    headers: {
      'Content-Type': 'application/json',
      'X-Spree-Order-Token': orderToken
    },
    body: JSON.stringify({
      'order': {
        'payments_attributes': [{
          'payment_method_id': paymentMethodId,
          'source_attributes': {
            'lease_id': leaseId,
            'lease_number': leaseNumber,
            'checkout_token': checkoutToken
          }
        }]
      }
    })
  })
  .then(() => {
    redirectToNextStep(orderNumber, frontend)
  });
}

// Call this function to start the Acima iframe process
// on success send an API call to create a payment and advance to next step
const createPayment = async (acima, customer, transaction, orderNumber, orderToken, paymentMethodId, frontend) => {
  acima.checkout({
    customer: customer,
    transaction: transaction
  })
  .then(({ leaseId, leaseNumber, checkoutToken }) => {
    updateOrder(orderNumber, orderToken, leaseId, leaseNumber, checkoutToken, paymentMethodId, frontend);
    displayPaymentResults('SUCCESS');
  })
  .catch(({ code, message }) => {
    console.log(`error ${code}: ${message}`);
    displayPaymentResults('FAILURE');
  });
}

// Helper method for displaying the Payment Status on the screen.
// status is either SUCCESS or FAILURE;
const displayPaymentResults = (status) => {
  const statusContainer = document.getElementById('payment-status-container');
  if (status === 'SUCCESS') {
    document.getElementById('iframe-container').remove()
    document.getElementById('acima-card-button').remove()
    statusContainer.innerHTML = 'Payment Success'
    statusContainer.classList.remove('is-failure');
    statusContainer.classList.add('is-success');
  } else {
    statusContainer.innerHTML = 'Payment Failure'
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
  const orderNumber =     iframeContainer.dataset.orderNumber
  const orderToken =      iframeContainer.dataset.orderToken
  const paymentMethodId = iframeContainer.dataset.paymentMethodId
  const transaction =     jsonParseReturningNumbers(iframeContainer.dataset.transaction)
  const customer =        JSON.parse(iframeContainer.dataset.customer)
  const frontend =        iframeContainer.dataset.frontend == "true" ? true : false;

  const handlePaymentMethodSubmission = async (event) => {
    event.preventDefault();

    try {
      // disable the submit button as we await payment creation
      cardButton.disabled = true;
      cardButton.style.display = 'none';
      await createPayment(acima, customer, transaction, orderNumber, orderToken, paymentMethodId, frontend);
    } catch (e) {
      cardButton.disabled = false;
      cardButton.style.display = '';
    }
  }

  const cardButton = document.getElementById('acima-card-button');
  cardButton.addEventListener('click', async function (event) {
    iframeContainer.classList.remove('acima-iframe-hidden');
    await handlePaymentMethodSubmission(event);
  });
})
