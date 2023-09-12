// The Cloud Functions for Firebase SDK to set up triggers and logging.
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {logger} = require("firebase-functions");

// The Firebase Admin SDK to delete inactive users.
const admin = require("firebase-admin");
admin.initializeApp();

// Run once a day at midnight, to clean up the users
// Manually run the task here https://console.cloud.google.com/cloudscheduler
exports.accountcleanup = onSchedule("every 3 minutes", async (event) => {
  logger.log("User cleanup finished");
});
