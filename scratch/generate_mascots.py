import struct
import zlib
import os
import math

def make_png(filename, width, height, draw_func):
    pixels = bytearray()
    for y in range(height):
        pixels.append(0) # filter type 0
        for x in range(width):
            r, g, b, a = draw_func(x, y, width, height)
            r = min(255, max(0, int(r)))
            g = min(255, max(0, int(g)))
            b = min(255, max(0, int(b)))
            a = min(255, max(0, int(a)))
            pixels.extend([r, g, b, a])
    
    compressed = zlib.compress(bytes(pixels), level=9)
    
    def chunk(c_type, data):
        return struct.pack('>I', len(data)) + c_type + data + struct.pack('>I', zlib.crc32(c_type + data) & 0xffffffff)

    header = struct.pack('>IIBBBBB', width, height, 8, 6, 0, 0, 0)
    png_data = b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', header) + chunk(b'IDAT', compressed) + chunk(b'IEND', b'')
    
    os.makedirs(os.path.dirname(filename), exist_ok=True)
    with open(filename, 'wb') as f:
        f.write(png_data)
    print(f"Successfully generated {filename} ({width}x{height})")

def blend(bg, fg, alpha):
    return [bg[i] * (1 - alpha) + fg[i] * alpha for i in range(3)]

# --- Draw Functions ---

def draw_idle(x, y, w, h):
    cx, cy = w / 2, h / 2
    # Distance from center
    dx, dy = x - cx, y - cy
    dist = math.sqrt(dx*dx + dy*dy)
    
    # Outer cyan glow halo
    if dist < 110:
        glow_alpha = math.pow((110 - dist) / 110, 2) * 0.35
        base_r, base_g, base_b = 0, 229, 255
    else:
        glow_alpha = 0
        base_r, base_g, base_b = 0, 0, 0

    # Body (Navy Hoodie)
    body_y = y - (cy + 25)
    body_x = x - cx
    if body_y > 0 and (body_x**2 / 55**2 + body_y**2 / 60**2) <= 1:
        return 30, 34, 53, 255 # Navy #1E2235

    # Robot Head Rounded Box (Cyan border + dark visor)
    head_x = abs(dx)
    head_y = abs(dy + 15)
    
    if head_x <= 65 and head_y <= 50:
        # Head Outer Shell (Electric Cyan Border)
        if head_x >= 58 or head_y >= 43:
            return 0, 229, 255, 255
        # Visor inside
        if head_x <= 52 and head_y <= 37:
            # Eyes (Glowing Cyan Circles)
            eye1_dist = math.sqrt((x - (cx - 22))**2 + (y - (cy - 20))**2)
            eye2_dist = math.sqrt((x - (cx + 22))**2 + (y - (cy - 20))**2)
            if eye1_dist <= 10 or eye2_dist <= 10:
                return 0, 255, 240, 255
            # Smile line
            mouth_y = y - (cy - 0)
            mouth_x = abs(x - cx)
            if mouth_y >= 0 and mouth_y <= 6 and mouth_x <= 15 and abs(mouth_y - (mouth_x**2)/40) <= 2:
                return 0, 229, 255, 255
            
            return 13, 17, 23, 255 # Deep IDE #0D1117
        return 22, 27, 38, 255

    # Antenna
    if abs(dx) <= 3 and -75 <= dy + 15 <= -50:
        return 0, 229, 255, 255
    antenna_tip = math.sqrt(dx*dx + (dy + 15 + 78)**2)
    if antenna_tip <= 8:
        return 0, 255, 240, 255

    if glow_alpha > 0:
        return int(base_r), int(base_g), int(base_b), int(glow_alpha * 255)
    return 0, 0, 0, 0

def draw_thinking(x, y, w, h):
    cx, cy = w / 2, h / 2 + 10
    dx, dy = x - cx, y - cy
    dist = math.sqrt(dx*dx + dy*dy)

    # Lightbulb at top-right
    lb_x, lb_y = cx + 55, cy - 75
    lb_dist = math.sqrt((x - lb_x)**2 + (y - lb_y)**2)
    if lb_dist <= 18:
        # Yellow glow
        return 255, 235, 59, 255
    if lb_dist <= 28:
        return 255, 235, 59, int((28 - lb_dist)/10 * 180)

    # Body
    body_y = y - (cy + 25)
    body_x = x - cx
    if body_y > 0 and (body_x**2 / 55**2 + body_y**2 / 60**2) <= 1:
        return 30, 34, 53, 255

    # Head
    head_x = abs(dx)
    head_y = abs(dy + 15)
    if head_x <= 65 and head_y <= 50:
        if head_x >= 58 or head_y >= 43:
            return 0, 229, 255, 255
        if head_x <= 52 and head_y <= 37:
            # Looking up right eyes (questioning)
            eye1_dist = math.sqrt((x - (cx - 18))**2 + (y - (cy - 24))**2)
            eye2_dist = math.sqrt((x - (cx + 26))**2 + (y - (cy - 24))**2)
            if eye1_dist <= 9 or eye2_dist <= 11:
                return 255, 235, 59, 255
            # Puzzled mouth 'o'
            m_dist = math.sqrt((x - (cx + 5))**2 + (y - (cy + 5))**2)
            if 3 <= m_dist <= 7:
                return 0, 229, 255, 255
            return 13, 17, 23, 255
        return 22, 27, 38, 255

    # Hand on chin
    hand_dist = math.sqrt((x - (cx - 35))**2 + (y - (cy + 30))**2)
    if hand_dist <= 12:
        return 0, 229, 255, 255

    if dist < 110:
        return 0, 117, 255, int(math.pow((110 - dist)/110, 2) * 60)
    return 0, 0, 0, 0

def draw_celebrate(x, y, w, h):
    cx, cy = w / 2, h / 2 + 5
    dx, dy = x - cx, y - cy
    dist = math.sqrt(dx*dx + dy*dy)

    # Green victory sparkles
    sparkle1 = math.sqrt((x - (cx - 70))**2 + (y - (cy - 60))**2)
    sparkle2 = math.sqrt((x - (cx + 70))**2 + (y - (cy - 60))**2)
    if sparkle1 <= 12 or sparkle2 <= 12:
        return 0, 230, 118, 255

    # Body with raised arms
    body_y = y - (cy + 25)
    body_x = x - cx
    if body_y > 0 and (body_x**2 / 55**2 + body_y**2 / 60**2) <= 1:
        return 30, 34, 53, 255

    # Head
    head_x = abs(dx)
    head_y = abs(dy + 15)
    if head_x <= 65 and head_y <= 50:
        if head_x >= 58 or head_y >= 43:
            return 0, 230, 118, 255 # Green outline
        if head_x <= 52 and head_y <= 37:
            # Happy star/joy eyes '^' '^'
            e1 = abs(x - (cx - 22)) + abs(y - (cy - 20))
            e2 = abs(x - (cx + 22)) + abs(y - (cy - 20))
            if e1 <= 10 or e2 <= 10:
                return 0, 230, 118, 255
            # Big smile
            mouth_y = y - (cy - 4)
            mouth_x = abs(x - cx)
            if mouth_y >= 0 and mouth_y <= 12 and mouth_x <= 20 and (mouth_y >= (mouth_x**2)/35):
                return 0, 230, 118, 255
            return 13, 17, 23, 255
        return 22, 27, 38, 255

    if dist < 115:
        return 0, 230, 118, int(math.pow((115 - dist)/115, 2) * 90)
    return 0, 0, 0, 0

def draw_wrong(x, y, w, h):
    cx, cy = w / 2, h / 2 + 5
    dx, dy = x - cx, y - cy
    dist = math.sqrt(dx*dx + dy*dy)

    # Bug icon floating nearby
    bug_x, bug_y = cx + 65, cy - 40
    bug_dist = math.sqrt((x - bug_x)**2 + (y - bug_y)**2)
    if bug_dist <= 14:
        return 255, 51, 102, 255 # Crimson red

    # Body
    body_y = y - (cy + 25)
    body_x = x - cx
    if body_y > 0 and (body_x**2 / 55**2 + body_y**2 / 60**2) <= 1:
        return 30, 34, 53, 255

    # Head
    head_x = abs(dx)
    head_y = abs(dy + 15)
    if head_x <= 65 and head_y <= 50:
        if head_x >= 58 or head_y >= 43:
            return 255, 51, 102, 255 # Crimson border
        if head_x <= 52 and head_y <= 37:
            # X X eyes
            eye1_x = abs(x - (cx - 22)) == abs(y - (cy - 20)) and abs(x - (cx - 22)) <= 8
            eye2_x = abs(x - (cx + 22)) == abs(y - (cy - 20)) and abs(x - (cx + 22)) <= 8
            if eye1_x or eye2_x:
                return 255, 51, 102, 255
            # Sad mouth
            mouth_y = y - (cy + 8)
            mouth_x = abs(x - cx)
            if mouth_y <= 0 and mouth_y >= -8 and mouth_x <= 16 and abs(-mouth_y - (mouth_x**2)/35) <= 2:
                return 255, 51, 102, 255
            return 13, 17, 23, 255
        return 22, 27, 38, 255

    if dist < 110:
        return 255, 51, 102, int(math.pow((110 - dist)/110, 2) * 75)
    return 0, 0, 0, 0

def draw_streak(x, y, w, h):
    cx, cy = w / 2, h / 2 + 5
    dx, dy = x - cx, y - cy
    dist = math.sqrt(dx*dx + dy*dy)

    # Purple Neon & Fire Aura
    if dist < 125:
        aura_val = math.sin(dist * 0.1) * 0.5 + 0.5
        alpha = (1 - dist / 125) * 0.65
        return int(157 * aura_val + 96), 78, 221, int(alpha * 255)

    # Body
    body_y = y - (cy + 25)
    body_x = x - cx
    if body_y > 0 and (body_x**2 / 55**2 + body_y**2 / 60**2) <= 1:
        return 30, 34, 53, 255

    # Head
    head_x = abs(dx)
    head_y = abs(dy + 15)
    if head_x <= 65 and head_y <= 50:
        if head_x >= 58 or head_y >= 43:
            return 157, 78, 221, 255 # Purple Neon outline #9D4EDD
        if head_x <= 52 and head_y <= 37:
            # Overpowered Electric Eyes
            eye1_dist = math.sqrt((x - (cx - 22))**2 + (y - (cy - 20))**2)
            eye2_dist = math.sqrt((x - (cx + 22))**2 + (y - (cy - 20))**2)
            if eye1_dist <= 12 or eye2_dist <= 12:
                return 255, 0, 255, 255 # Magenta Electric
            # Fierce grin
            mouth_y = y - (cy - 2)
            mouth_x = abs(x - cx)
            if mouth_y >= 0 and mouth_y <= 8 and mouth_x <= 22:
                return 157, 78, 221, 255
            return 13, 17, 23, 255
        return 22, 27, 38, 255

    return 0, 0, 0, 0

if __name__ == '__main__':
    target_dir = 'd:/Untense/byte_quest/assets/images'
    make_png(f'{target_dir}/mascot_idle.png', 256, 256, draw_idle)
    make_png(f'{target_dir}/mascot_thinking.png', 256, 256, draw_thinking)
    make_png(f'{target_dir}/mascot_celebrate.png', 256, 256, draw_celebrate)
    make_png(f'{target_dir}/mascot_wrong.png', 256, 256, draw_wrong)
    make_png(f'{target_dir}/mascot_streak.png', 256, 256, draw_streak)
    print("All mascot assets created successfully!")
