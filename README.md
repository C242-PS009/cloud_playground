# cloud_playground
Works done by the cloud computing division on HabitSaga project

# Firebase Cloud Functions Documentation

## Function List

1. **`updateExpForEisenhower`**: Updates experience points (EXP) when a task is completed.
2. **`updateExpForPomodoro`**: Updates experience points (EXP) when a Pomodoro session is completed.
3. **`addInventoryOnItemPurchase`**: Adds an item to the user's inventory when they make a purchase.

### 1. `updateExpForEisenhower`

**Trigger Type**: Firestore `onDocumentUpdated`

**Trigger Location**: `eisenhower_tasks/{taskId}`

**Description**: This function is triggered when a document in the `eisenhower_tasks` collection is updated. It checks whether the task status has changed to completed. If the task has been marked as completed, the function awards experience points (EXP) based on the priority level of the task.

**EXP Calculation**:
- Priority 1, Urgent and Important: +50 EXP
- Priority 2, Urgent but Not Important: +40 EXP
- Priority 3, Not Urgent but Important : +30 EXP
- Priority 4, Not Urgent and Not Important: +10 EXP

**Steps**:
- Retrieve the `userId` from the updated task document.
- Check if the task has changed from incomplete to complete.
- Use a Firestore transaction to update the user's EXP in the `users` collection.

**Logs**:
- Logs success messages when EXP is added.
- Logs errors if any issues occur during the transaction.

### 2. `updateExpForPomodoro`

**Trigger Type**: Firestore `onDocumentUpdated`

**Trigger Location**: `pomodoro_sessions/{sessionId}`

**Description**: This function is triggered when a document in the `pomodoro_sessions` collection is updated. It checks whether the Pomodoro session status has changed to completed. If it is completed, the function awards the user with 25 EXP.

**Steps**:
- Retrieve the `userId` from the updated Pomodoro session document.
- Check if the session status has changed from incomplete to complete.
- Use a Firestore transaction to update the user's EXP in the `users` collection.

**Logs**:
- Logs success messages when EXP is added.
- Logs errors if any issues occur during the transaction.

### 3. `addInventoryOnItemPurchase`

**Trigger Type**: Firestore `onDocumentCreated`

**Trigger Location**: `purchases/{purchaseId}`

**Description**: This function is triggered when a new document is created in the `purchases` collection. It adds the purchased item to the user's inventory.

**Steps**:
- Retrieve the `userId` and `itemId` from the purchase document.
- Check if the user already owns the item by querying the `inventory` sub-collection under the user.
- If the user doesn't already own the item, retrieve the item details from the `items` collection.
- Add the item to the user's `inventory` sub-collection with details such as `itemId`, `name`, `itemCategory`, `img`, and `purchaseDate`.

**Logs**:
- Logs success messages when the item is added to the inventory.
- Logs errors if any issues occur during the process.
