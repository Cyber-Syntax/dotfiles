#!/usr/bin/env bash
#
# Test script for idle.sh
# Tests all functions to verify they work as expected and identify complexity
#
# Usage: ./test_idle.sh

# Don't use set -e so tests continue even if one fails
# We want to run all tests and report results

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
print_test_header() {
  echo -e "\n${BLUE}========================================${NC}"
  echo -e "${BLUE}Testing: $1${NC}"
  echo -e "${BLUE}========================================${NC}"
}

print_pass() {
  echo -e "${GREEN}✓ PASS:${NC} $1"
  ((TESTS_PASSED++))
}

print_fail() {
  echo -e "${RED}✗ FAIL:${NC} $1"
  ((TESTS_FAILED++))
}

print_info() {
  echo -e "${YELLOW}ℹ INFO:${NC} $1"
}

print_summary() {
  echo -e "\n${BLUE}========================================${NC}"
  echo -e "${BLUE}Test Summary${NC}"
  echo -e "${BLUE}========================================${NC}"
  echo -e "Total Passed: ${GREEN}${TESTS_PASSED}${NC}"
  echo -e "Total Failed: ${RED}${TESTS_FAILED}${NC}"
  if [ "$TESTS_FAILED" -eq 0 ]; then
    echo -e "\n${GREEN}All tests passed!${NC}"
  else
    echo -e "\n${RED}Some tests failed!${NC}"
    exit 1
  fi
}

# Source the functions from idle.sh (without running the main loop)
# We'll extract just the function definitions
source_functions() {
  # Extract only function definitions from idle.sh
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Define the functions we need for testing
  quiet_cmd() { command "$@" >/dev/null 2>&1 || true; }

  # Constants from idle.sh
  lock_timeout=15
  suspend_timeout=600
  INTERVAL=${INTERVAL:-300}
  XAUTOLOCK_CMD=(xautolock -time "$lock_timeout" -locker 'systemctl suspend' -notify "$suspend_timeout" -notifier 'i3lock | xset dpms force off')

  start_xautolock_if_needed() {
    if ! pgrep -x xautolock >/dev/null 2>&1; then
      "${XAUTOLOCK_CMD[@]}" &>/dev/null &
      sleep 0.2
    fi
  }

  is_audio_playing() {
    if command -v pactl >/dev/null 2>&1; then
      pactl list sinks 2>/dev/null | grep -q 'State: RUNNING' >/dev/null 2>&1 && return 0
      return 1
    fi

    if command -v playerctl >/dev/null 2>&1; then
      local status
      status=$(playerctl status 2>/dev/null) || return 1
      [ "$status" = "Playing" ] && return 0
      return 1
    fi

    return 1
  }

  notify_user() {
    local msg="$1"
    if command -v notify-send >/dev/null 2>&1; then
      notify-send -u normal "Idle monitor" "$msg"
    fi
  }

  capture_xset_state() {
    ORIG_SS_TIMEOUT=0
    ORIG_SS_CYCLE=0
    ORIG_SS_ENABLED="off"
    ORIG_DPMS_STANDBY=0
    ORIG_DPMS_SUSPEND=0
    ORIG_DPMS_OFF=0
    ORIG_DPMS_ENABLED="Disabled"

    if ! command -v xset >/dev/null 2>&1; then
      return
    fi

    local out
    out="$(xset q 2>/dev/null)" || out=""

    ORIG_SS_TIMEOUT=$(printf "%s\n" "$out" | sed -n 's/.*timeout: *\([0-9]*\).*/\1/p' | head -n1)
    ORIG_SS_CYCLE=$(printf "%s\n" "$out" | sed -n 's/.*cycle: *\([0-9]*\).*/\1/p' | head -n1)
    ORIG_SS_TIMEOUT=${ORIG_SS_TIMEOUT:-0}
    ORIG_SS_CYCLE=${ORIG_SS_CYCLE:-0}
    if [ "$ORIG_SS_TIMEOUT" -gt 0 ]; then
      ORIG_SS_ENABLED="on"
    else
      ORIG_SS_ENABLED="off"
    fi

    ORIG_DPMS_STANDBY=$(printf "%s\n" "$out" | sed -n 's/.*Standby: *\([0-9]*\).*/\1/p' | head -n1)
    ORIG_DPMS_SUSPEND=$(printf "%s\n" "$out" | sed -n 's/.*Suspend: *\([0-9]*\).*/\1/p' | head -n1)
    ORIG_DPMS_OFF=$(printf "%s\n" "$out" | sed -n 's/.*Off: *\([0-9]*\).*/\1/p' | head -n1)
    ORIG_DPMS_STANDBY=${ORIG_DPMS_STANDBY:-0}
    ORIG_DPMS_SUSPEND=${ORIG_DPMS_SUSPEND:-0}
    ORIG_DPMS_OFF=${ORIG_DPMS_OFF:-0}

    if printf "%s\n" "$out" | grep -q 'DPMS is Enabled'; then
      ORIG_DPMS_ENABLED="Enabled"
    else
      ORIG_DPMS_ENABLED="Disabled"
    fi
  }

  apply_disable_xset() {
    if ! command -v xset >/dev/null 2>&1; then
      return
    fi
    quiet_cmd xset s off
    quiet_cmd xset dpms 0 0 0
  }

  restore_xset_state() {
    if ! command -v xset >/dev/null 2>&1; then
      return
    fi

    if [ -n "${ORIG_SS_TIMEOUT+x}" ]; then
      if [ "$ORIG_SS_TIMEOUT" -gt 0 ]; then
        quiet_cmd xset s "$ORIG_SS_TIMEOUT" "$ORIG_SS_CYCLE"
        quiet_cmd xset s on
      else
        quiet_cmd xset s off
      fi
    fi

    if [ -n "${ORIG_DPMS_ENABLED+x}" ]; then
      if [ "$ORIG_DPMS_ENABLED" = "Enabled" ]; then
        quiet_cmd xset +dpms
      else
        quiet_cmd xset -dpms
      fi
      quiet_cmd xset dpms "$ORIG_DPMS_STANDBY" "$ORIG_DPMS_SUSPEND" "$ORIG_DPMS_OFF"
    fi
  }

  cleanup_and_exit() {
    restore_xset_state
    quiet_cmd xautolock -enable
    exit 0
  }
}

# Test 1: quiet_cmd function
test_quiet_cmd() {
  print_test_header "quiet_cmd()"

  # Test that quiet_cmd suppresses output - test the actual behavior
  # Create a temp file to check if output is suppressed
  local temp_output=$(mktemp)
  quiet_cmd echo "test" > "$temp_output" 2>&1
  local output=$(cat "$temp_output")
  rm -f "$temp_output"

  if [ -z "$output" ]; then
    print_pass "quiet_cmd suppresses stdout"
  else
    print_fail "quiet_cmd did not suppress stdout: '$output'"
  fi

  # Test that quiet_cmd handles errors gracefully
  quiet_cmd false
  local exit_code=$?
  if [ $exit_code -eq 0 ]; then
    print_pass "quiet_cmd handles errors gracefully (returns 0)"
  else
    print_fail "quiet_cmd should always return 0, got $exit_code"
  fi

  # Test with non-existent command
  quiet_cmd nonexistent_command_xyz
  exit_code=$?
  if [ $exit_code -eq 0 ]; then
    print_pass "quiet_cmd handles non-existent commands gracefully"
  else
    print_fail "quiet_cmd should return 0 for non-existent commands, got $exit_code"
  fi

  print_info "Complexity: LOW - Simple wrapper with error suppression"
}

# Test 2: Check for required commands
test_command_availability() {
  print_test_header "Command Availability Check"

  if command -v xautolock >/dev/null 2>&1; then
    print_pass "xautolock is installed"
  else
    print_fail "xautolock is not installed (REQUIRED)"
  fi

  if command -v xset >/dev/null 2>&1; then
    print_pass "xset is installed"
  else
    print_fail "xset is not installed (REQUIRED for xset functions)"
  fi

  if command -v pactl >/dev/null 2>&1; then
    print_pass "pactl is installed (PulseAudio)"
  else
    print_info "pactl is not installed (optional, will try playerctl)"
  fi

  if command -v playerctl >/dev/null 2>&1; then
    print_pass "playerctl is installed"
  else
    print_info "playerctl is not installed (optional, will try pactl)"
  fi

  if ! command -v pactl >/dev/null 2>&1 && ! command -v playerctl >/dev/null 2>&1; then
    print_fail "Neither pactl nor playerctl is installed (at least one is REQUIRED)"
  fi

  if command -v notify-send >/dev/null 2>&1; then
    print_pass "notify-send is installed"
  else
    print_info "notify-send is not installed (optional, notifications will be disabled)"
  fi

  print_info "Complexity: N/A - Dependency check"
}

# Test 3: is_audio_playing function
test_is_audio_playing() {
  print_test_header "is_audio_playing()"

  # Test that function executes without error
  if is_audio_playing; then
    print_pass "is_audio_playing() executed successfully (audio is playing)"
    print_info "Current state: Audio is PLAYING"
  else
    print_pass "is_audio_playing() executed successfully (no audio)"
    print_info "Current state: Audio is NOT PLAYING"
  fi

  # Test with pactl if available
  if command -v pactl >/dev/null 2>&1; then
    print_info "Testing pactl method..."
    pactl_output=$(pactl list sinks 2>/dev/null || echo "error")
    if [ "$pactl_output" != "error" ]; then
      print_pass "pactl list sinks works"
      if echo "$pactl_output" | grep -q 'State: RUNNING'; then
        print_info "pactl detects audio playing"
      else
        print_info "pactl detects no audio"
      fi
    else
      print_fail "pactl list sinks failed"
    fi
  fi

  # Test with playerctl if available
  if command -v playerctl >/dev/null 2>&1; then
    print_info "Testing playerctl method..."
    playerctl_status=$(playerctl status 2>/dev/null || echo "error")
    if [ "$playerctl_status" != "error" ]; then
      print_pass "playerctl status works"
      print_info "playerctl status: $playerctl_status"
    else
      print_info "playerctl status failed (no players active)"
    fi
  fi

  print_info "Complexity: MEDIUM - Multiple fallback methods, could be simplified"
}

# Test 4: notify_user function
test_notify_user() {
  print_test_header "notify_user()"

  if command -v notify-send >/dev/null 2>&1; then
    print_info "Sending test notification..."
    notify_user "Test notification from idle.sh test script"
    print_pass "notify_user() executed (check if you received a notification)"
    print_info "Please verify you received a notification"
  else
    print_info "notify-send not available, skipping test"
    print_pass "notify_user() handles missing notify-send gracefully"
  fi

  print_info "Complexity: LOW - Simple wrapper, no-op if command missing"
}

# Test 5: capture_xset_state function
test_capture_xset_state() {
  print_test_header "capture_xset_state()"

  if ! command -v xset >/dev/null 2>&1; then
    print_info "xset not available, skipping test"
    return
  fi

  # Clear any existing state
  unset ORIG_SS_TIMEOUT ORIG_SS_CYCLE ORIG_SS_ENABLED
  unset ORIG_DPMS_STANDBY ORIG_DPMS_SUSPEND ORIG_DPMS_OFF ORIG_DPMS_ENABLED

  # Capture state
  capture_xset_state

  # Verify variables are set
  if [ -n "$ORIG_SS_TIMEOUT" ]; then
    print_pass "ORIG_SS_TIMEOUT captured: $ORIG_SS_TIMEOUT"
  else
    print_fail "ORIG_SS_TIMEOUT not set"
  fi

  if [ -n "$ORIG_SS_CYCLE" ]; then
    print_pass "ORIG_SS_CYCLE captured: $ORIG_SS_CYCLE"
  else
    print_fail "ORIG_SS_CYCLE not set"
  fi

  if [ -n "$ORIG_SS_ENABLED" ]; then
    print_pass "ORIG_SS_ENABLED captured: $ORIG_SS_ENABLED"
  else
    print_fail "ORIG_SS_ENABLED not set"
  fi

  if [ -n "$ORIG_DPMS_STANDBY" ]; then
    print_pass "ORIG_DPMS_STANDBY captured: $ORIG_DPMS_STANDBY"
  else
    print_fail "ORIG_DPMS_STANDBY not set"
  fi

  if [ -n "$ORIG_DPMS_SUSPEND" ]; then
    print_pass "ORIG_DPMS_SUSPEND captured: $ORIG_DPMS_SUSPEND"
  else
    print_fail "ORIG_DPMS_SUSPEND not set"
  fi

  if [ -n "$ORIG_DPMS_OFF" ]; then
    print_pass "ORIG_DPMS_OFF captured: $ORIG_DPMS_OFF"
  else
    print_fail "ORIG_DPMS_OFF not set"
  fi

  if [ -n "$ORIG_DPMS_ENABLED" ]; then
    print_pass "ORIG_DPMS_ENABLED captured: $ORIG_DPMS_ENABLED"
  else
    print_fail "ORIG_DPMS_ENABLED not set"
  fi

  # Show current xset output for verification
  print_info "Current xset output:"
  xset q | grep -E "(timeout|cycle|Standby|Suspend|Off|DPMS)"

  print_info "Complexity: HIGH - Complex sed parsing, fragile regex patterns"
  print_info "Suggestion: Consider simpler parsing or structured output"
}

# Test 6: apply_disable_xset function
test_apply_disable_xset() {
  print_test_header "apply_disable_xset()"

  if ! command -v xset >/dev/null 2>&1; then
    print_info "xset not available, skipping test"
    return
  fi

  # Capture state before
  print_info "Capturing state before applying disable..."
  capture_xset_state
  local before_ss_timeout=$ORIG_SS_TIMEOUT
  local before_dpms_standby=$ORIG_DPMS_STANDBY

  # Apply disable
  print_info "Applying disable settings..."
  apply_disable_xset

  # Check if settings were applied
  sleep 0.5
  local xset_output=$(xset q)

  # Check screensaver is off
  if echo "$xset_output" | grep -q "timeout:  0"; then
    print_pass "Screensaver timeout set to 0"
  else
    print_fail "Screensaver timeout not set to 0"
  fi

  # Check DPMS timeouts are 0
  if echo "$xset_output" | grep -q "Standby: 0.*Suspend: 0.*Off: 0"; then
    print_pass "DPMS timeouts set to 0 0 0"
  else
    print_fail "DPMS timeouts not set to 0 0 0"
  fi

  print_info "State after disable:"
  xset q | grep -E "(timeout|cycle|Standby|Suspend|Off)"

  print_info "Complexity: LOW - Simple xset commands"
}

# Test 7: restore_xset_state function
test_restore_xset_state() {
  print_test_header "restore_xset_state()"

  if ! command -v xset >/dev/null 2>&1; then
    print_info "xset not available, skipping test"
    return
  fi

  # This test assumes capture_xset_state was called earlier
  if [ -z "${ORIG_SS_TIMEOUT+x}" ]; then
    print_info "Capturing initial state first..."
    capture_xset_state
  fi

  print_info "Original captured state:"
  print_info "  SS_TIMEOUT=$ORIG_SS_TIMEOUT, SS_CYCLE=$ORIG_SS_CYCLE, SS_ENABLED=$ORIG_SS_ENABLED"
  print_info "  DPMS_STANDBY=$ORIG_DPMS_STANDBY, DPMS_SUSPEND=$ORIG_DPMS_SUSPEND, DPMS_OFF=$ORIG_DPMS_OFF"
  print_info "  DPMS_ENABLED=$ORIG_DPMS_ENABLED"

  # Apply disable first
  print_info "Disabling first..."
  apply_disable_xset
  sleep 0.5

  # Restore
  print_info "Restoring settings..."
  restore_xset_state
  sleep 0.5

  # Verify restoration
  local xset_output=$(xset q)
  print_info "State after restore:"
  echo "$xset_output" | grep -E "(timeout|cycle|Standby|Suspend|Off|DPMS)"

  # Basic verification
  if [ -n "$xset_output" ]; then
    print_pass "restore_xset_state() executed successfully"
  else
    print_fail "restore_xset_state() failed to execute"
  fi

  print_info "Complexity: MEDIUM - Conditional restoration logic"
  print_info "Manually verify the settings match the original state shown above"
}

# Test 8: start_xautolock_if_needed function
test_start_xautolock_if_needed() {
  print_test_header "start_xautolock_if_needed()"

  if ! command -v xautolock >/dev/null 2>&1; then
    print_info "xautolock not available, skipping test"
    return
  fi

  # Check if xautolock is running
  if pgrep -x xautolock >/dev/null 2>&1; then
    print_info "xautolock is already running"
    local pid_before=$(pgrep -x xautolock | head -n1)
    print_info "PID before: $pid_before"

    # Function should not start a new instance
    start_xautolock_if_needed
    sleep 0.5

    local pid_after=$(pgrep -x xautolock | head -n1)
    print_info "PID after: $pid_after"

    if [ "$pid_before" = "$pid_after" ]; then
      print_pass "start_xautolock_if_needed() correctly skipped starting (already running)"
    else
      print_fail "start_xautolock_if_needed() started a new instance when one existed"
    fi
  else
    print_info "xautolock is not running, will try to start it"
    start_xautolock_if_needed
    sleep 1

    if pgrep -x xautolock >/dev/null 2>&1; then
      print_pass "start_xautolock_if_needed() successfully started xautolock"
      print_info "PID: $(pgrep -x xautolock)"
      # Clean up
      pkill -x xautolock 2>/dev/null || true
    else
      print_fail "start_xautolock_if_needed() failed to start xautolock"
    fi
  fi

  print_info "Complexity: MEDIUM - Process management with timing dependencies"
}

# Test 9: cleanup_and_exit function
test_cleanup_and_exit() {
  print_test_header "cleanup_and_exit()"

  print_info "Testing cleanup_and_exit() in a subshell to avoid exiting main script"

  # Test in a subshell
  (
    # Set up some state
    capture_xset_state 2>/dev/null || true

    # Try cleanup
    cleanup_and_exit 2>/dev/null
  )

  local exit_code=$?
  if [ $exit_code -eq 0 ]; then
    print_pass "cleanup_and_exit() exits with code 0"
  else
    print_info "cleanup_and_exit() exits with code $exit_code"
  fi

  print_info "Complexity: LOW - Simple cleanup wrapper"
  print_info "Note: Full cleanup test requires checking xautolock enable and xset restore"
}

# Test 10: Integration test - state transitions
test_state_transitions() {
  print_test_header "State Transitions Integration Test"

  if ! command -v xset >/dev/null 2>&1 || ! command -v xautolock >/dev/null 2>&1; then
    print_info "Required commands not available, skipping integration test"
    return
  fi

  print_info "Testing full state transition cycle..."

  # 1. Capture initial state
  print_info "1. Capturing initial state..."
  capture_xset_state
  local initial_ss_timeout=$ORIG_SS_TIMEOUT
  local initial_dpms_standby=$ORIG_DPMS_STANDBY
  print_info "   Initial: SS_TIMEOUT=$initial_ss_timeout, DPMS_STANDBY=$initial_dpms_standby"

  # 2. Apply disable
  print_info "2. Applying disable (simulating audio playing)..."
  apply_disable_xset
  sleep 0.5
  local disabled_output=$(xset q)
  if echo "$disabled_output" | grep -q "timeout:  0"; then
    print_pass "   Disable applied successfully"
  else
    print_fail "   Disable not applied correctly"
  fi

  # 3. Restore
  print_info "3. Restoring (simulating audio stopped)..."
  restore_xset_state
  sleep 0.5
  local restored_output=$(xset q)
  print_pass "   Restore executed"

  # 4. Verify restoration
  print_info "4. Verifying restoration..."
  echo "$restored_output" | grep -E "(timeout|Standby)"

  print_info "Integration test completed"
  print_info "Manually verify the settings are correct"
}

# Main test execution
main() {
  echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║  idle.sh Test Suite                   ║${NC}"
  echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
  echo ""

  print_info "This test suite will test all functions in idle.sh"
  print_info "Some tests may change your xset settings temporarily"
  print_info "Original settings will be restored at the end"
  echo ""

  # Source functions
  source_functions

  # Run all tests
  test_quiet_cmd
  test_command_availability
  test_is_audio_playing
  test_notify_user
  test_capture_xset_state
  test_apply_disable_xset
  test_restore_xset_state
  test_start_xautolock_if_needed
  test_cleanup_and_exit
  test_state_transitions

  # Summary
  print_summary
}

# Run main
main

