#!/usr/bin/env python3
"""Generate RETURN's App Store icon PNGs with Python's standard library."""
from pathlib import Path
import math, struct, zlib

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "ReturnApp" / "Assets.xcassets" / "AppIcon.appiconset"
SIZES = [40, 58, 60, 80, 87, 120, 180, 1024]
BG = (111, 119, 84)
FG = (244, 240, 231)

def png_rgb(path: Path, width: int, height: int, pixels: bytes) -> None:
    def chunk(kind: bytes, data: bytes) -> bytes:
        return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data) & 0xffffffff)
    raw = b"".join(b"\x00" + pixels[y*width*3:(y+1)*width*3] for y in range(height))
    payload = b"\x89PNG\r\n\x1a\n"
    payload += chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0))
    payload += chunk(b"IDAT", zlib.compress(raw, 9))
    payload += chunk(b"IEND", b"")
    path.write_bytes(payload)

def make(size: int) -> bytes:
    cx = cy = (size - 1) / 2
    outer, inner = size * 0.31, size * 0.20
    start, end = math.radians(38), math.radians(302)
    pix = bytearray()
    for y in range(size):
        for x in range(size):
            dx, dy = x - cx, y - cy
            r = math.hypot(dx, dy)
            a = math.atan2(dy, dx)
            if a < 0: a += 2 * math.pi
            on_arc = inner <= r <= outer and not (end < a < start + 2*math.pi)
            # arrow head at upper-right end of the return arc
            ax, ay = cx + outer * math.cos(start), cy + outer * math.sin(start)
            # triangle pointing counter-clockwise/up-left
            scale = size / 1024
            p1 = (ax - 12*scale, ay - 94*scale)
            p2 = (ax + 104*scale, ay + 3*scale)
            p3 = (ax - 50*scale, ay + 40*scale)
            def area(px, py, a, b, c):
                return abs((a[0]*(b[1]-c[1]) + b[0]*(c[1]-a[1]) + c[0]*(a[1]-b[1]))/2)
            tri = area(x,y,p1,p2,p3)
            inside_tri = abs(tri - (area(x,y,p2,p3,p1)+area(x,y,p3,p1,p2)+area(x,y,p1,p2,p3))) < max(1, size*0.002)
            color = FG if on_arc or inside_tri else BG
            pix.extend(color)
    return bytes(pix)

def main():
    OUT.mkdir(parents=True, exist_ok=True)
    for size in SIZES:
        png_rgb(OUT / f"AppIcon-{size}.png", size, size, make(size))
        print(f"generated AppIcon-{size}.png")

if __name__ == "__main__":
    main()
