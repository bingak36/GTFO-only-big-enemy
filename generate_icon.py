"""
BigEnemyMode icon.png 생성기 (Python 표준 라이브러리만 사용)
실행: python generate_icon.py
"""
import struct
import zlib
import math
import os

W, H = 256, 256

# --- 픽셀 배열 (RGB) ---
pixels = [[[0, 0, 0] for _ in range(W)] for _ in range(H)]

def clamp(v): return max(0, min(255, int(v)))

def set_px(x, y, r, g, b):
    if 0 <= x < W and 0 <= y < H:
        pixels[y][x] = [clamp(r), clamp(g), clamp(b)]

def fill_rect(x0, y0, x1, y1, r, g, b):
    for y in range(y0, y1):
        for x in range(x0, x1):
            set_px(x, y, r, g, b)

def fill_ellipse(cx, cy, rx, ry, r, g, b):
    for y in range(cy - ry, cy + ry + 1):
        for x in range(cx - rx, cx + rx + 1):
            if rx > 0 and ry > 0:
                if ((x - cx) / rx) ** 2 + ((y - cy) / ry) ** 2 <= 1.0:
                    set_px(x, y, r, g, b)

def draw_text_B(ox, oy, scale, r, g, b):
    """픽셀 폰트로 'BIG ENEMY MODE' 그리기"""
    chars = {
        'B': [(0,0),(0,1),(0,2),(0,3),(0,4),(1,0),(2,0),(3,0),(1,2),(2,2),(3,2),(1,4),(2,4),(3,4),(4,1),(4,3)],
        'I': [(1,0),(2,0),(3,0),(2,1),(2,2),(2,3),(1,4),(2,4),(3,4)],
        'G': [(1,0),(2,0),(3,0),(0,1),(0,2),(0,3),(1,4),(2,4),(3,4),(4,4),(4,3),(4,2),(3,2)],
        'E': [(0,0),(1,0),(2,0),(3,0),(0,1),(0,2),(1,2),(2,2),(0,3),(0,4),(1,4),(2,4),(3,4)],
        'N': [(0,0),(0,1),(0,2),(0,3),(0,4),(1,1),(2,2),(3,3),(4,0),(4,1),(4,2),(4,3),(4,4)],
        'M': [(0,0),(0,1),(0,2),(0,3),(0,4),(1,1),(2,2),(3,1),(4,0),(4,1),(4,2),(4,3),(4,4)],
        'Y': [(0,0),(1,1),(2,2),(2,3),(2,4),(3,1),(4,0)],
        'O': [(1,0),(2,0),(3,0),(0,1),(4,1),(0,2),(4,2),(0,3),(4,3),(1,4),(2,4),(3,4)],
        'D': [(0,0),(0,1),(0,2),(0,3),(0,4),(1,0),(2,0),(3,1),(3,2),(3,3),(1,4),(2,4)],
        ' ': [],
    }
    x_cursor = ox
    for ch in 'BIG':
        pattern = chars.get(ch, [])
        for (px_, py_) in pattern:
            for dy in range(scale):
                for dx in range(scale):
                    set_px(x_cursor + px_*scale + dx, oy + py_*scale + dy, r, g, b)
        x_cursor += 5 * scale + scale

def draw_small_text(text, ox, oy, scale, r, g, b):
    chars = {
        'E': [(0,0),(1,0),(2,0),(3,0),(0,1),(0,2),(1,2),(0,3),(0,4),(1,4),(2,4),(3,4)],
        'N': [(0,0),(0,1),(0,2),(0,3),(0,4),(1,1),(2,2),(3,3),(4,0),(4,1),(4,2),(4,3),(4,4)],
        'M': [(0,0),(0,1),(0,2),(0,3),(0,4),(1,1),(2,2),(3,1),(4,0),(4,1),(4,2),(4,3),(4,4)],
        'Y': [(0,0),(1,1),(2,2),(2,3),(2,4),(3,1),(4,0)],
        'O': [(1,0),(2,0),(3,0),(0,1),(4,1),(0,2),(4,2),(0,3),(4,3),(1,4),(2,4),(3,4)],
        'D': [(0,0),(0,1),(0,2),(0,3),(0,4),(1,0),(2,0),(3,1),(3,2),(3,3),(1,4),(2,4)],
        ' ': [],
    }
    x_cursor = ox
    for ch in text:
        pattern = chars.get(ch, [])
        for (px_, py_) in pattern:
            for dy in range(scale):
                for dx in range(scale):
                    set_px(x_cursor + px_*scale + dx, oy + py_*scale + dy, r, g, b)
        x_cursor += 5 * scale + scale

# === 그리기 시작 ===

# 1. 배경 (어두운 붉은-검정 그라디언트)
for y in range(H):
    for x in range(W):
        t = (x + y) / (W + H)
        pixels[y][x] = [clamp(20 + 15*t), clamp(5), clamp(5)]

# 2. 테두리
for i in range(5):
    alpha = 1.0 - i * 0.15
    col = clamp(180 * alpha)
    for x in range(i, W - i):
        set_px(x, i, col, 30, 30)
        set_px(x, H-1-i, col, 30, 30)
    for y in range(i, H - i):
        set_px(i, y, col, 30, 30)
        set_px(W-1-i, y, col, 30, 30)

# 3. 몸통 (크고 위협적인 실루엣)
fill_ellipse(128, 115, 68, 58, 160, 35, 35)   # 어두운 몸통
fill_ellipse(128, 112, 62, 52, 190, 45, 45)   # 밝은 몸통

# 4. 머리 위 뿔 (빅 적의 특징)
for i in range(20):
    w = 8 - i // 3
    for dx in range(-w, w+1):
        set_px(105 + dx, 58 + i, clamp(160 + i*2), 35, 35)
        set_px(151 + dx, 58 + i, clamp(160 + i*2), 35, 35)

# 5. 눈 (노란 빛나는 눈)
fill_ellipse(108, 103, 16, 14, 255, 210, 0)
fill_ellipse(148, 103, 16, 14, 255, 210, 0)
# 눈 광채
fill_ellipse(108, 103, 10, 9, 255, 240, 80)
fill_ellipse(148, 103, 10, 9, 255, 240, 80)
# 동공
fill_ellipse(110, 104, 5, 6, 10, 10, 10)
fill_ellipse(150, 104, 5, 6, 10, 10, 10)
# 눈 반짝임
fill_ellipse(106, 100, 3, 3, 255, 255, 255)
fill_ellipse(146, 100, 3, 3, 255, 255, 255)

# 6. 입 (날카로운 이빨)
for i, (x0, x1) in enumerate([(102,122),(116,136),(130,150)]):
    fill_rect(x0, 140, x1, 148, 220, 220, 220)
    # 이빨 사이 어두움
    if i < 2:
        fill_rect(x1-1, 140, x1+1, 145, 30, 10, 10)

# 7. 텍스트 'BIG' (그림자 + 본체)
draw_text_B(18, 178, 5, 80, 0, 0)     # 그림자
draw_text_B(16, 176, 5, 255, 255, 255) # 본체

# 8. 텍스트 'ENEMY MODE'
draw_small_text('ENEMY MODE', 14, 228, 3, 60, 0, 0)     # 그림자
draw_small_text('ENEMY MODE', 12, 226, 3, 220, 180, 180) # 본체

# === PNG 저장 ===
def write_png(filename, pixels, width, height):
    def make_chunk(tag, data):
        body = tag + data
        return struct.pack('>I', len(data)) + body + struct.pack('>I', zlib.crc32(body) & 0xFFFFFFFF)

    raw_rows = b''
    for row in pixels:
        raw_rows += b'\x00'
        for r, g, b in row:
            raw_rows += bytes([r, g, b])

    ihdr = struct.pack('>IIBBBBB', width, height, 8, 2, 0, 0, 0)
    idat_data = zlib.compress(raw_rows, 9)

    with open(filename, 'wb') as f:
        f.write(b'\x89PNG\r\n\x1a\n')
        f.write(make_chunk(b'IHDR', ihdr))
        f.write(make_chunk(b'IDAT', idat_data))
        f.write(make_chunk(b'IEND', b''))

out_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'icon.png')
write_png(out_path, pixels, W, H)
print(f'icon.png 생성 완료: {out_path}')
