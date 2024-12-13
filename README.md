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

**Description**: This function is triggered when a document in the `eisenhower_tasks` collection is updated. It checks whether the task status has changed to completed. If the task has been marked as completed, the function awards experience points (EXP) and coins based on the priority level of the task.

**EXP Calculation**:
- ("urgent important")Priority 1, Urgent and Important: +50 EXP, +50 Coins
- ("urgent not-important")Priority 2, Urgent but Not Important: +40 EXP, +40 Coins
- ("not-urgent important")Priority 3, Not Urgent but Important: +30 EXP, +30 Coins
- ("not-urgent not-important")Priority 4, Not Urgent and Not Important: +10 EXP, +10 Coins

**Steps**:
- Retrieve the `userId` from the updated task document.
- Check if the task has changed from incomplete to complete.
- Use a Firestore transaction to update the user's EXP and coin balance in the `users` collection.

**Logs**:
- Logs success messages when EXP is added.
- Logs errors if any issues occur during the transaction.

### 2. `onUserDocumentCreated`

**Trigger Type**: Firestore `onDocumentCreated`

**Trigger Location**: `users/{userId}`

**Description**: This function is triggered when a new document is created in the `users` collection. It initializes the user's inventory with a predefined default item.

**Steps**:
- Retrieve the `userId` from the document path and the document data.
- Retrieve the details of the default item from the `items` collection using its `itemId`.
- Add the default item to the inventory sub-collection under the user document. The item details include:
    - itemId
    - name
    - itemCategory
    - img
    - purchaseDate

**Default Item**:
- ID: q5VB4nGIAH4G9J3c2UrY (Oruka).

**Logs**:
- Logs success messages when the default item is added to the user's inventory.
- Logs errors if the default item is missing or any issues occur during the process.

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
