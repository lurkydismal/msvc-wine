#!/usr/bin/env fish

# Copyright (c) 2019 Martin Storsjo
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# Usage:
#   set -x BIN <path-to-msvc-wine-install>/bin/x64
#   source ./msvcenv-native.fish

if not set -q BIN
    echo "Set BIN to point to the directory before launching"
else
    set ENV "$BIN/msvcenv.sh"

    if not test -f "$ENV"
        echo "$ENV doesn't exist"
    else
        set -gx INCLUDE (
            bash -c ". \"$ENV\" && /usr/bin/env echo \"\$INCLUDE\"" \
            | sed 's/z://g' \
            | sed 's#\\\\#/#g'
        )

        set -gx LIB (
            bash -c ". \"$ENV\" && /usr/bin/env echo \"\$LIB\"" \
            | sed 's/z://g' \
            | sed 's#\\\\#/#g'
        )

        set MSVCARCH (
            bash -c ". \"$ENV\" && /usr/bin/env echo \"\$ARCH\""
        )

        switch $MSVCARCH
            case x86
                set TARGET_ARCH i686
            case x64
                set TARGET_ARCH x86_64
            case arm
                set TARGET_ARCH armv7
            case arm64
                set TARGET_ARCH aarch64
        end

        set -gx TARGET_TRIPLE "$TARGET_ARCH-windows-msvc"
    end
end
