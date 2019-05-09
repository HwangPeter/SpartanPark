const functions = require('firebase-functions');
const admin = require('firebase-admin')

// var config = {
//     apiKey: "AIzaSyCNb8vv9tOCYM8jbEXRL-vF5mbPNGKvvNE",
//     authDomain: "autolayout-bb566.firebaseapp.com",
//     databaseURL: "https://autolayout-bb566.firebaseio.com/",
//     storageBucket: "gs://autolayout-bb566.appspot.com"
//   };
  
admin.initializeApp({
  databaseURL: "https://autolayout-bb566.firebaseio.com/"
});

const stripe = require("stripe")("sk_test_HZ4o6tDr7OH0UkViap8DJBi100fjrk7VqB");

const runtimeOpts = {
  timeoutSeconds: 300,
  memory: '1GB'
}

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.createStripeCustomer = functions.database.ref('/users/{userID}').onCreate(async (snapshot, context) => {

    console.log(snapshot.val().License);
      const account = await stripe.accounts.create({
        country: 'US',
        type: 'custom',
        business_type: 'individual',
        individual: {
          first_name: snapshot.val().licenseFirstName,
          last_name: snapshot.val().licenseLastName,
        dob: {day: snapshot.val().licenseDOBDay,
        month: snapshot.val().licenseDOBMonth,
        year: snapshot.val().licenseDOBYear,
        },
        ssn_last_4: '0000',
      },
        requested_capabilities: ['platform_payments'],
      }, function(err, account) {
        if (err) {
          console.log('err', err);
          return err;
        }
          else {
            stripe.accounts.update(
              account.id,
              {
                tos_acceptance: {
                  date: Math.floor(Date.now() / 1000),
                  ip: '130.65.254.10' // Assumes you're not using a proxy
                }
              }
            );
            console.log('account', account);
            return snapshot.ref.child('stripeId').set(account.id)
          }
      });

  });
  
exports.chargeCustomer = functions.database.ref('/ongoingRequests/{userID}/payout').onCreate(async (snapshot, context) => {

  console.log(snapshot.val());

  const charge = await stripe.charges.create({
    amount: 1000,
    currency: "usd",
    source: "tok_visa",
    transfer_data: {
      amount: 877,
      destination: snapshot.val(),
    },
  }, function(err, charge) {
    if (err) {
      console.log('err', err);
      return err;
    }
    else {
      console.log('charge', charge);
      return charge
    }
    // asynchronously called
  });
  
});

// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// })
