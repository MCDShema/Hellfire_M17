#!/bin/sh
LOG="/sdcard/diablo.log"
echo "=== Hellfire.sh started at $(date) ===" > $LOG

GAME_DIR="/storage/roms/ports/diablo"
[ ! -d "$GAME_DIR" ] && GAME_DIR="/sdcard/roms/ports/diablo"

# First-time automatic setup: recombine split diabdat.mpq if present
if [ ! -f "$GAME_DIR/diabdat.mpq" ] && [ -f "$GAME_DIR/diabdat.mpq.partaa" ]; then
    echo "First launch: Recombining diabdat.mpq from parts..." >> $LOG
    cat "$GAME_DIR"/diabdat.mpq.part* > "$GAME_DIR/diabdat.mpq"
    rm -f "$GAME_DIR"/diabdat.mpq.part*
fi

for l in \
    "$GAME_DIR" \
    "/storage/emuelec/lib32" \
    "/sdcard/emuelec/lib32" \
    "/emuelec/lib32" \
    "/storage/emus/drastic/libs" \
    "/sdcard/emus/drastic/libs" \
    "/usr/lib" \
    "/lib"
do
    if [ -d "$l" ]; then
        export LD_LIBRARY_PATH="$l:$LD_LIBRARY_PATH"
    fi
done

if [ -f "$GAME_DIR/libsdl_compat.so" ]; then
    export LD_PRELOAD="$GAME_DIR/libsdl_compat.so"
elif [ -f "/storage/roms/ports/diablo/libsdl_compat.so" ]; then
    export LD_PRELOAD="/storage/roms/ports/diablo/libsdl_compat.so"
elif [ -f "/sdcard/roms/ports/diablo/libsdl_compat.so" ]; then
    export LD_PRELOAD="/sdcard/roms/ports/diablo/libsdl_compat.so"
elif [ -f "/storage/emuelec/lib32/libsdl_compat.so" ]; then
    export LD_PRELOAD="/storage/emuelec/lib32/libsdl_compat.so"
fi
echo "Configured LD_PRELOAD=$LD_PRELOAD" >> $LOG

DEVIL_BIN=""
if [ -f "$GAME_DIR/devilutionx" ]; then
    chmod +x "$GAME_DIR/devilutionx" 2>/dev/null
    DEVIL_BIN="$GAME_DIR/devilutionx"
fi
if [ -z "$DEVIL_BIN" ]; then
    for b in \
        "/storage/.emulationstation/emuelec/bin/devilutionx" \
        "/sdcard/.emulationstation/emuelec/bin/devilutionx" \
        "/emuelec/bin/devilutionx" \
        "/storage/emuelec/bin/devilutionx" \
        "/sdcard/emuelec/bin/devilutionx"
    do
        if [ -f "$b" ]; then
            DEVIL_BIN="$b"
            break
        fi
    done
fi

killall -9 m17_diablo_mapper 2>/dev/null
sleep 1

chmod +x "$GAME_DIR/m17_diablo_mapper" 2>/dev/null
"$GAME_DIR/m17_diablo_mapper" &
MAPPER_PID=$!
sleep 2

if [ -e /dev/input/js2 ]; then
    rm -f /dev/input/js0 2>/dev/null
    ln -sf /dev/input/js2 /dev/input/js0
    echo "Linked js2 -> js0" >> $LOG
elif [ -e /dev/input/js1 ]; then
    rm -f /dev/input/js0 2>/dev/null
    ln -sf /dev/input/js1 /dev/input/js0
    echo "Linked js1 -> js0" >> $LOG
fi

export SDL_JOYSTICK_DEVICE=/dev/input/js0
export SDL_GAMECONTROLLERCONFIG="03000000341200007856000001000000,M17 Diablo Controller,platform:Linux,a:b0,b:b1,x:b2,y:b3,back:b8,start:b9,leftshoulder:b4,rightshoulder:b5,lefttrigger:b6,righttrigger:b7,dpup:b10,dpdown:b11,dpleft:b12,dpright:b13,leftx:a0,lefty:a1,"
export SDL_GAMECONTROLLERCONFIG_FILE="$GAME_DIR/gamecontrollerdb.txt"

mkdir -p /storage/.local/share/diasurgical/devilution 2>/dev/null
mkdir -p /sdcard/.local/share/diasurgical/devilution 2>/dev/null
mkdir -p "$HOME/.local/share/diasurgical/devilution" 2>/dev/null

for mpq in "$GAME_DIR"/*.mpq "$GAME_DIR"/*.MPQ; do
    if [ -f "$mpq" ]; then
        fname=$(basename "$mpq" | tr '[:upper:]' '[:lower:]')
        ln -sf "$mpq" "/storage/.local/share/diasurgical/devilution/$fname" 2>/dev/null
        ln -sf "$mpq" "/sdcard/.local/share/diasurgical/devilution/$fname" 2>/dev/null
    fi
done

cp "$GAME_DIR/gamecontrollerdb.txt" /storage/.local/share/diasurgical/devilution/ 2>/dev/null || true
cp "$GAME_DIR/gamecontrollerdb.txt" /sdcard/.local/share/diasurgical/devilution/ 2>/dev/null || true
cp "$GAME_DIR/diablo.ini" /storage/.local/share/diasurgical/devilution/ 2>/dev/null || true
cp "$GAME_DIR/diablo.ini" /sdcard/.local/share/diasurgical/devilution/ 2>/dev/null || true

# Scan internal console storage for any saved games
for d in \
    "/storage/.local/share/diasurgical/devilution" \
    "/sdcard/.local/share/diasurgical/devilution" \
    "$HOME/.local/share/diasurgical/devilution" \
    "/storage/.config/diasurgical/devilution" \
    "/root/.local/share/diasurgical/devilution"
do
    if [ -d "$d" ]; then
        echo "Found internal dir: $d" >> $LOG
        ls -la "$d" >> $LOG 2>&1
        for s in "$d"/*.sv "$d"/*.hsv; do
            if [ -f "$s" ] && [ ! -L "$s" ]; then
                echo "Found internal save: $s" >> $LOG
                cp -n "$s" "$GAME_DIR/internal_backup_$(basename "$s")" 2>/dev/null
            fi
        done
    fi
done

# Safety check: restore corrupted saves (<50000 bytes) and update backups
mkdir -p "$GAME_DIR/backup_saves" 2>/dev/null
for s in "$GAME_DIR"/single_*.hsv; do
    [ ! -f "$s" ] && continue
    sbak="${s}.bak"
    fsize=$(wc -c < "$s" 2>/dev/null || echo 0)
    if [ "$fsize" -lt 50000 ] && [ -f "$sbak" ]; then
        baksize=$(wc -c < "$sbak" 2>/dev/null || echo 0)
        if [ "$baksize" -gt 50000 ]; then
            echo "Auto-recovering $s from $sbak ($baksize bytes)..." >> $LOG
            cp "$sbak" "$s" 2>/dev/null
        fi
    elif [ "$fsize" -gt 50000 ]; then
        cp "$s" "$sbak" 2>/dev/null
        cp "$s" "$GAME_DIR/backup_saves/$(basename "$s")" 2>/dev/null
    fi
done

cd "$GAME_DIR" || cd /storage/roms/ports/diablo || cd /sdcard/roms/ports/diablo

chmod +x "$DEVIL_BIN" 2>/dev/null

echo "Starting devilutionx (Hellfire mode) using $DEVIL_BIN..." >> $LOG
"$DEVIL_BIN" --hellfire --data-dir "$GAME_DIR" --save-dir "$GAME_DIR" --config-dir "$GAME_DIR" >> $LOG 2>&1
ret=$?
echo "devilutionx exited with code $ret" >> $LOG

# Backup all valid saves after play
sync
mkdir -p "$GAME_DIR/backup_saves" 2>/dev/null
mkdir -p /storage/.local/share/diasurgical/devilution 2>/dev/null
for s in "$GAME_DIR"/single_*.hsv; do
    [ ! -f "$s" ] && continue
    fsize=$(wc -c < "$s" 2>/dev/null || echo 0)
    if [ "$fsize" -gt 50000 ]; then
        cp "$s" "${s}.bak" 2>/dev/null
        cp "$s" "$GAME_DIR/backup_saves/$(basename "$s")" 2>/dev/null
        cp "$s" /storage/.local/share/diasurgical/devilution/ 2>/dev/null || true
    fi
done
sync

unset LD_PRELOAD
kill -9 $MAPPER_PID 2>/dev/null
sync
