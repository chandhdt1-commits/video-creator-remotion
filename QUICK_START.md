# 🚀 Quick Start Guide

## 5 phút để tạo video đầu tiên

### Step 1: Setup (Tùy chọn)
```bash
# Sử dụng setup script tự động (Linux/Mac)
chmod +x setup.sh
./setup.sh

# Hoặc install thủ công
npm install
```

### Step 2: Khởi động ứng dụng
```bash
npm run dev
```
Mở http://localhost:3000 trong browser

### Step 3: Tạo Video
1. Nhập chủ đề video (ví dụ: "Trí Tuệ Nhân Tạo")
2. Chọn thời lượng (30-300 giây)
3. Chọn ngôn ngữ
4. Chọn màu sắc (hoặc custom)
5. Click "Tạo Video"

### Step 4: Tìm Video Output
Video sẽ được lưu trong: `videos/output/video_*.mp4`

---

## 📖 Ví dụ Sử Dụng

### CLI - Tạo video nhanh
```bash
# Chủ đề mặc định
npm run create:video

# Custom topic
tsx src/video-creator-cli.ts "Machine Learning" 60 en

# Video dài hơn
tsx src/video-creator-cli.ts "Blockchain Technology" 120 vi
```

### UI - Tạo video từ web
1. Mở http://localhost:3000
2. Fill form
3. Click "Tạo Video"
4. Download từ output section

---

## 🎨 Tùy chỉnh Màu Sắc

### Từ UI
Chọn color scheme hoặc dùng color picker

### Từ CLI
Edit `src/video-creator-cli.ts`:
```typescript
backgroundColor: '#0a0e27',  // Dark blue
accentColor: '#00d4ff',      // Cyan
```

### Color Presets
```
Blue & Cyan       → #0a0e27 + #00d4ff
Purple & Pink     → #1a0033 + #ff6b9d
Green & Lime      → #0d1f0d + #00ff00
Red & Gold        → #2d0a0a + #ffaa00
```

---

## ⚡ Troubleshooting

### "Port 3000 already in use"
```bash
# Kill process
lsof -ti:3000 | xargs kill -9
npm run dev
```

### "FFmpeg not found"
```bash
brew install ffmpeg       # macOS
sudo apt-get install ffmpeg  # Linux
choco install ffmpeg      # Windows
```

### "Cannot find module"
```bash
npm install
npm install remotion @remotion/cli @remotion/renderer
```

### "Voice generation failed"
```bash
pip install gtts
gtts-cli "test" --lang en --file test.mp3
```

---

## 📚 Supported Languages

| Code | Language |
|------|----------|
| vi | Tiếng Việt |
| en | English |
| es | Español |
| fr | Français |
| de | Deutsch |
| ja | 日本語 |
| zh | 中文 |

[View all →](https://gtts.readthedocs.io/en/latest/module.html#module-gtts.lang)

---

## 💡 Tips & Tricks

### Render multiple videos
```bash
for topic in "AI" "Python" "JavaScript"; do
  npm run create:video -- "$topic" 60 en
done
```

### Preview only (no audio)
```bash
npm run dev
# Edit src/remotion-video-composition.tsx
# Remove <Audio /> component
```

### Export as GIF
```bash
remotion render video-with-audio output.gif --codec gif
```

### Batch render with high quality
```bash
remotion render video-with-audio output.mp4 \
  --codec h264 --crf 18 --quality high --concurrency 4
```

---

## 📁 File Structure

```
src/
├── App.tsx                    # React UI
├── App.css                    # Styles
├── index.tsx                  # Remotion entry
├── remotion-video-composition.tsx  # Video templates
└── video-creator-cli.ts       # CLI tool
```

---

## 🔗 Resources

- 📖 [Remotion Docs](https://www.remotion.dev/docs)
- 🎨 [React Hooks](https://react.dev/reference/react/hooks)
- 🎙️ [gTTS Docs](https://gtts.readthedocs.io/)
- ⚙️ [FFmpeg Guide](https://ffmpeg.org/documentation.html)

---

## 🎯 Next Steps

1. ✅ Read [README.md](./README.md) for full documentation
2. 🎨 Customize [src/remotion-video-composition.tsx](./src/remotion-video-composition.tsx)
3. 🎵 Add background music or effects
4. 🚀 Deploy to production

---

## 🆘 Need Help?

- 📧 Check [README.md](./README.md) FAQ section
- 🐛 Create GitHub issue
- 💬 Join Remotion Discord community

**Happy video creating! 🎬**
