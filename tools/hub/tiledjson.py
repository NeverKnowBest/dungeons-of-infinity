# Serializer that reproduces Tiled's JSON layout (as used by the room template files).
import os as _os
HERE = _os.path.dirname(_os.path.abspath(__file__)) + '/'
REPO = _os.path.abspath(HERE + '../..')
import json


def _scalar(v):
    return json.dumps(v, ensure_ascii=False)


def _val(v, ind):
    # ind = indentation of the key that owns this value
    if isinstance(v, dict):
        return '\n' + _obj(v, ind + 3)
    if isinstance(v, list):
        if not v:
            return '[]'
        if all(not isinstance(x, (dict, list)) for x in v):
            return '[' + ', '.join(_scalar(x) for x in v) + ']'
        parts = []
        for x in v:
            parts.append(_obj(x, ind + 7) if isinstance(x, dict) else ' ' * (ind + 7) + _val(x, ind + 7))
        return '[\n' + ', \n'.join(parts) + ']'
    return _scalar(v)


def _obj(d, ind):
    pad = ' ' * ind
    lines = [pad + ' ' + _scalar(k) + ':' + _val(v, ind + 1) for k, v in d.items()]
    return pad + '{\n' + ',\n'.join(lines) + '\n' + pad + '}'


def dumps(d):
    lines = [' ' + _scalar(k) + ':' + _val(v, 1) for k, v in d.items()]
    s = '{\n' + ',\n'.join(lines) + '\n}'
    return '{ ' + s[3:]
