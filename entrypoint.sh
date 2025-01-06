#!/bin/bash
set -euo pipefail

# Function to create and set permissions for the log directory
create_log_dir() {
  echo "Creating log directory: ${SQUID_LOG_DIR}"
  mkdir -p "${SQUID_LOG_DIR}"
  chmod -R 755 "${SQUID_LOG_DIR}"
  chown -R "${SQUID_USER}:${SQUID_USER}" "${SQUID_LOG_DIR}"
}

# Function to create and set permissions for the cache directory
create_cache_dir() {
  echo "Creating cache directory: ${SQUID_CACHE_DIR}"
  mkdir -p "${SQUID_CACHE_DIR}"
  chmod -R 755 "${SQUID_CACHE_DIR}"
  chown -R "${SQUID_USER}:${SQUID_USER}" "${SQUID_CACHE_DIR}"
}

# Ensure log and cache directories are properly configured
create_log_dir
create_cache_dir

# Check for command-line arguments
EXTRA_ARGS=""
if [[ $# -gt 0 ]]; then
  case "$1" in
    -*) 
      # Pass additional flags to Squid
      EXTRA_ARGS="$@"
      ;;
    squid|$(which squid))
      # Handle if Squid is directly invoked with additional arguments
      EXTRA_ARGS="${@:2}"
      ;;
    *)
      # Execute the provided command if it's not related to Squid
      exec "$@"
      ;;
  esac
fi

# Initialize Squid cache if not already initialized
if [[ ! -d "${SQUID_CACHE_DIR}/00" ]]; then
  echo "Initializing Squid cache..."
  $(which squid) -N -f /etc/squid/squid.conf -z
fi

# Start Squid with provided or default configuration
echo "Starting Squid..."
exec $(which squid) -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
