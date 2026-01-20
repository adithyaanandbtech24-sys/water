from PIL import Image

def replace_background(input_path, output_path, bg_color=(0, 0, 0), new_color=(255, 192, 203), tolerance=30):
    img = Image.open(input_path).convert("RGBA")
    datas = img.getdata()
    
    newData = []
    for item in datas:
        # Check if pixel is close to black (or the bg color)
        # item is (R, G, B, A)
        if abs(item[0] - bg_color[0]) < tolerance and \
           abs(item[1] - bg_color[1]) < tolerance and \
           abs(item[2] - bg_color[2]) < tolerance:
            newData.append((new_color[0], new_color[1], new_color[2], 255))
        else:
            newData.append(item)
            
    img.putdata(newData)
    img.save(output_path, "PNG")
    print(f"Processed image saved to {output_path}")

# Targeted replacement: Black -> Pink
replace_background("original_panda.jpg", "Sources/Resources/panda.png", bg_color=(0,0,0), new_color=(255, 182, 193))
