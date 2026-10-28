"""Takes an ALttP sound effect out of the ROM as a .wav (roadmap F6b).

  python tools/alttp/sfx.py 2 0x36 incoming/topo-do-castelo/sounds/Thunder.wav     # the thunder of the rain
  python tools/alttp/sfx.py 1 0x01 incoming/x/sounds/Rain_Loop.wav --seconds 4      # the rain, an ambient loop
  python tools/alttp/sfx.py 2 0x36 out.wav --rate 44100 --stereo                    # keep the render as it comes

<port> is the APU port the game writes the effect to: 1 the ambient sounds (sound_effect_ambient: rain 0x01, ...),
2 sound_effect_1, 3 sound_effect_2. The number is the one the zelda3 source writes (e.g. src/overworld.c,
OverworldOverlay_HandleRain: sound_effect_1 = 54, which is 0x36). The effect is rendered by tools/alttp/musicdump.c
in its effect mode (built by build.py if needed) through zelda3's SPC emulation, then the silence before and after is
cut. An ambient loop never ends by itself, so it is cut at --seconds. By default the .wav is mono at 22050 Hz, like
the sound effects the game already has (Sound_Rain); then incoming/<region>/sounds/ and import_region.py make it a
Sound_<Name>. Standard library only.
"""
import argparse
import array
import os
import subprocess
import sys
import wave

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import build  # noqa: E402

RATE = 44100            # musicdump renders 16-bit stereo at 44100 Hz
SILENT = 64             # samples below this count as silence when trimming


def render(port, sfx, seconds, zdir):
    exe = build.build('musicdump', zdir)
    if not os.path.isfile(os.path.join(zdir, 'zelda3_assets.dat')):
        sys.exit('no zelda3_assets.dat in %s: run python assets/restool.py --extract-from-rom there first' % zdir)
    pcm = os.path.join(build.OUT, 'sfx_%d_%02x.pcm' % (port, sfx))
    r = subprocess.run([exe, 'sfx', str(port), str(sfx), str(seconds), pcm], cwd=zdir, capture_output=True, text=True)
    if r.returncode:
        sys.exit('musicdump failed: %s' % (r.stdout + r.stderr).strip())
    a = array.array('h')
    a.frombytes(open(pcm, 'rb').read())
    os.remove(pcm)
    return a


def trim(a, loop):
    loud = [i for i in range(0, len(a), 2) if abs(a[i]) >= SILENT or abs(a[i + 1]) >= SILENT]
    if not loud:
        sys.exit('the effect is silent: check the port and the number')
    start = loud[0]
    end = len(a) if loop else loud[-1] + 2
    return a[start:end]


def write(a, dst, rate, stereo):
    if not stereo:
        a = array.array('h', ((a[i] + a[i + 1]) // 2 for i in range(0, len(a), 2)))
    ch = 2 if stereo else 1
    if rate != RATE:
        step = RATE / rate
        n = int(len(a) // ch / step)
        a = array.array('h', (a[int(i * step) * ch + c] for i in range(n) for c in range(ch)))
    os.makedirs(os.path.dirname(os.path.abspath(dst)), exist_ok=True)
    w = wave.open(dst, 'wb')
    w.setnchannels(ch)
    w.setsampwidth(2)
    w.setframerate(rate)
    w.writeframes(a.tobytes())
    w.close()
    return len(a) / ch / rate


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('port', type=int, choices=[1, 2, 3])
    ap.add_argument('sfx', type=lambda v: int(v, 0))
    ap.add_argument('out')
    ap.add_argument('--seconds', type=int, default=6, help='render length (an ambient loop is cut here)')
    ap.add_argument('--rate', type=int, default=22050)
    ap.add_argument('--stereo', action='store_true')
    ap.add_argument('--zelda3')
    args = ap.parse_args()
    zdir = build.zelda3_dir(args.zelda3)
    a = trim(render(args.port, args.sfx, args.seconds + 1, zdir), loop=args.port == 1)
    dur = write(a, args.out, args.rate, args.stereo)
    print('%s: %.2f s, %s, %d Hz (port %d, effect 0x%02x)' % (args.out, dur, 'stereo' if args.stereo else 'mono',
                                                              args.rate, args.port, args.sfx))


if __name__ == '__main__':
    main()
