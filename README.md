# Zoom Countdown Bot

An open-source automation tool for Zoom hosts. This lightweight bot sends scheduled countdown messages into the Zoom Chat (e.g., "Meeting starts in 5 minutes"), ensuring your audience is engaged and informed before the event begins.

## Features

* **Smart Sync:** Automatically aligns message timing with the clock (e.g., a 5-minute interval will always fire at :00, :05, :10).
* **Visual Timer:** A large green countdown display showing exactly when the next message will be sent.
* **Custom Placeholders:** Use `{min}` in your text to dynamically insert the remaining minutes.
* **Auto-Stop:** Automatically sends a final "Starting Now" message and stops itself when the target time is reached.
* **Multi-Language Support:** Fully supports English, Chinese, and other character sets.

## Installation & Usage

### Option 1: Run form Source (Recommended for Developers)
1.  Download and install [AutoHotkey v2](https://www.autohotkey.com/).
2.  Download `ZoomCountdownBot.ahk` from this repository.
3.  Double-click the file to run.

### Option 2: Standalone App
(If you compile the script into an .exe, users can run it without installing AutoHotkey).

## How to Use

1.  **Open Zoom:** Start your meeting and **open the Chat panel** (ensure it is attached to the side, not popped out).
2.  **Run the Bot:** Open `ZoomCountdownBot`.
3.  **Set Time:** Enter the meeting start time in 24-hour format (e.g., `2000` for 8:00 PM).
4.  **Set Interval:** Choose how often messages should be sent (e.g., every `5` minutes).
5.  **Customize Message:** Edit the default text. Make sure to keep `{min}` if you want the countdown number to appear.
6.  **Click Start:** The bot will calculate the next sync point and begin the countdown.

**⚠️ Important Note:** This bot uses simulated keystrokes. Please keep the Zoom Chat panel open and visible while the bot is running.

## License
MIT License. Free to use and modify.
