## 1.0.0-alpha-4

**New Features:**

* **Low Health Alert:**
    - Added an audible alert that plays a distinct sound when your health is below 35%
* **Low Mana Alert:**
    - Implemented a similar audible alert that triggers when your mana is below 20%
* **Cooldown Tracker:**
    - Introduced a dynamic cooldown tracker that monitors all spells with cooldown exceeding 3 seconds
    - Plays a notification sound and displays a temporary on-screen text alert when abilities become available
* **Aggro Tracker (Tank & DPS):**
    - Integrated an aggro tracker that provides real-time feedback on your threat status
    - Displays different coloured text messages to indicate your threat status
        - Tank: Aggro, Losing Aggro, Gaining Aggro, No Aggro
        - Other Roles: Aggro, Losing Aggro, Gaining Aggro, No Aggro

**Improvements:**

* **Code Optimization:** Refactored various parts of the code for improved performance
* **Error Handling:** Added error catching to prevent run-on errors
* **UI Polish:** Enhanced the visual presentation of alert messages

**Known Issues:**

* **Threat Transition Tracking:** The current aggro tracker for tanks does not distinguish between smooth and sudden threat transitions, nor does it recognise off-tank status. This will be addressed in a future release.
* **Customisation Options:** The planned configuration and customisation options are not yet implemented
* **Pet Tracking:** Pet health tracking and alerts are in development, so expect bugs when it comes to this.

**Additional Notes:**

* This is an alpha release, so expect further changes and improvements