"""Builds a C harness of tools/alttp against zelda3 (roadmap F6b).

  python tools/alttp/build.py musicdump            # writes tools/alttp/out/musicdump.exe
  python tools/alttp/build.py roomdump sprdump     # several at once
  python tools/alttp/build.py musicdump --force    # rebuild even if the exe is newer than the sources

A harness is compiled together with zelda3's src/*.c and snes/*.c, minus the files that need SDL, OpenGL or the
config reader (src/main.c, src/config.c, src/opengl.c, src/glsl_shader.c); tools/alttp/stub/ stands in for what
they and the opus library would give. The compiler is the first one found: gcc, clang, or zig's clang from the
"ziglang" Python package (python -m pip install --user ziglang, no installer and no admin rights). The harnesses
read zelda3_assets.dat from the current folder: run them from the zelda3 folder, after zelda3's own asset step
(python assets/restool.py --extract-from-rom, which needs PyYAML and Pillow). zelda3 is looked for in $ZELDA3_DIR or
in the zelda3 folder next to the repository (--zelda3 to change). Standard library only.
"""
import argparse
import glob
import os
import shutil
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(os.path.dirname(HERE))
OUT = os.path.join(HERE, 'out')
LEAVE_OUT = {'src/main.c', 'src/config.c', 'src/opengl.c', 'src/glsl_shader.c'}


def zelda3_dir(arg=None):
    d = arg or os.environ.get('ZELDA3_DIR') or os.path.join(os.path.dirname(REPO), 'zelda3')
    if not os.path.isfile(os.path.join(d, 'src', 'zelda_rtl.c')):
        sys.exit('zelda3 not found at %s (set ZELDA3_DIR or pass --zelda3; ask Guilherme for it)' % d)
    return os.path.abspath(d)


def compiler():
    for c in ('gcc', 'clang'):
        if shutil.which(c):
            return [c]
    try:
        import ziglang  # noqa: F401
        return [sys.executable, '-m', 'ziglang', 'cc']
    except ImportError:
        sys.exit('no C compiler: install one, or python -m pip install --user ziglang')


def exe_path(name):
    return os.path.join(OUT, name + ('.exe' if os.name == 'nt' else ''))


def build(name, zdir, force=False):
    src = os.path.join(HERE, name + '.c')
    if not os.path.isfile(src):
        sys.exit('no harness %s.c in tools/alttp' % name)
    zsrc = sorted(p for p in glob.glob(os.path.join(zdir, 'src', '*.c')) + glob.glob(os.path.join(zdir, 'snes', '*.c'))
                  if os.path.relpath(p, zdir).replace(os.sep, '/') not in LEAVE_OUT)
    stub = os.path.join(HERE, 'stub')
    inputs = [src, os.path.join(stub, 'stubs.c')] + zsrc
    newest = max(os.path.getmtime(p) for p in inputs + glob.glob(os.path.join(stub, '*.h')))
    exe = exe_path(name)
    if not force and os.path.exists(exe) and os.path.getmtime(exe) > newest:
        return exe
    os.makedirs(OUT, exist_ok=True)
    cmd = compiler() + ['-O2', '-w', '-I', zdir, '-I', os.path.join(zdir, 'src'), '-I', stub, '-o', exe] + inputs
    r = subprocess.run(cmd, cwd=zdir, capture_output=True, text=True)
    if r.returncode:
        sys.exit('build of %s failed:\n%s' % (name, '\n'.join((r.stdout + r.stderr).splitlines()[:30])))
    return exe


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('names', nargs='+')
    ap.add_argument('--zelda3')
    ap.add_argument('--force', action='store_true')
    args = ap.parse_args()
    zdir = zelda3_dir(args.zelda3)
    for n in args.names:
        print(os.path.relpath(build(n, zdir, args.force), REPO).replace(os.sep, '/'))


if __name__ == '__main__':
    main()
