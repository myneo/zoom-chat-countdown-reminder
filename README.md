# Zoom Countdown Bot

An open-source automation tool for Zoom hosts. This lightweight bot sends scheduled countdown messages into the Zoom Chat (e.g., "Meeting starts in 5 minutes"), ensuring your audience is engaged and informed before the event begins.

## Features

* **Smart Sync:** Automatically aligns message timing with the clock (e.g., a 5-minute interval will always fire at :00, :05, :10).
* **Visual Timer:** A large green countdown display showing exactly when the next message will be sent.
* **Custom Placeholders:** Use `{min}` in your text to dynamically insert the remaining minutes.
* **Auto-Stop:** Automatically sends a final "Starting Now" message and stops itself when the target time is reached.
* **Multi-Language Support:** Fully supports English, Chinese, and other character sets.

## Installation & Usage

### Option 1: Run from Source (Recommended for Developers)
1.  Download and install [AutoHotkey v2](https://www.autohotkey.com/).
2.  Download `ZoomCountdownBot.ahk` from this repository.
3.  Double-click the file to run.

### Option 2: Standalone App
(If you compile the script into an .exe, users can run it without installing AutoHotkey).

## How to Use

1.  **Open Zoom:** Start your meeting.
2.  **OPEN CHAT PANEL:** Click "Chat" in Zoom to open the sidebar. **You must keep this sidebar open and attached** while the bot is running.
3.  **Run the Bot:** Open `ZoomCountdownBot`.
4.  **Set Time:** Enter the meeting start time in 24-hour format (e.g., `2000` for 8:00 PM).
5.  **Set Interval:** Choose how often messages should be sent (e.g., every `5` minutes).
6.  **Customize Message:** Edit the default text. Use `{min}` where you want the countdown number to appear.
7.  **Click Start:** The bot will calculate the next sync point and begin the countdown.

> **⚠️ Important:** This bot uses simulated keystrokes. It requires the Zoom Chat panel to be visible to type the message successfully. Do not close the chat sidebar while the bot is active.

## License
MIT License. Free to use and modify.
