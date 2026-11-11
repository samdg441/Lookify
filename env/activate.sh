#!/usr/bin/env bash
# Project-local Flutter and Android tools.
# Usage, from the repository root:
#   source env/activate.sh
#
# Pins the shell to the Flutter SDK that FVM linked in .fvm/ and to the
# Android SDK already installed for this user. It does not install packages,
# change groups, or touch a Flutter SDK outside this project.

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  echo "Source this file so the variables stay in your shell: source env/activate.sh" >&2
  exit 1
fi

_lookify_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
_lookify_flutter="${_lookify_root}/.fvm/flutter_sdk"
_lookify_android="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-${HOME}/Android/Sdk}}"

if [[ ! -x "${_lookify_flutter}/bin/flutter" ]]; then
  echo "Flutter is not pinned yet. From the repository root run: fvm use" >&2
  return 1
fi

if [[ ! -d "${_lookify_android}/platform-tools" ]]; then
  echo "Android SDK not found at ${_lookify_android}" >&2
  return 1
fi

export ANDROID_SDK_ROOT="${_lookify_android}"
export ANDROID_HOME="${_lookify_android}"
export FLUTTER_ROOT="${_lookify_flutter}"
export PATH="${_lookify_flutter}/bin:${_lookify_android}/platform-tools:${PATH}"

echo "Lookify env: $(flutter --version | head -n 1)"
echo "Android SDK: ${ANDROID_HOME}"

unset _lookify_root _lookify_flutter _lookify_android
