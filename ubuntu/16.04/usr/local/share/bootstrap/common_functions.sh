#!/bin/bash

as_user() {
  local COMMAND="$1"
  local WORKING_DIR="$2"
  local USER="$3"
  if [ -z "$COMMAND" ]; then
    return 1;
  fi
  if [ -z "$WORKING_DIR" ]; then
    WORKING_DIR='/app';
  fi
  if [ -z "$USER" ]; then
    USER='build';
  fi

  sudo -u "$USER" -E HOME="$(getent passwd "$USER" | cut -d: -f 6)" /bin/bash -c "cd '$WORKING_DIR'; $COMMAND"
}

as_build() {
  as_user "$1" "$2" 'build'
}

as_code_owner() {
  as_user "$1" "$2" "$CODE_OWNER"
}

is_hem_project() {
  if [ -f /app/tools/hem/config.yaml ] || [ -f /app/tools/hobo/config.yaml ]; then
    return 0
  fi

  return 1
}

is_nfs() {
  # Determine if the app directory is an NFS mountpoint, which doesn't allow chowning.
  grep -q "/app nfs " /proc/mounts
  return $?
}
