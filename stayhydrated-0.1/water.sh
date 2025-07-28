#!/bin/bash

# Water Wave Timer 🌊
# A Gen Z-inspired Pomodoro timer with multiple session types and .wav sound

# Default durations (in seconds)
SPLASH_SESSION=$((25 * 60))  # 25 minutes
TIDAL_WAVE=$((50 * 60))      # 50 minutes
AQUA_MARATHON=$((90 * 60))   # 90 minutes
BREAK_TIME=$((5 * 60))       # 5 minutes
WAVES_CAUGHT=0
IS_WORK_SESSION=true
RUNNING=true
WORK_SESSION_TYPE="Splash Session"
WORK_TIME=$SPLASH_SESSION
SOUND_FILE="/usr/share/water-timer/wave_crash.wav"

# ASCII art for water vibe
WATER_ART="
🌊  Water Wave Timer  🌊
   Let's catch this wave!
   ~ Stay hydrated, slay ~
"

# Function to format time (MM:SS)
format_time() {
  local seconds=$1
  local mins=$((seconds / 60))
  local secs=$((seconds % 60))
  printf "%02d:%02d" $mins $secs
}

# Function to display timer
run_timer() {
  local duration=$1
  local session_type=$2
  local seconds_left=$duration

  while [ $seconds_left -gt 0 ] && [ "$RUNNING" = true ]; do
    clear
    echo "$WATER_ART"
    echo "Session: $session_type"
    echo "Time Left: $(format_time $seconds_left)"
    echo "Waves Caught: $WAVES_CAUGHT"
    sleep 1
    ((seconds_left--))
  done
}

# Function to play sound
play_sound() {
  if command -v aplay >/dev/null 2>&1 && [ -f "$SOUND_FILE" ]; then
    aplay "$SOUND_FILE" >/dev/null 2>&1
  else
    echo -e "\a"  # Fallback to beep
    echo "Debug: Fallback beep used; aplay or $SOUND_FILE missing"
  fi
}

# Function to handle session end with sound
session_end() {
  local session_type=$1
  play_sound
  if [ "$session_type" = "Splash Session" ] || [ "$session_type" = "Tidal Wave" ] || [ "$session_type" = "Aqua Marathon" ]; then
    ((WAVES_CAUGHT++))
    echo "You SLAYED that $session_type, bestie! 🌊 Time for a Hydration Break. 😎"
    echo "Waves Caught: $WAVES_CAUGHT"
    IS_WORK_SESSION=false
  else
    echo "No cap, your Hydration Break’s done! Let’s catch another $WORK_SESSION_TYPE! 💅"
    IS_WORK_SESSION=true
  fi
  echo "Press Enter to continue, or Ctrl+C to quit."
  read -r
}

# Trap Ctrl+C to stop script gracefully
handle_sigint() {
  echo -e "Peace out, water warrior! 🌊"
  RUNNING=false
  exit 0
}
trap 'handle_sigint' SIGINT

# Check if script is sourced
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
  echo "Error: This script should not be sourced. Run it with './water_timer.sh' or 'bash water_timer.sh'."
  return 1
fi

# Parse command-line arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --splash-session)
      WORK_SESSION_TYPE="Splash Session"
      WORK_TIME=$SPLASH_SESSION
      shift
      ;;
    --tidal-wave)
      WORK_SESSION_TYPE="Tidal Wave"
      WORK_TIME=$TIDAL_WAVE
      shift
      ;;
    --aqua-marathon)
      WORK_SESSION_TYPE="Aqua Marathon"
      WORK_TIME=$AQUA_MARATHON
      shift
      ;;
    -b)
      BREAK_TIME=$(( $2 * 60 ))
      shift 2
      ;;
    *)
      echo "Usage: $0 [--splash-session | --tidal-wave | --aqua-marathon] [-b break_minutes]"
      echo "Example: $0 --tidal-wave -b 10"
      exit 1
      ;;
  esac
done

# Main loop
clear
echo "$WATER_ART"
echo "Starting Water Wave Timer! Work ($WORK_SESSION_TYPE): $(format_time $WORK_TIME), Break: $(format_time $BREAK_TIME)"
echo "Press Ctrl+C to quit anytime."

while [ "$RUNNING" = true ]; do
  if [ "$IS_WORK_SESSION" = true ]; then
    run_timer $WORK_TIME "$WORK_SESSION_TYPE"
    if [ "$RUNNING" = true ]; then
      session_end "$WORK_SESSION_TYPE"
    fi
  else
    run_timer $BREAK_TIME "Hydration Break"
    if [ "$RUNNING" = true ]; then
      session_end "Hydration Break"
    fi
  fi
done
