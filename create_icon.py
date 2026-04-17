from PIL import Image, ImageDraw, ImageFont

size = 256
img = Image.new('RGB', (size, size), 'white')
draw = ImageDraw.Draw(img)

draw.ellipse([10, 10, size-10, size-10], fill='#1a365d', outline='#d4af37', width=8)

try:
    font = ImageFont.truetype("arial.ttf", 160)
except:
    font = ImageFont.load_default()

text = "U"
bbox = draw.textbbox((0, 0), text, font=font)
text_width = bbox[2] - bbox[0]
text_height = bbox[3] - bbox[1]
x = (size - text_width) // 2
y = (size - text_height) // 2 - 10

draw.text((x, y), text, fill='#d4af37', font=font)

img.save('icon.png')
print("Created icon.png")