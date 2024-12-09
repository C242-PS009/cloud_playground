/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

exports.updateExpForEisenhower = onDocumentUpdated(
    {
      document: "eisenhower_tasks/{taskId}",
      region: "asia-southeast2",
    },
    async (event) => {
      const change = event.data;
      const taskBefore = change.before.data();
      const taskAfter = change.after.data();

      const userId = taskAfter.userId;

      if (!userId) {
        console.error("No userId associated with the task. Aborting.");
        return null;
      }

      if (taskBefore.isCompleted === false && taskAfter.isCompleted === true) {
        try {
        // Exp calculation
          const priority = taskAfter.priority || 4; // Default 4 (lowest)
          let expGained = 0;
          let coinsToAdd = 0;

          switch (priority.toLowerCase()) {
            case "urgent important":
              expGained = 50;
              coinsToAdd = 50;
              break;
            case "urgent not-important":
              expGained = 40;
              coinsToAdd = 40;
              break;
            case "not-urgent important":
              expGained = 30;
              coinsToAdd = 30;
              break;
            case "not-urgent not-important":
              expGained = 10;
              coinsToAdd = 10;
              break;
            default:
              expGained = 10; // Default exp
              coinsToAdd = 10;
          }

          // Update the user's exp_points
          const userRef = db.collection("users").doc(userId);
          await db.runTransaction(async (transaction) => {
            const userDoc = await transaction.get(userRef);
            if (!userDoc.exists) {
              throw new Error("User does not exist.");
            }

            transaction.update(userRef, {
              expPoints: admin.firestore.FieldValue.increment(expGained),
              coin: admin.firestore.FieldValue.increment(coinsToAdd),
            });
          });

          console.log(`Successfully added ${expGained} EXP 
            nd ${coinsToAdd} Coins to user: ${userId}`);
        } catch (error) {
          console.error("Error updating exPoints:", error);
        }
      }
    },
);

exports.updateExpForPomodoro = onDocumentUpdated(
    {
      document: "pomodoro_sessions/{sessionId}",
      region: "asia-southeast2",
    },
    async (event) => {
      const change = event.data;
      const sessionBefore = change.before.data();
      const sessionAfter = change.after.data();

      const userId = sessionAfter.userId;

      if (!userId) {
        console.error("No userId associated with the session. Aborting.");
        return null;
      }

      if (sessionBefore.isCompleted === false && sessionAfter.isCompleted ===
         true) {
        try {
        // Exp calculation
          const expGained = 25;
          const coinsToAdd = 10;

          // Update the user's expPoints
          const userRef = db.collection("users").doc(userId);
          await db.runTransaction(async (transaction) => {
            const userDoc = await transaction.get(userRef);
            if (!userDoc.exists) {
              throw new Error("User does not exist.");
            }

            transaction.update(userRef, {
              expPoints: admin.firestore.FieldValue.increment(expGained),
              coin: admin.firestore.FieldValue.increment(coinsToAdd),
            });
          });

          console.log(`Successfully added ${expGained} EXP and 
            ${coinsToAdd} to user: ${userId}`);
          return null;
        } catch (error) {
          console.error("Error updating exp_points for Pomodoro:", error);
          return null;
        }
      }
    },
);

exports.addInventoryOnItemPurchase = onDocumentCreated(
    {
      document: "purchases/{purchaseId}",
      region: "asia-southeast2",
    }, async (event) => {
      const purchaseData = event.data.data();
      const {userId, itemId} = purchaseData;

      if (!userId || !itemId) {
        console.error("Missing id");
        return;
      }

      try {
      // Check if the user already owns the item
        const inventoryRef = db.collection("users").
            doc(userId).collection("inventory");
        const existingItemSnapshot = await inventoryRef.
            where("itemId", "==", itemId).get();

        if (!existingItemSnapshot.empty) {
          console.error(`User already owns item: ${itemId}`);
          return;
        }

        // Add the purchased item to the user's inventory
        const itemSnapshot = await db.collection("items").doc(itemId).get();
        if (!itemSnapshot.exists) {
          throw new Error("Item does not exist.");
        }
        const itemData = itemSnapshot.data();

        await inventoryRef.doc(itemId).set({
          itemId: itemId,
          name: itemData.name,
          itemCategory: itemData.itemCategory,
          img: itemData.img,
          purchaseDate: new Date().toISOString(),
        });
        console.log(`Successfully added item ${itemId} 
          to player ${userId}'s inventory.`);
      } catch (error) {
        console.error("Error adding item to inventory:", error);
      }
    });

